var navigationZoomPanController = (function() {
    	
	//***************/
	//Zurückbauen!!!
	//***************/





	//camera position
	var panSpeed = 1.000;
	var zoomSpeed = 5.000;

	var isMouseDown = false; 
	var isLeftMouseDown = false;
	var isRightMouseDown = false;

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
    
	
	//config parameters	
	var controllerConfig = {		
		setCenterOfRotation : true,
		setCenterOfRotationFocus: false
	}
    
	function initialize(setupConfig){	

		application.transferConfigParams(setupConfig, controllerConfig);	
				
	}
	
	function activate(){
		
		//get reference of x3dom objects
		x3domRuntime = document.getElementById('x3dElement').runtime;		
		viewarea = x3domRuntime.canvas.doc._viewarea;	
		viewpoint = viewarea._scene.getViewpoint();

		
		
		//mouse actions
		actionController.actions.mouse.key[1].down.subscribe(leftMouseDown);
		actionController.actions.mouse.key[2].down.subscribe(rightMouseDown);

		actionController.actions.mouse.down.subscribe(mousedown);
		actionController.actions.mouse.up.subscribe(mouseup);

		actionController.actions.mouse.move.subscribe(mousemove);

		actionController.actions.mouse.scroll.subscribe(mousescroll);
		

		setTimeout(zoomScaling, 100); 		
}

	function reset(){
		isMouseDown = false;	
		isLeftMouseDown = false;
		isRightMouseDown = false;
		mousePosX = 0;
		mousePosY = 0;
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


			mousePosX = eventObject.clientX ? eventObject.clientX : -1;		
			mousePosY = eventObject.clientY ? eventObject.clientY : -1;

			//center of rotation
			if(controllerConfig.setCenterOfRotation){
				if(eventObject.entity){
					canvasManipulator.setCenterOfRotation(eventObject.entity, controllerConfig.setCenterOfRotationFocus);
				}
			}

		}
	}
 
	function mouseup(eventObject){		
		isMouseDown = false;	
		isLeftMouseDown = false;
		isRightMouseDown = false;
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
	}	




	//x3dom.Viewarea.prototype.onDrag = function (x, y, buttonState)	
	function pan(dx, dy){

		var d, vec, mat = null;

		d = (viewarea._scene._lastMax.subtract(viewarea._scene._lastMin)).length();
		d = ((d < x3dom.fields.Eps) ? 1 : d) * panSpeed;

		vec = new x3dom.fields.SFVec3f(d*dx/viewarea._width, d*(-dy)/viewarea._height, 0);
		viewarea._movement = viewarea._movement.add(vec);

		mat = viewarea.getViewpointMatrix().mult(viewarea._transMat);
		
		viewarea._transMat = mat.inverse().
							mult(x3dom.fields.SFMatrix4f.translation(viewarea._movement)).
							mult(mat);
	}
	

	//x3dom.Viewarea.prototype.onDrag = function (x, y, buttonState)
	function rotateModel(dx, dy){
		        
		var alpha = (dy * 2 * Math.PI) / viewarea._width;
		var beta = (dx * 2 * Math.PI) / viewarea._height;
		var viewMatrix = viewarea.getViewMatrix();

		var mx = x3dom.fields.SFMatrix4f.rotationX(alpha);
		var my = x3dom.fields.SFMatrix4f.rotationY(beta);

		var center = viewpoint.getCenterOfRotation();
		viewMatrix.setTranslate(new x3dom.fields.SFVec3f(0,0,0));

		viewarea._rotMat = viewarea._rotMat.
						mult(x3dom.fields.SFMatrix4f.translation(center)).
							mult(viewMatrix.inverse()).
								mult(mx).
								mult(my).
							mult(viewMatrix).
						mult(x3dom.fields.SFMatrix4f.translation(center.negate()));

	}


	

	function rotateCam(dx, dy){

		//PROBLEM iterative Rotation um x und y Achse führt zu Rotation in Z-Achse (Matrizen Nachteil)
		//Das Problem löst auch x3dom nicht, der Examine Modus und auch die Kameraumschau von Fly und LookAt drehen die Ansicht in der Z Achse...
		
		//Möglichkeit 1 Komplette Neuberechnung anhand summierter Winkel -> Nachteil sind die anderen Rotationen/Animationen, die nicht die Summen setzen...
		//Möglichkeit 2 Komplette Neuberechnung anhand Rückrechnung X und Y Winkel -> Aufwändig...Eulerwinkel getEulerAngles
		//				Problem, dass die rotMatrix der ViewArea auch einen Translationsteil hat, der führt zu seltsamen Effekten
		//				Eliminierung des Translationsanteils durch Auflösen des Viewpoints
		//				Klappt nicht...


		// // Viewpoint auflösen
		// var viewpoint = viewarea._scene.getViewpoint();
		// var viewPointViewMatrix = viewpoint._viewMatrix;
		
		// if(!viewPointViewMatrix.equals(new x3dom.fields.SFMatrix4f.identity())){

		// 	var viewPointTranslation = viewPointViewMatrix.e3();
		// 	var viewAreaTranslation = viewarea._transMat.e3();
			
		// 	viewarea._transMat.setTranslate(viewAreaTranslation.add(viewPointTranslation));
		// 	viewPointViewMatrix.setTranslate(new x3dom.fields.SFVec3f(0,0,0));

		// }

		
		// Überschreiben der ViewMatrix mit eigener Funktion

		viewarea.getViewMatrix = function() {
			events.log.info.publish({ text: "getViewMatrix"});
			return this.getViewpointMatrix().mult(this._transMat).mult(this._rotMat);
			// return x3dom.fields.SFMatrix4f.identity();
		};

		var viewMatrix = viewarea.getViewMatrix();

		//TODO RotationSpeed PanSpeed unabhängig von der CanvasGröße?
		var alpha = (dy * 2 * Math.PI) / viewarea._width;
		var beta = (dx * 2 * Math.PI) / viewarea._height;

		//var rotateCamSpeed = 1;
		// var alpha = (dy * 2 * Math.PI) / 	(1000 / rotateCamSpeed);
		// var beta = (dx * 2 * Math.PI) / 	(1000 / rotateCamSpeed);
				
		var mx = x3dom.fields.SFMatrix4f.rotationX(alpha);
		var my = x3dom.fields.SFMatrix4f.rotationY(beta);

		// //Mit Z Drehung
		// viewarea._rotMat = viewarea._rotMat.
		// 				mult(viewMatrix.inverse()).
		// 					mult(mx).
		// 					mult(my).
		// 				mult(viewMatrix);



		//Mit Upright der Z Drehung
		viewarea._rotMat = viewarea._rotMat.
						mult(viewMatrix.inverse()).
							mult(mx).
							mult(my).
						mult(viewMatrix);


		// Upright
		var mat = viewarea.getViewMatrix().inverse();

		var from = mat.e3();
		var at = from.subtract(mat.e2());
		var up = new x3dom.fields.SFVec3f(0, 1, 0);

		var s = mat.e2().cross(up).normalize();
		var v = s.cross(up).normalize();
		at = from.add(v);

		mat = x3dom.fields.SFMatrix4f.lookAt(from, at, up);
		mat = mat.inverse();





		// var newRotMatrix = viewarea._rotMat.mult(viewarea._transMat);

		// var eulerAngles = newRotMatrix.getEulerAngles();
		// var rotationTranslation = newRotMatrix.e3();

		// var psi 	= eulerAngles[0] + alpha;
		// var theta 	= eulerAngles[1] + beta;
		// var phi 	= eulerAngles[2];

		// var mpsi 	= x3dom.fields.SFMatrix4f.rotationX(psi);
		// var mtheta 	= x3dom.fields.SFMatrix4f.rotationY(theta);
		// var mphi 	= x3dom.fields.SFMatrix4f.rotationZ(phi);

		// newRotMatrix = mtheta.mult(mpsi);
		// newRotMatrix.setTranslate(rotationTranslation);

		// viewarea._rotMat = newRotMatrix.mult(viewarea._transMat.inverse());


		

		
		

		// //Tilgung Z nach Rotation funktioniert nicht, da Z auch sehr groß werden kann und somit sehr viel Manpipulation an der Drehung entsteht
		// // Das eigentliche Problem ist der Translationsanteil in der Rotationsberechnung

		// var newRotMatrix = viewarea._rotMat.
		// 				mult(viewMatrix.inverse()).
		// 					mult(mx).
		// 					mult(my).
		// 				mult(viewMatrix);

		// var eulerAngles = newRotMatrix.getEulerAngles();
		// var rotationTranslation = newRotMatrix.e3();

		// var psi 	= eulerAngles[0];
		// var theta 	= eulerAngles[1];
		// var phi 	= eulerAngles[2];
		// events.log.info.publish({ text: "PHI-Value: " + phi});

		// var mpsi 	= x3dom.fields.SFMatrix4f.rotationX(psi);
		// var mtheta 	= x3dom.fields.SFMatrix4f.rotationY(theta);
		// var mphi 	= x3dom.fields.SFMatrix4f.rotationZ(phi);


		// //THETA X PSI
		// //Kein PHI, da die Drehung um diese Achse ein unerwünschter Effekt der Matrizenmultiplikation ist
		
		// newRotMatrix = mtheta.mult(mpsi);
		// //newRotMatrix = mphi.mult(mtheta);
		// //newRotMatrix = newRotMatrix.mult(mpsi);

		// newRotMatrix.setTranslate(rotationTranslation);

		// viewarea._rotMat = newRotMatrix;





		// // Testvariante mit Eulerwinkeln
		
		// var myRotMat = viewarea._rotMat.inverse();
		// var eulerAngles = myRotMat.getEulerAngles();
		
		// // return [psi, theta, phi,
        // //         psi, theta, phi];

		// var psi 	= eulerAngles[0];
		// var theta 	= eulerAngles[1];
		// var phi 	= eulerAngles[2];

		// var mpsi 	= x3dom.fields.SFMatrix4f.rotationX(psi);
		// var mtheta 	= x3dom.fields.SFMatrix4f.rotationY(theta);
		// var mphi 	= x3dom.fields.SFMatrix4f.rotationZ(phi);
		
		// //PHI X THETA X PSI
		// var newRotMatrix1 = mphi.mult(mtheta);
		// newRotMatrix1 = newRotMatrix1.mult(mpsi);

		
	}




	//ZOOM
	//****

	var zoomFactor = 0.0;

	function mousescroll(eventObject, timestamp){

		zoomFactor = zoomFactor + ( -2 * eventObject.detail);
		//zoom(-2 * eventObject.detail);		
        
    }

	function zoomScaling(){
		
		setTimeout(zoomScaling, 100); 	

		// events.log.info.publish({ text: "zoomFactor: " + zoomFactor});
			
		if(zoomFactor == 0){
			return;
		}

		zoom(zoomFactor);

		zoomFactor = zoomFactor / 10;
		if(zoomFactor < 1 && zoomFactor > -1){
			zoomFactor = 0;			
		}
	}


	//x3dom.Viewarea.prototype.onDrag = function (x, y, buttonState)
    function zoom(zoomFactor){
		
		
		var dy = zoomFactor;
		var d, vec, mat = null;

		d = (viewarea._scene._lastMax.subtract(viewarea._scene._lastMin)).length();
        d = ((d < x3dom.fields.Eps) ? 1 : d) * zoomSpeed;

        vec = new x3dom.fields.SFVec3f(0, 0, d* dy / viewarea._height);                        

		viewarea._movement = viewarea._movement.add(vec);
		mat = viewarea.getViewpointMatrix().mult(viewarea._transMat);
		//TODO; move real distance along viewing ray
		viewarea._transMat = mat.inverse().
							mult(x3dom.fields.SFMatrix4f.translation(viewarea._movement)).
							mult(mat);

		viewarea._needNavigationMatrixUpdate = true;
		x3domRuntime.canvas.doc.needRender = 1;
		
	}

	



	//TODO doesnt work ^^
	function zoomToMousPosition(){

		/*
			var width = viewarea._width;
			var height = viewarea._height;

			var centerX = width / 2;
			var centerY = height / 2;

			var x = eventObject.layerX;
			var y = eventObject.layerY;

			var dx = (centerX - x) / 3;
			var dy = (centerY - y) / 3;
			
			if(eventObject.detail > 0){
				dx = dx * -1;
				dy = dy * -1;
			}

			pan(dx, dy);
		*/

	
		zoomFactor = zoomFactor + (eventObject.detail / 2);

		var width = viewarea._width;
		var height = viewarea._height;

		var centerX = width / 2;
		var centerY = height / 2;

		var x = eventObject.layerX;
		var y = eventObject.layerY;

		var dx = (x - centerX) * 0.1; 
		var dy = ( centerY - y) * 0.1; 

		
		if(zoomFactor > 0){
			var widthDelta = width * 0.01 * ( 1 + zoomFactor);
			var heightDelta = height * 0.01 * ( 1 + zoomFactor);
		} else {
			var widthDelta = width * 0.01 / ( 1 + (zoomFactor * -1));
			var heightDelta = height * 0.01 / ( 1 + (zoomFactor * -1));
		}


		var min = new x3dom.fields.SFVec3f(-widthDelta + dx,-heightDelta + dy,0);
		var max = new x3dom.fields.SFVec3f( widthDelta + dx, heightDelta + dy, 0);

		fit(min, max);
		

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
		reset: reset
    };    
})();