var navigationWASDController = (function() {
    	
	//ToDo enterFrame in CanvasController auslagern

	//movement	
	var globalMoveSpeed = 0.1;
	
	var movement = new Array();
	movement["left"] = {
		startTime 	: 0,
		endTime 	: 0
	};
	movement["right"] = {
		startTime 	: 0,
		endTime 	: 0
	};
	movement["forward"] = {
		startTime 	: 0,
		endTime 	: 0
	};
	movement["backward"] = {
		startTime 	: 0,
		endTime 	: 0
	};
	movement["up"] = {
		startTime 	: 0,
		endTime 	: 0
	};
	movement["down"] = {
		startTime 	: 0,
		endTime 	: 0
	};


	var keyCounter = 0;
	var isKeyDown = false;

	var moveLastZ = 0.0;
	var moveLastX = 0.0;
	var moveLastY = 0.0;

	var moveDeltaZ = 0.0;
	var moveDeltaX = 0.0;
	var moveDeltaY = 0.0;
	

	//camera position
	var lookSpeed = 0.003;

	var isMouseDown = false; 

	var mousePosX;
	var mousePosY;

	var angleX = 0.0;
	var angleY = 0.0;

	//camera
	var camMatrix;
	var doUpdateCamera = false;
	

	//x3dom objects
	var x3domRuntime;
	var viewarea;
	var viewPoint;

	//movment functions
	var movementFunctions = {
		forwardOn 		: 	function(){keyDown(movement["forward"])},
		backwardOn 		:	function(){keyDown(movement["backward"])},
		leftOn			:	function(){keyDown(movement["left"])},
		rightOn			: 	function(){keyDown(movement["right"])},

		forwardOff 		: 	function(){keyUp(movement["forward"])},
		backwardOff 	:	function(){keyUp(movement["backward"])},
		leftOff			:	function(){keyUp(movement["left"])},
		rightOff		: 	function(){keyUp(movement["right"])},
	}
	
	//config parameters	
	var controllerConfig = {	
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

		//set enterFrame function 
		x3domRuntime.enterFrame = updateCamera;
		
		//mouse actions
		actionController.actions.mouse.key[1].down.subscribe(mousedown);
		actionController.actions.mouse.key[1].up.subscribe(mouseup);
		actionController.actions.mouse.move.subscribe(mousemove);

		//leaving canvas while mouse down
		actionController.actions.mouse.up.subscribe(mouseup);

		//key actions
		actionController.actions.keyboard.key[87].down.subscribe(movementFunctions.forwardOn);
		actionController.actions.keyboard.key[83].down.subscribe(movementFunctions.backwardOn);
		actionController.actions.keyboard.key[65].down.subscribe(movementFunctions.leftOn);
		actionController.actions.keyboard.key[68].down.subscribe(movementFunctions.rightOn);

		actionController.actions.keyboard.key[87].up.subscribe(movementFunctions.forwardOff);
		actionController.actions.keyboard.key[83].up.subscribe(movementFunctions.backwardOff);
		actionController.actions.keyboard.key[65].up.subscribe(movementFunctions.leftOff);
		actionController.actions.keyboard.key[68].up.subscribe(movementFunctions.rightOff);

		actionController.actions.keyboard.key[107].down.subscribe(increaseMoveSpeed);
		actionController.actions.keyboard.key[109].down.subscribe(decreaseMoveSpeed);

		//force frame update while key is pressed 
		actionController.actions.keyboard.key[87].during.subscribe(setUpdateCamera);
		actionController.actions.keyboard.key[83].during.subscribe(setUpdateCamera);		
		actionController.actions.keyboard.key[65].during.subscribe(setUpdateCamera);
		actionController.actions.keyboard.key[68].during.subscribe(setUpdateCamera);		

		//mouseScroll
		actionController.actions.mouse.scroll.subscribe(mousescroll);

	}

	function deactivate(){
		
		actionController.actions.mouse.key[1].down.unsubscribe(mousedown);
		actionController.actions.mouse.key[1].up.unsubscribe(mouseup);
		actionController.actions.mouse.move.unsubscribe(mousemove);

		//leaving canvas while mouse down
		actionController.actions.mouse.up.unsubscribe(mouseup);

		//key actions
		actionController.actions.keyboard.key[87].down.unsubscribe(movementFunctions.forwardOn);
		actionController.actions.keyboard.key[83].down.unsubscribe(movementFunctions.backwardOn);
		actionController.actions.keyboard.key[65].down.unsubscribe(movementFunctions.leftOn);
		actionController.actions.keyboard.key[68].down.unsubscribe(movementFunctions.rightOn);

		actionController.actions.keyboard.key[87].up.unsubscribe(movementFunctions.forwardOff);
		actionController.actions.keyboard.key[83].up.unsubscribe(movementFunctions.backwardOff);
		actionController.actions.keyboard.key[65].up.unsubscribe(movementFunctions.leftOff);
		actionController.actions.keyboard.key[68].up.unsubscribe(movementFunctions.rightOff);

		actionController.actions.keyboard.key[107].down.unsubscribe(increaseMoveSpeed);
		actionController.actions.keyboard.key[109].down.unsubscribe(decreaseMoveSpeed);

		//force frame update while key is pressed 
		actionController.actions.keyboard.key[87].during.unsubscribe(setUpdateCamera);
		actionController.actions.keyboard.key[83].during.unsubscribe(setUpdateCamera);		
		actionController.actions.keyboard.key[65].during.unsubscribe(setUpdateCamera);
		actionController.actions.keyboard.key[68].during.unsubscribe(setUpdateCamera);		

		//mouseScroll
		actionController.actions.mouse.scroll.unsubscribe(mousescroll);

	}


	function reset(){
		angleX = 0.0;
		angleY = 0.0;		
		isKeyDown = false;
		isMouseDown = false;

		movement.forEach(function(movementObject){
			movementObject.startTime = 0;
			movementObject.endTime = 0;
		});
	}

	
		
	

	function updateCamera(){	
		//DEBUG
		//logFps();			

		if(!doUpdateCamera && !isKeyDown && !isMouseDown){			
			//TODO verhindern, dass hier ständig die Inverse Cam Matrix berechnet wird
			//updateCamMatrix();
		} else {
			updateCamMatrix();

			computeNewCamMatrix();
			
			viewpoint.setView(camMatrix.inverse());
			
			viewarea._needNavigationMatrixUpdate = true;
			doUpdateCamera = false;
		}
	}


	function updateCamMatrix(){		
		var newCamMatrix = x3domRuntime.viewMatrix().inverse();
		//var newCamMatrix = viewarea.getViewMatrix();
		
		//TODO winkel neu berechnen -> auch kein reset mehr nötig
		camMatrix = newCamMatrix;
	}


	function computeNewCamMatrix(){

		//rotation
		//********

		//axes opposite of mouse direction
		var rotYMatrix = x3dom.fields.SFMatrix4f.rotationY(angleX);
		var rotXMatrix = x3dom.fields.SFMatrix4f.rotationX(angleY);

		//compute new rotation matrix 
		var rotMatrix = rotYMatrix.mult(rotXMatrix);
		
		
		//movement
		//********

		var addTranslation = new x3dom.fields.SFVec3f(0, 0, 0);

		//moveY		
		var moveY = calculateMovement("up", "down");		
		if(moveY != 0){
			//add old move delta
			var moveFullY = moveY + moveDeltaY;
			
			//compute new move delta
			moveDeltaY = moveFullY / 2;

			var moveVector = new x3dom.fields.SFVec3f(0, moveDeltaY, 0);			
			addTranslation = addTranslation.add(moveVector);
		}

		//moveZ		
		var moveZ = calculateMovement("forward", "backward");		
		if(moveZ != 0){
			//add old move delta
			var moveFullZ = moveZ + moveDeltaZ;
			
			//compute new move delta
			moveDeltaZ = moveFullZ / 2;

			var moveVector = new x3dom.fields.SFVec3f(0, 0, moveDeltaZ);			
			addTranslation = addTranslation.add(moveVector);
		}

		//moveX
		var moveX = calculateMovement("left", "right");		
		if(moveX != 0){
			
			//add old move delta
			var moveFullX = moveX + moveDeltaX;
			
			//compute new move delta
			moveDeltaX = moveFullX / 2;
			
			//DEBUG
			//console.log("moveXVector: " + moveX + " - " + moveFullX + " - " + moveDeltaX);			

			var moveXVector = new x3dom.fields.SFVec3f(moveDeltaX, 0, 0);			
			addTranslation = addTranslation.add(moveXVector);
		}

		//rotate movement		
		addTranslation = rotMatrix.multMatrixVec(addTranslation);

		//add movement
		rotMatrix.setTranslate(camMatrix.e3().add(addTranslation));

		//set new camMatrix
		camMatrix = rotMatrix;		
	}

	//computes the movement on one axes by using the time a key is pressed
	function calculateMovement(first, second){

		var frameTime = Date.now();
		var move = 0;
		var duration = 0;
		if(movement[first].startTime != 0){						
			if(movement[first].endTime != 0){
				duration = movement[first].endTime - movement[first].startTime;
				movement[first].startTime = 0;
				movement[first].endTime = 0;
			} else {
				duration = frameTime - movement[first].startTime;
				movement[first].startTime = frameTime;
			}

			move = move - (globalMoveSpeed * duration);
		}

		if(movement[second].startTime != 0){			
			if(movement[second].endTime != 0){
				duration = movement[second].endTime - movement[second].startTime;
				movement[second].startTime = 0;
				movement[second].endTime = 0;
			} else {
				duration = frameTime - movement[second].startTime;
				movement[second].startTime = frameTime;
			}

			move = move + (globalMoveSpeed * duration);
		}
	

		return move;
	}



	
	//keys
	//****

	function keyDown(movementObject){	
		if(movementObject.startTime == 0){
			keyCounter = keyCounter + 1;
			isKeyDown = true;

			movementObject.startTime = Date.now();
		}
	}

	function keyUp(movementObject){		
		keyCounter =  keyCounter - 1;
		if(keyCounter < 1){
			isKeyDown = false;
		}
		if(keyCounter < 0){
			keyCounter = 0;
		}

		if(movementObject.startTime != 0){
			movementObject.endTime = Date.now();
		}
	}



	function mousescroll(eventObject, timestamp){

		if(eventObject.detail > 0){
			var movementObject = movement["up"];
			movementObject.startTime = Date.now();
			movementObject.endTime = movementObject.startTime + ( eventObject.detail * 50 );		//TODO Parameter
		} else {
			var movementObject = movement["down"];
			movementObject.startTime = Date.now();
			movementObject.endTime = movementObject.startTime + ( eventObject.detail * -50);		//TODO Parameter
		}   

		setUpdateCamera();     
    }

	
	function increaseMoveSpeed(){
		globalMoveSpeed = globalMoveSpeed * 2;
	}

	function decreaseMoveSpeed(){
		globalMoveSpeed = globalMoveSpeed / 2;
	}
	

	
	//mouse
	//*****

	function mousedown(event){		
		isMouseDown = true;

		mousePosX = event.clientX ? event.clientX : -1;		
		mousePosY = event.clientY ? event.clientY : -1;	
	}
 
	function mouseup(event){		
		isMouseDown = false;	
	}
	
	function mousemove(mouseMovedEvent, timestamp){							
		if(isMouseDown){					
			
			var x = mouseMovedEvent.clientX;
			var y = mouseMovedEvent.clientY;

			//TODO Bessere Multipartabstraktion finden
			//Hover multipart destroys x,y position
			if(mousePosX == -1 || mousePosY == -1){
				mousePosX = x;
				mousePosY = y;
				return;
			}		
			
			
			var lengthY = mousePosY - y;
			var lengthX = mousePosX - x;
			
			changeCameraAngles(lengthX, lengthY);
					
			mousePosX = mouseMovedEvent.clientX;
			mousePosY = mouseMovedEvent.clientY;
			
			mouseTickCounter = 0;
		}	
	}	
	
	function changeCameraAngles(lengthX, lengthY){
		
		angleX = angleX + (lengthX * lookSpeed);
		angleY = angleY + (lengthY * lookSpeed);
		
		setUpdateCamera();
	}



		


	//helper
	//******
	
	function setUpdateCamera(){
		doUpdateCamera = true;		
		x3domRuntime.canvas.doc.needRender = 1;
	}
	
	

	var fpsStartTime;
	var fps;
	var nextSecond = 1;

	function logFps(){
		if(!fpsStartTime){
			fpsStartTime = Date.now();
		} else {
			var frameTime = Date.now();

			var seconds = (frameTime - fpsStartTime) / 1000;
			console.log("Frame: " + seconds);
			
			if(seconds >= nextSecond){
				nextSecond = nextSecond + 1;

				console.log("FPS: " + fps);
				fps = 0;
			} else {
				fps = fps + 1;				
			}
		}
	}
	
	
		

    return {
        initialize: initialize,
		activate: activate,
		deactivate: deactivate,
		reset: reset
    };    
})();