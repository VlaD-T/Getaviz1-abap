var navigationCamControllerPZR = (function() {
    	

	var panSpeed = 1.000;
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
    
	//original functions from x3dom viewarea
	var original_getViewMatrix;
	var original_animateTo;
	var original_tick;
    
	
	//config parameters	
	var controllerConfig = {		
		setCenterOfRotation : false,
		setCenterOfRotationFocus: false,
		showCenterOfRotation: true,
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
				rotateModel(dx, dy);
				// rotateCam(dx, dy);
			}

			mousePosX = x;
			mousePosY = y;					

		}	
	}	

	function mousescroll(eventObject, timestamp){

		var zoomFactor = -2 * eventObject.scrollDirection;

		if(controllerConfig.macUser){
			zoomFactor = zoomFactor * -1;
		}

		var newCam = zoom(zoomFactor);	
		// var newCam = move(zoomFactor);
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


	function move(zoomFactor){

		var d = (viewarea._scene._lastMax.subtract(viewarea._scene._lastMin)).length();
		d = ((d < x3dom.fields.Eps) ? 1 : d) * zoomSpeed;
		
		var zoomAmount = d * zoomFactor / viewarea._height;

		//clamp zoomAmount 
		zoomAmount = Math.min(zoomAmount, 20); //ToDo Config Parameter




		var myCam = getCamMatrix();
		var centerOfRotation = viewpoint.getCenterOfRotation();


		var from = myCam.e3();
		var at 	 = centerOfRotation;
		var up   = myCam.e1();			
        
        var dir = centerOfRotation.subtract(from);
        dir = dir.normalize();

        var newFrom = from.addScaled(dir, zoomAmount);
		var newat = at.addScaled(dir, zoomAmount);

		viewpoint.setCenterOfRotation(newat);

		myCam = x3dom.fields.SFMatrix4f.lookAt(newFrom, newat, up);
		
		return myCam;

	}


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
		events.log.info.publish({ text: "ZoomDistance: " + zoomedFromDistance});
		if(zoomedFromDistance < 20) { //ToDo Config Parameter
			return;
		}


		// update camera matrix with lookAt() and invert again
		myCam = x3dom.fields.SFMatrix4f.lookAt(zoomedFrom, cor, up);
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




	function fit(min, max, updateCenterOfRotation){
		if (updateCenterOfRotation === undefined) {
			updateCenterOfRotation = true;
		}

		var dia2 = max.subtract(min).multiply(0.5);    // half diameter
		var center = min.add(dia2);                    // center in wc
		var bsr = dia2.length();                       // bounding sphere radius

		var viewpoint = viewarea._scene.getViewpoint();
		var fov = viewpoint.getFieldOfView();

		var viewmat = x3dom.fields.SFMatrix4f.copy(viewarea.getViewMatrix());

		var rightDir = new x3dom.fields.SFVec3f(viewmat._00, viewmat._01, viewmat._02);
		var upDir = new x3dom.fields.SFVec3f(viewmat._10, viewmat._11, viewmat._12);
		var viewDir = new x3dom.fields.SFVec3f(viewmat._20, viewmat._21, viewmat._22);

		var tanfov2 = Math.tan(fov / 2.0);
		var dist = bsr / tanfov2;

		var eyePos = center.add(viewDir.multiply(dist));

		viewmat._03 = -rightDir.dot(eyePos);
		viewmat._13 = -upDir.dot(eyePos);
		viewmat._23 = -viewDir.dot(eyePos);

		if (updateCenterOfRotation) {
			viewpoint.setCenterOfRotation(center);
		}		
		
		viewarea.animateTo(viewmat, viewpoint);		
	};

	
	
		

    return {
        initialize: initialize,
		activate: activate,		
		deactivate: deactivate,
		reset: reset
    };    
})();