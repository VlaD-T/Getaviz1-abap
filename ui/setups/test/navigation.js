var setup = {

	
		
	controllers: [	

		{ 	name: 	"defaultLogger",

			logActionConsole	: false,
			logEventConsole		: false
		},		


		{	name: 	"navigationCamController",
			
			//NAVIGATION_MODES - AXES, MOUSE_WASD, LOOK_AT_ROTATE, PAN_ZOOM_ROTATE, GAME_WASD			
			modus: "PAN_ZOOM_ROTATE",

			zoomToMousePosition: true,
			
			//CENTER_OF_ROTATION_ELEMENT - NONE, AXES, SPHERE
			showCenterOfRotation: false,
			centerOfRotationElement: "SPHERE",

			setCenterOfRotation: true,
			setCenterOfRotationFocus: true,
			

			macUser: false,
		},


		{	name: 	"experimentController",
		
			taskTextButtonTime: 10,
			taskTime: 5,
		
			stepOrder:	[ 10, 12, 11 ],
			
						
            steps:	[				
						{ 	number:	10, // Domänen und Datenelemente
									
							text: 	[
								"Test123"
							],		

							ui: 	"UI0",

							
						},

						{ 	number:	11, // Strukturen
							
							text: 	[
								"Test456"
							],		

							ui: 	"UI0",

							
							entities : [
                                "ID_9145e2b8ba073950601eee769bf49cee133d99f1"	
                            ]
						},

						{ 	number:	12, // Strukturen
							
							text: 	[
								"Test789"
							],		

							ui: 	"UI0",

							viewpoint: "800 280 20"		
						},
			]
		},

		
		{	name: 	"canvasHoverController",
		},

		{	name: 	"canvasSelectController" 
		},	

		{ 	name: 	"canvasResetViewController" 
		},



		
		
	],
		

	uis: [
		
		
		{	name: "UI0",
		
			navigation: {
				//examine, walk, fly, helicopter, lookAt, turntable, game
				type:	"none",
				//speed: 10
			},	
					
		
							
			area: {
				name: "top",
				orientation: "horizontal",
				
				first: {			
					size: "200px",	
					
					controllers: [	
						{ name: "experimentController" },				
						{ name: "canvasResetViewController" },
					],							
				},
				second: {
					size: "90%",	
					collapsible: false,
					
					
							
					canvas: { },
					
					controllers: [
						{ name: "defaultLogger" },												

						{ name: "canvasHoverController" },
						{ name: "canvasSelectController" },
						
						{ name: "navigationCamController"},
						
					],						
				}
			}
			
		}
	
	]
};