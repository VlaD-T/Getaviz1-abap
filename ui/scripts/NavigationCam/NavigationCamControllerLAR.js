var navigationCamControllerLAR = (function() {
    	
	//LookAtRotate Modus

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
		setCenterOfRotation : true,
		setCenterOfRotationFocus: true,
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
			material.setAttribute("diffuseColor", "0 0 0");
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


	}

	function reset(){
		isMouseDown = false;	
		isLeftMouseDown = false;
		isRightMouseDown = false;
		mouseMoved = false;
		mousePosX = 0;
		mousePosY = 0;

		if(oldCenterElement != null){
			canvasManipulator.resetColorOfEntities([oldCenterElement]);						
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
		if(controllerConfig.setCenterOfRotation && controllerConfig.setCenterOfRotationFocus){
								
			if(eventObject.entity){

				var mouseUpTime = Date.now();	
				var mousePressedTime = mouseUpTime - mouseDownTime;

				if(mousePressedTime < 200){
					zoomStepCenter(eventObject.entity, isLeftMouseDown);
					// zoomSteps(eventObject.entity, isLeftMouseDown);
					// setCenterOfRotation(eventObject.entity, true);
				}				
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
				//pan(dx, dy);
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

		if(!eventObject.entity) {
			return;
		}

		var zoomIn = eventObject.detail < 0;

		if(controllerConfig.macUser){
			zoomIn = !zoomIn;
		}
		
		zoomStepCenter(eventObject.entity, zoomIn );
        
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





	var oldCenterElement = null;


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





	function rotateModel(dx, dy){

		var alpha = (dy * 2 * Math.PI) / viewarea._height;
		var beta = (dx * 2 * Math.PI) / viewarea._width;

		var myCam = calcOrbit(alpha, beta);
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

		var endTimteDuration = dur ? dur : navi._vf.transitionTime;

		viewarea._mixer._endTime = viewarea._lastTS + endTimteDuration;
		
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