var navigationCamControllerMWASD = (function() {
    	

	var panSpeed = 0.2500;
	var zoomSpeed = 1.500;
	var rotateCamYSpeed = 0.250;
	var rotateCamXSpeed = 0.250;
	
	
	var isMouseDown = false; 
	var isLeftMouseDown = false;
	var isRightMouseDown = false;
	var mouseMoved = false;

	var mouseDownTime = 0;

	var mousePosX;
	var mousePosY;

	var angleX = 0.0;
	var angleY = 0.0;

	//camera
	var camMatrix;
	var viewMatrix;
	
	//x3dom objects
	var x3domRuntime;
	var viewarea;
	var viewpoint;

	var centerOfRotationX3DomElement;
    
	//original functions from x3dom viewarea
	var original_getViewMatrix;
	var original_animateTo;
	var original_tick;
    
	
	//config parameters	
	var controllerConfig = {		
		setCenterOfRotation : false,
		setCenterOfRotationFocus: false,
		showCenterOfRotation: false,
		macUser: false,
		active: false
	}
    
	function initialize(setupConfig){	

		application.transferConfigParams(setupConfig, controllerConfig);	
				
	}
	
	function activate(){
		
		if(!controllerConfig.active){
			return;
		}

		//get reference of x3dom objects
		x3domRuntime = document.getElementById('x3dElement').runtime;		
		viewarea = x3domRuntime.canvas.doc._viewarea;	
		viewpoint = viewarea._scene.getViewpoint();


		// Center of Rotation Helper Element
		if(controllerConfig.showCenterOfRotation){

			centerOfRotationX3DomElement = document.createElement('TRANSFORM');

			var shape = document.createElement('Shape');
			centerOfRotationX3DomElement.appendChild(shape);
			
			var appearance = document.createElement('Appearance');	
			shape.appendChild(appearance);
			var material = document.createElement('Material');	
			material.setAttribute("diffuseColor", x3dom.fields.SFColor.colorParse("orange"));
			appearance.appendChild(material);	
			
					
			var sphere = document.createElement('Sphere');
			sphere.setAttribute("radius", "5");
			shape.appendChild(sphere);

			canvasManipulator.addElement(centerOfRotationX3DomElement);
		}

		
		
		//mouse actions
		actionController.actions.mouse.key[1].down.subscribe(leftMouseDown);
		actionController.actions.mouse.key[2].down.subscribe(rightMouseDown);

		actionController.actions.mouse.down.subscribe(mousedown);
		actionController.actions.mouse.up.subscribe(mouseup);

		actionController.actions.mouse.move.subscribe(mousemove);

		actionController.actions.mouse.scroll.subscribe(mousescroll);
		


		//overwrite viewmatrix function for full control
		viewMatrix = viewarea.getViewMatrix();
		camMatrix = viewMatrix.inverse();

		original_getViewMatrix	= viewarea.getViewMatrix; 	
		original_animateTo		= viewarea.animateTo;	
		original_tick			= viewarea.tick;	
		
		
		viewarea.getViewMatrix 	= getViewMatrix;
		viewarea.animateTo 		= animateTo;
		viewarea.tick 			= tick;

		var center = x3dom.fields.SFVec3f.copy(viewpoint.getCenterOfRotation());

		var myCam = getCamMatrix();

		var from = myCam.e3();
		var at = center;
		var up = myCam.e1();

		myCam = x3dom.fields.SFMatrix4f.lookAt(from, at, up);
		myCam = calcOrbit(0, 0);

		setCamMatrix(myCam);		

	}

	function reset(){
		isMouseDown = false;	
		isLeftMouseDown = false;
		isRightMouseDown = false;
		mouseMoved = false;
		mousePosX = 0;
		mousePosY = 0;

		if(controllerConfig.showCenterOfRotation){
			var centerOfRotation = viewpoint.getCenterOfRotation();
			centerOfRotationX3DomElement.setAttribute("translation", centerOfRotation.toString());
		}
	}

	function deactivate(){

		//mouse actions
		actionController.actions.mouse.key[1].down.unsubscribe(leftMouseDown);
		actionController.actions.mouse.key[2].down.unsubscribe(rightMouseDown);

		actionController.actions.mouse.down.unsubscribe(mousedown);
		actionController.actions.mouse.up.unsubscribe(mouseup);

		actionController.actions.mouse.move.unsubscribe(mousemove);

		actionController.actions.mouse.scroll.unsubscribe(mousescroll);

	
		viewarea.getViewMatrix 	= original_getViewMatrix;
		viewarea.animateTo 		= original_animateTo;		
		viewarea.tick 			= original_tick;		

		if(controllerConfig.showCenterOfRotation){
			canvasManipulator.removeElement(centerOfRotationX3DomElement);	
		}

	}


	function leftMouseDown(eventObject){
		isLeftMouseDown = true;
	}

	function rightMouseDown(eventObject){
		isRightMouseDown = true;
	}

	function mousedown(eventObject){		
		if(!isMouseDown){
			isMouseDown = true;

			mouseDownTime = Date.now();	


			mousePosX = eventObject.layerX;		
			mousePosY = eventObject.layerY;

		}
	}
 
	function mouseup(eventObject){		
		

		//center of rotation
		if(controllerConfig.setCenterOfRotation && controllerConfig.setCenterOfRotationFocus && !mouseMoved){
								
			if(eventObject.entity){

				var mouseUpTime = Date.now();	
				var mousePressedTime = mouseUpTime - mouseDownTime;				
				
			}
		}

		isMouseDown = false;	
		isLeftMouseDown = false;
		isRightMouseDown = false;
		mouseMoved = false;
	}
	
	function mousemove(eventObject, timestamp){							
		if(isMouseDown){		

			mouseMoved = true;


			var x = eventObject.layerX;		
			var y = eventObject.layerY;

			var dx = x - mousePosX;
			var dy = y - mousePosY;
			
			if(isLeftMouseDown){
				pan(dx, dy);
			}
			if(isRightMouseDown){
				// rotateModel(dx, dy);
				rotateCam(dx, dy);
			}

			mousePosX = x;
			mousePosY = y;					

		}	

		// updateTargetPointLine();
			

	}	


	

	function mousescroll(eventObject, timestamp){

		var zoomFactor = -2 * eventObject.detail;

		if(controllerConfig.macUser){
			zoomFactor = zoomFactor * -1;
		}

		// var newCam = zoom(zoomFactor);	
		// var newCam = move(zoomFactor);
		var newCam = moveByScroll(eventObject, zoomFactor);
		setCamMatrix(newCam);
        
    }


	function getViewMatrix(){
		return viewMatrix.copy();
	}

	function getCamMatrix(){
		return camMatrix.copy();
	}

	function setCamMatrix(newCamMatrix){
		camMatrix = newCamMatrix.copy();
		viewMatrix = camMatrix.inverse();

		if(controllerConfig.showCenterOfRotation){
			var centerOfRotation = viewpoint.getCenterOfRotation();
			centerOfRotationX3DomElement.setAttribute("translation", centerOfRotation.toString());
		}
	}


	
	function rotateCam(dx, dy){

		var alpha = - (dy * 2 * Math.PI) / viewarea._height * rotateCamYSpeed;
		var beta = (dx * 2 * Math.PI) / viewarea._width * rotateCamXSpeed;

		var myCam = calcOrbitReverse(alpha, beta);
		setCamMatrix(myCam);

	}	

	function pan(dx, dy){

		var myCam = getCamMatrix();

		var d = (viewarea._scene._lastMax.subtract(viewarea._scene._lastMin)).length();
		d = ((d < x3dom.fields.Eps) ? 1 : d) * panSpeed;

		var tx = -d * dx / viewarea._width;
		var ty =  d * dy / viewarea._height;


		var up   	= myCam.e1();
		var from 	= myCam.e3(); 
		var s 		= myCam.e0();

		// add xy offset to camera position for pan
		from = from.addScaled(up, ty);
		from = from.addScaled(s, tx);

		// add xy offset to look-at position
		var cor = viewpoint.getCenterOfRotation();
		cor = cor.addScaled(up, ty);
		cor = cor.addScaled(s, tx);
		viewpoint.setCenterOfRotation(cor);

		// update camera matrix with lookAt() and invert
		myCam = x3dom.fields.SFMatrix4f.lookAt(from, cor, up);
		setCamMatrix(myCam);
	}



	function moveByScroll(eventObject, zoomFactor){

		var d = (viewarea._scene._lastMax.subtract(viewarea._scene._lastMin)).length();
		d = ((d < x3dom.fields.Eps) ? 1 : d) * zoomSpeed;
		
		var zoomAmount = d * zoomFactor / viewarea._height;

		//clamp zoomAmount 
		zoomAmount = Math.min(zoomAmount, 20); //ToDo Config Parameter

		

		//TODO bei ohne :) entity eigenen Punkt aus XY Position der Maus errechnen
		if(eventObject.entity){
			return moveToElement(eventObject, zoomAmount);
		} else {
			return moveToMousPosition(eventObject, zoomAmount);
		}
	}


	function moveToMousPosition(eventObject, zoomAmount){


		var beta = eventObject.layerX - ( viewarea._width / 2);
		beta = beta / viewarea._width * Math.PI / 2;
		
		var alpha = eventObject.layerY - ( viewarea._height / 2);
		alpha = alpha / viewarea._height * Math.PI / 2;

		var myCam = getCamMatrix();		
		var centerOfRotation = viewpoint.getCenterOfRotation();



		var centerOfModel = new x3dom.fields.SFVec3f(0, 0, 0);

		var from = myCam.e3();
		var at 	 = centerOfRotation;
		var up   = myCam.e1();	
		

		var offset = at.subtract(from);

		// angle in xz-plane
		var phi = Math.atan2(offset.x, offset.z);

		// angle from y-axis
		var theta = Math.atan2(Math.sqrt(offset.x * offset.x + offset.z * offset.z), offset.y);

		phi -= beta;
		theta += alpha;

		// // clamp theta
		// theta = Math.max(0.001, theta);

		// Neuer Radius ist die Entfernung der Kamera zum Mittelpunkt
		// -> Dadurch ist die Verschiebung auf den Mauspunkt beim Zoom größer
		//var radius = offset.length();

		
		
		
		var centerOfModelDirection = centerOfModel.subtract(from);
		var radius = centerOfModelDirection.length();



		// calc new cam position
		var rSinPhi = radius * Math.sin(theta);

		offset.x = rSinPhi * Math.sin(phi);
		offset.y = radius  * Math.cos(theta);
		offset.z = rSinPhi * Math.cos(phi);


		//new centerOfRotation
		offset = from.add(offset);

		




				
        
        var dir = offset.subtract(from);
        dir = dir.normalize();

        var newFrom = from.addScaled(dir, zoomAmount);
		var newat = at.addScaled(dir, zoomAmount);

		viewpoint.setCenterOfRotation(newat);

		myCam = x3dom.fields.SFMatrix4f.lookAt(newFrom, newat, up);


		
		return myCam;

	}

	function moveToElement(eventObject, zoomAmount){

		var myCam = getCamMatrix();		

		var centerOfPart = canvasManipulator.getCenterOfEntity(eventObject.entity);		
		var centerOfRotation = viewpoint.getCenterOfRotation();


		var from = myCam.e3();
		var at 	 = centerOfRotation;
		var up   = myCam.e1();			
        
        var dir = centerOfPart.subtract(from);
        dir = dir.normalize();

        var newFrom = from.addScaled(dir, zoomAmount);
		var newat = at.addScaled(dir, zoomAmount);

		viewpoint.setCenterOfRotation(newat);

		myCam = x3dom.fields.SFMatrix4f.lookAt(newFrom, newat, up);
		
		return myCam;

	}





	function calcOrbit(alpha, beta){
		
		var myCam = getCamMatrix();
		var center = x3dom.fields.SFVec3f.copy(viewpoint.getCenterOfRotation());
		
		var up   = myCam.e1();
		var at 	 = center;
		var from = myCam.e3();
		

		var offset = from.subtract(at);

		// angle in xz-plane
		var phi = Math.atan2(offset.x, offset.z);

		// angle from y-axis
		var theta = Math.atan2(Math.sqrt(offset.x * offset.x + offset.z * offset.z), offset.y);

		phi -= beta;
		theta -= alpha;

		// clamp theta
		theta = Math.max(0.001, theta);

		var radius = offset.length();

		// calc new cam position
		var rSinPhi = radius * Math.sin(theta);

		offset.x = rSinPhi * Math.sin(phi);
		offset.y = radius  * Math.cos(theta);
		offset.z = rSinPhi * Math.cos(phi);

		offset = at.add(offset);

		// calc new up vector
		theta -= Math.PI / 2;

		var sinPhi = Math.sin(theta);
		var cosPhi = Math.cos(theta);
		
		up = new x3dom.fields.SFVec3f(sinPhi * Math.sin(phi), cosPhi, sinPhi * Math.cos(phi));

		if (up.y < 0)
			up = up.negate();

		

		return x3dom.fields.SFMatrix4f.lookAt(offset, at, up);
	}

	function calcOrbitReverse(alpha, beta){
		
		var myCam = getCamMatrix();
		var center = x3dom.fields.SFVec3f.copy(viewpoint.getCenterOfRotation());
		

		var at 	 = center;
		var from = myCam.e3();
		

		var offset = at.subtract(from);

		// angle in xz-plane
		var phi = Math.atan2(offset.x, offset.z);

		// angle from y-axis
		var theta = Math.atan2(Math.sqrt(offset.x * offset.x + offset.z * offset.z), offset.y);

		phi -= beta;
		theta -= alpha;

		// // clamp theta
		// theta = Math.max(0.001, theta);

		var radius = offset.length();

		// calc new cam position
		var rSinPhi = radius * Math.sin(theta);

		offset.x = rSinPhi * Math.sin(phi);
		offset.y = radius  * Math.cos(theta);
		offset.z = rSinPhi * Math.cos(phi);

		offset = from.add(offset);

		// calc new up vector
		theta -= Math.PI / 2;

		var sinPhi = Math.sin(theta);
		var cosPhi = Math.cos(theta);
		

		
		var up = new x3dom.fields.SFVec3f(sinPhi * Math.sin(phi), cosPhi, sinPhi * Math.cos(phi));

		if (up.y < 0)
			up = up.negate();


		viewpoint.setCenterOfRotation(offset);

		return x3dom.fields.SFMatrix4f.lookAt(from, offset, up);
	}




	var targetPointLine;

	function updateTargetPointLine(){

		var from = myCam.e3();
		var at 	 = centerOfRotation;
		var up   = myCam.e1();	

		


		var lineFrom = from.clone();
		lineFrom.y = lineFrom.y - 1;




		canvasManipulator.removeElement(targetPointLine);
		targetPointLine = createLine(lineFrom, targetPosition, x3dom.fields.SFColor.colorParse("orange"), 1)
		canvasManipulator.addElement(targetPointLine);
	}



	function createLine(source, target, color, size){
		//calculate attributes
		
		var betrag = (Math.sqrt( Math.pow(target[0] - source[0], 2) + Math.pow(target[1] - source[1], 2) + Math.pow(target[2] - source[2], 2) ));
		var translation = [];	
		
		translation[0] = source[0]+(target[0]-source[0])/2.0;
		translation[1] = source[1]+(target[1]-source[1])/2.0;
		translation[2] = source[2]+(target[2]-source[2])/2.0;	
		
		var scale = []; 
		scale[0] = size;
		scale[1] = betrag;
		scale[2] = size;
		
		var rotation = [];
		rotation[0] = (target[2]-source[2]);
		rotation[1] = 0;
		rotation[2] = (-1.0)*(target[0]-source[0]);
		rotation[3] = Math.acos((target[1] - source[1])/(Math.sqrt( Math.pow(target[0] - source[0], 2) + Math.pow(target[1] - source[1], 2) + Math.pow(target[2] - source[2], 2) )));
					
		//create element
		var transform = document.createElement('Transform');
				
		transform.setAttribute("translation", translation.toString());
		transform.setAttribute("scale", scale.toString());
		transform.setAttribute("rotation", rotation.toString());
			
		var shape = document.createElement('Shape');
		transform.appendChild(shape);
		
		var appearance = document.createElement('Appearance');	
		shape.appendChild(appearance);
		var material = document.createElement('Material');	
		material.setAttribute("diffuseColor", color);
		appearance.appendChild(material);	
		
				
		var cylinder = document.createElement('Cylinder');
		cylinder.setAttribute("radius", "0.25");
		cylinder.setAttribute("height", "1");
		shape.appendChild(cylinder);
			
		return transform;
	}
	




	function tick(timeStamp){
			
		var needMixAnim = false;
		// var env = viewarea._scene.getEnvironment();

		// if (env._vf.enableARC && viewarea.arc == null)
		// {
		// 	viewarea.arc = new x3dom.arc.AdaptiveRenderControl(viewarea._scene);
		// }

		if (viewarea._mixer._beginTime > 0)
		{
			needMixAnim = true;

			if (timeStamp >= viewarea._mixer._beginTime)
			{
				if (timeStamp <= viewarea._mixer._endTime)
				{
					var mat = viewarea._mixer.mix(timeStamp);
					setCamMatrix(mat.inverse());
					// viewarea._scene.getViewpoint().setView(mat);
				}
				else {
					viewarea._mixer._beginTime = 0;
					viewarea._mixer._endTime = 0;

					setCamMatrix(viewarea._mixer._endMat.inverse());
					// viewarea._scene.getViewpoint().setView(viewarea._mixer._endMat);
				}
			}
			else {
				viewarea._mixer._beginTime = 0;
				viewarea._mixer._endTime = 0;
				
				setCamMatrix(viewarea._mixer._beginMat.inverse());
				// viewarea._scene.getViewpoint().setView(viewarea._mixer._beginMat);
			}
		}

		viewarea._lastTS = timeStamp;

		//??? wozu navigateTo?
		
		// var needNavAnim = viewarea.navigateTo(timeStamp);
		// var lastIsAnimating = viewarea._isAnimating;

		// viewarea._lastTS = timeStamp;
		// viewarea._isAnimating = (needMixAnim || needNavAnim);

		// if (viewarea.arc != null )
		// {
		// 	viewarea.arc.update(viewarea.isMovingOrAnimating() ? 1 : 0, viewarea._doc._x3dElem.runtime.getFPS());
		// }


		// return (viewarea._isAnimating || lastIsAnimating);
		return needMixAnim;
	}


	function animateTo(target, prev, dur){
		if (!prev){
			return;
		}

		//hot fix für reset funktion runtime.showAll("negZ");
		if(!prev.inverse){
			prev = getViewMatrix();
						
		}

		var navi = viewarea._scene.getNavigationInfo();
		// prev = prev.getViewMatrix().mult(prev.getCurrentTransform().inverse()).
        //                  mult(viewarea._transMat).mult(viewarea._rotMat);

        viewarea._mixer._beginTime = viewarea._lastTS;

		viewarea._mixer._endTime = viewarea._lastTS + navi._vf.transitionTime;
		
		viewarea._mixer.setBeginMatrix (prev);
		viewarea._mixer.setEndMatrix (target);
		
		// viewarea._scene.getViewpoint().setView(prev);
		
	}



	
		

    return {
        initialize: initialize,
		activate: activate,		
		deactivate: deactivate,
		reset: reset
    };    
})();