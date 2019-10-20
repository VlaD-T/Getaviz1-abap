var setup = {
		
	controllers: [	

		{ 	name: 	"defaultLogger",

			logActionConsole	: false,
			logEventConsole		: false
		},		

		
		{	name: 	"canvasHoverController",
		},

		{	name: 	"canvasSelectController" 
		},	

		{ 	name: 	"canvasResetViewController" 
		},

		{	name: 	"navigationCamControllerAxes",
			active:	false
		},

		{	name: 	"navigationCamControllerLAR",
			active:	false
		},

		{	name: 	"navigationCamControllerMWASD",
			active:	false
		},

		{	name: 	"navigationCamControllerPZR",
			setCenterOfRotation : false,
			setCenterOfRotationFocus: false,
			showCenterOfRotation: false,
			macUser: false,
			active:	false
		},

		{	name: 	"navigationWASDController",
			active:	true
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
					size: "10%",	
					
					controllers: [					
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
						
						{ name: "navigationCamControllerAxes" },
						{ name: "navigationCamControllerLAR" },
						{ name: "navigationCamControllerMWASD" },
						{ name:	"navigationCamControllerPZR" },
						{ name: "navigationWASDController" },

						
					],						
				}
			}
			
		}
	
	]
};