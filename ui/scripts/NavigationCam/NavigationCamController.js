var navigationCamController = (function() {
	
	

	var panSpeed = 0.250;
	var zoomSpeed = 5.000;
	
	
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

	var oldCenterElement = null;

	//original functions from x3dom viewarea
	var original_getViewMatrix;
	var original_animateTo;
	var original_tick;
	
	const NAVIGATION_MODES = {
		AXES:				"AXES",
		MOUSE_WASD:			"MOUSE_WASD",
		LOOK_AT_ROTATE:		"LOOK_AT_ROTATE",
	}
    
	
	//config parameters	
	var controllerConfig = {	
		
		//NAVIGATION_MODES - AXES, MOUSE_WASD, LOOK_AT_ROTATE
		modus: NAVIGATION_MODES.AXES,

		zoomToMousePosition: false,
		
		setCenterOfRotation: true,
		setCenterOfRotationFocus: true,
		showCenterOfRotation: true,

		macUser: false,
		active: false
	}




//*********************
//* Initialization
//*********************
    
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
			createCenterOfRotationElement();
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

	function createCenterOfRotationElement(){
		centerOfRotationX3DomElement = document.createElement('TRANSFORM');

		// Y-Axes
		var yTransform = document.createElement('TRANSFORM');			
		// yTransform.setAttribute("transparency", "0.5");
		centerOfRotationX3DomElement.appendChild(yTransform);

		var shape = document.createElement('Shape');
		yTransform.appendChild(shape);
		
		var appearance = document.createElement('Appearance');	
		shape.appendChild(appearance);
		var material = document.createElement('Material');	
		material.setAttribute("diffuseColor", x3dom.fields.SFColor.colorParse("orange"));
		appearance.appendChild(material);	
							
		var cylinder = document.createElement('Cylinder');
		cylinder.setAttribute("radius", "0.5");
		cylinder.setAttribute("height", "1000");
		shape.appendChild(cylinder);

		// X-Axes
		var xTransform = document.createElement('TRANSFORM');
		xTransform.setAttribute("rotation", "0 0 1 1.571");			
		// xTransform.setAttribute("transparency", "0.5");
		centerOfRotationX3DomElement.appendChild(xTransform);

		shape = document.createElement('Shape');
		xTransform.appendChild(shape);
		
		appearance = document.createElement('Appearance');	
		shape.appendChild(appearance);
		material = document.createElement('Material');	
		material.setAttribute("diffuseColor", x3dom.fields.SFColor.colorParse("orange"));
		appearance.appendChild(material);	
							
		cylinder = document.createElement('Cylinder');
		cylinder.setAttribute("radius", "0.5");
		cylinder.setAttribute("height", "1000");
		shape.appendChild(cylinder);


		// Z-Axes
		var zTransform = document.createElement('TRANSFORM');
		zTransform.setAttribute("rotation", "1 0 0 1.571");
		// zTransform.setAttribute("transparency", "0.5");
		centerOfRotationX3DomElement.appendChild(zTransform);

		shape = document.createElement('Shape');
		zTransform.appendChild(shape);
		
		appearance = document.createElement('Appearance');	
		shape.appendChild(appearance);
		material = document.createElement('Material');	
		material.setAttribute("diffuseColor", x3dom.fields.SFColor.colorParse("orange"));
		appearance.appendChild(material);	
							
		cylinder = document.createElement('Cylinder');
		cylinder.setAttribute("radius", "0.5");
		cylinder.setAttribute("height", "1000");
		shape.appendChild(cylinder);

		canvasManipulator.addElement(centerOfRotationX3DomElement);
	}
	
	
	
	function deactivate(){
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

	function reset(){
		isMouseDown = false;	
		isLeftMouseDown = false;
		isRightMouseDown = false;
		mouseMoved = false;
		mousePosX = 0;
		mousePosY = 0;
	}


//*********************
//* User Actions
//*********************


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

			//center of rotation
			if(controllerConfig.setCenterOfRotation && !controllerConfig.setCenterOfRotationFocus){
				if(eventObject.entity){
					setCenterOfRotation(eventObject.entity, false);
				}
			}

		}
	}
 
	function mouseup(eventObject){		
		


		//center of rotation
		if(controllerConfig.setCenterOfRotation && controllerConfig.setCenterOfRotationFocus && !mouseMoved){
								
			if(eventObject.entity){

				var mouseUpTime = Date.now();	
				var mousePressedTime = mouseUpTime - mouseDownTime;

				if(mousePressedTime < 100){
					setCenterOfRotation(eventObject.entity, true);
				}
				
			}
		}

		//Switch Modes
		switch(controllerConfig.modus) {
			case NAVIGATION_MODES.AXES:
				//Nothing
			  break;
			case NAVIGATION_MODES.MOUSE_WASD:
				//Nothing
			  break;
			case NAVIGATION_MODES.LOOK_AT_ROTATE:
				if(eventObject.entity){

					var mouseUpTime = Date.now();	
					var mousePressedTime = mouseUpTime - mouseDownTime;
	
					if(mousePressedTime < 200){
						zoomStepCenter(eventObject.entity, isLeftMouseDown);
					}				
				}
				break;
			default:					
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
			

			//Switch Modes

			//Left Mouse
			if(isLeftMouseDown){
				switch(controllerConfig.modus) {
					case NAVIGATION_MODES.AXES:
						pan(dx, dy);
					  break;
					case NAVIGATION_MODES.MOUSE_WASD:
						pan(dx, dy);
					  break;
					case NAVIGATION_MODES.LOOK_AT_ROTATE:
						//Nothing
						break;
					default:					
				}
				
			}

			//Right Mouse
			if(isRightMouseDown){

				switch(controllerConfig.modus) {
					case NAVIGATION_MODES.AXES:
						rotateModel(dx, dy);
					  break;
					case NAVIGATION_MODES.MOUSE_WASD:
						rotateCam(dx, dy);
					  break;
					case NAVIGATION_MODES.LOOK_AT_ROTATE:
						rotateModel(dx, dy);
						break;
					default:						
				}
			}

			mousePosX = x;
			mousePosY = y;					

		}	
	}	

	function mousescroll(eventObject, timestamp){

		

		//Switch Modes
		switch(controllerConfig.modus) {
			case NAVIGATION_MODES.AXES:
				var zoomFactor = -2 * eventObject.detail;

				if(controllerConfig.macUser){
					zoomFactor = zoomFactor * -1;
				}

				if(controllerConfig.zoomToMousePosition){
					moveByScroll(eventObject, zoomFactor);
				} else {
					zoom(zoomFactor);	
				}
			  break;
			case NAVIGATION_MODES.MOUSE_WASD:
				var zoomFactor = -2 * eventObject.detail;

				if(controllerConfig.macUser){
					zoomFactor = zoomFactor * -1;
				}
			
				if(controllerConfig.zoomToMousePosition){
					moveByScroll(eventObject, zoomFactor);
				} else {
					zoom(zoomFactor);	
				}
			  break;
			case NAVIGATION_MODES.LOOK_AT_ROTATE:
					var zoomIn = eventObject.detail < 0;

					if(controllerConfig.macUser){
						zoomIn = !zoomIn;
					}

					zoomStepCenter(eventObject.entity, zoomIn);
				break;
			default:	
		}

        
    }



//*********************
//* View Helper
//*********************

	function getViewMatrix(){
		return viewMatrix.copy();
	}

	function getCamMatrix(){
		return camMatrix.copy();
	}

	function setCamMatrix(newCamMatrix){
		camMatrix = newCamMatrix.copy();
		viewMatrix = camMatrix.inverse();

		//Center of Rotation
		if(controllerConfig.showCenterOfRotation){
			var centerOfRotation = viewpoint.getCenterOfRotation();
			centerOfRotationX3DomElement.setAttribute("translation", centerOfRotation.toString());
		}
	}

	function setCenterOfRotation(entity, setFocus){
				
		var centerOfPart = canvasManipulator.getCenterOfEntity(entity);

		viewpoint.setCenterOfRotation(centerOfPart);

		if(setFocus){
			var myCam = getCamMatrix();
			var center = x3dom.fields.SFVec3f.copy(viewpoint.getCenterOfRotation());

			var from = myCam.e3();
			var at = centerOfPart
			var up = myCam.e1();

			var norm = myCam.e0().cross(up).normalize();
			// get distance between look-at point and viewing plane
			var dist = norm.dot(centerOfPart.subtract(from));
			
			from = at.addScaled(norm, -dist);
			myCam = x3dom.fields.SFMatrix4f.lookAt(from, at, up);

			animateTo(myCam.inverse(), getViewMatrix());
			// setCamMatrix(myCam);
			// viewarea.animateTo(mat.inverse(), viewpoint);
		}

		
	}



//*********************
//* Rotation
//*********************

	function rotateModel(dx, dy){

		var alpha = (dy * 2 * Math.PI) / viewarea._height;
		var beta = (dx * 2 * Math.PI) / viewarea._width;

		var myCam = calcOrbit(alpha, beta);
		setCamMatrix(myCam);

	}	

	function rotateCam(dx, dy){

		var alpha = - (dy * 2 * Math.PI) / viewarea._height;
		var beta = (dx * 2 * Math.PI) / viewarea._width;

		var myCam = calcOrbitReverse(alpha, beta);
		setCamMatrix(myCam);

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



//*********************
//* Pan
//*********************

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


//*********************
//* Zoom
//*********************


	function zoom(zoomFactor){

		var myCam = getCamMatrix();

		var d = (viewarea._scene._lastMax.subtract(viewarea._scene._lastMin)).length();
		d = ((d < x3dom.fields.Eps) ? 1 : d) * zoomSpeed;
		
		var zoomAmount = d * zoomFactor / viewarea._height;

		//clamp zoomAmount 
		zoomAmount = Math.min(zoomAmount, 20); //ToDo Config Parameter
		

		var up   	= myCam.e1();
		var from 	= myCam.e3(); 

		// zoom in/out
		var cor = viewpoint.getCenterOfRotation();

		var lastDir  = cor.subtract(from);
		lastDir = lastDir.normalize();
				
		// move along viewing ray, scaled with zoom factor
		var zoomedFrom = from.addScaled(lastDir, zoomAmount);

		// minimum zoom distance
		var zoomedFromDistance = cor.subtract(zoomedFrom);
		zoomedFromDistance = zoomedFromDistance.length();
		
		// events.log.info.publish({ text: "ZoomDistance: " + zoomedFromDistance});
		
		if(zoomedFromDistance < 20) { //ToDo Config Parameter
			
			cor = cor.addScaled(lastDir, zoomAmount);
			viewpoint.setCenterOfRotation(cor);
		}


		// update camera matrix with lookAt() and invert again
		myCam = x3dom.fields.SFMatrix4f.lookAt(zoomedFrom, cor, up);
		setCamMatrix(myCam);
	}


	function moveByScroll(eventObject, zoomFactor){

		var d = (viewarea._scene._lastMax.subtract(viewarea._scene._lastMin)).length();
		d = ((d < x3dom.fields.Eps) ? 1 : d) * zoomSpeed;
		
		var zoomAmount = d * zoomFactor / viewarea._height;

		//clamp zoomAmount 
		zoomAmount = Math.min(zoomAmount, 20); //ToDo Config Parameter

		

		//TODO bei ohne :) entity eigenen Punkt aus XY Position der Maus errechnen

		var newCam;
		if(eventObject.entity){
			newCam = moveToElement(eventObject, zoomAmount);
		} else {
			newCam = moveToMousPosition(eventObject, zoomAmount);
		}

		setCamMatrix(newCam);
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

	function zoomStepCenter(entity, zoomIn){

		var centerOfPart = canvasManipulator.getCenterOfEntity(entity);		
		// var currentCenter = x3dom.fields.SFVec3f.copy(viewpoint.getCenterOfRotation());

		viewpoint.setCenterOfRotation(centerOfPart);

		if(oldCenterElement != null){
			if(!oldCenterElement.selected && !oldCenterElement.marked){ 
				canvasManipulator.resetColorOfEntities([oldCenterElement]);
			}			
		}
		if(!entity.selected && !entity.marked){
			canvasManipulator.changeColorOfEntities([entity], canvasManipulator.colors.orange);
		}
		oldCenterElement = entity;

		// center

		var myCam = getCamMatrix();

		var from = myCam.e3();
		var at = centerOfPart
		var up = myCam.e1();

		var norm = myCam.e0().cross(up).normalize();
		// get distance between look-at point and viewing plane
		var dist = norm.dot(centerOfPart.subtract(from));
		
		from = at.addScaled(norm, -dist);
		myCam = x3dom.fields.SFMatrix4f.lookAt(from, at, up);

		// zoom
		
		from = myCam.e3();
		at 	 = centerOfPart;
		up   = myCam.e1();
        
        var dir = centerOfPart.subtract(from);

		dist = dir.length();

		var newDist = zoomIn ? dist / 3 : dist / -3;
		if(dist < 100 && dist > 0 && zoomIn){
			newDist = 0;
		} else if(dist < 0 && dist > -100 && !zoomIn){
			newDist = 0;
		}
		

        dir = dir.normalize();

        var newFrom = from.addScaled(dir, newDist);

		myCam = x3dom.fields.SFMatrix4f.lookAt(newFrom, at, up);

		animateTo(myCam.inverse(), getViewMatrix(), 0.5);

	}



	



	

//*********************
//* X3DOM Standard Funktionen
//*********************
	
	//Kopierte Funktion aus dem X3DOM Standard
	//Auskommentierte Zeilen daher nicht gelöscht
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

	//Kopierte Funktion aus dem X3DOM Standard
	//Auskommentierte Zeilen daher nicht gelöscht
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
		deactivate: deactivate,
		activate: activate,
		reset: reset
    };    
})();