var setup = {
	
	controllers: [
		
		{	name: 	"experimentController",
		
			taskTextButtonTime: 10,
			taskTime: 3,
		
			stepOrder:	[ 10, 11, 12, 13, 14, 15 ],
						
            steps:	[				
						{ 	number:	10, // Klassen
                            
                            text: 	[
								"<b>Umfang von Klassenbestandteilen</b><br/><br/>",
								"Methoden:&emsp;&emsp;&emsp;mindestens <b>3</b>, optimal <b>10</b>, maximal <b>15</b><br/>",
								"lokale Klassen:&emsp;maximal <b>1</b>",
                            ],		

                            ui: 	"UI0",

							viewpoint : { 										// Überblick
								position: "-10612.86652 13430.80462 4497.83854",
								orientation: "-0.35719 -0.863 -0.35727 1.71781",
							},

                            entities:   [
                                "ID_e971f662a36dd7189595b1541ff549eb18d373f7"	// entspricht ZCL_GM_SERVICE_DELIVERY
                            ]
                        },

                        { 	number:	11, // Klassen-Layout
                            
                            text: 	[
								"<b>Verteilung von Klassenbestandteilen</b><br/><br/>",
								"öffentliche Member:&emsp;Positionierung <b>am Rand</b> des Distrikts",
								"private Member:&emsp;&emsp;&ensp;Positionierung <b>im Zentrum</b> des Distrikts<br/>",
								"Methoden:&emsp;&emsp;&emsp;&emsp;&emsp;NOS <b>privater</b> Methoden <b>></b> NOS <b>öffentlicher</b> Methoden",
								"Attribute:&emsp;&emsp;&emsp;&emsp;&emsp;&ensp;&nbsp;<b>10 skalare</b> Attribute ==> <b>1 strukturiertes</b> Attribut, <b>10 strukturierte</b> Attribute ==> <b>1 referenzielles</b> Attribut",
                            ],		

                            ui: 	"UI0",

							viewpoint : { 										// Überblick
								position: "-10612.86652 13430.80462 4497.83854",
								orientation: "-0.35719 -0.863 -0.35727 1.71781",
							},

                            entities:   [
                                "ID_e971f662a36dd7189595b1541ff549eb18d373f7" 	// entspricht ZCL_GM_SERVICE_DELIVERY
                            ]
                        },

                        { 	number:	12, // Reports
                            
                            text: 	[
								"<b>Umfang von Reportbestandteilen</b><br/><br/>",
								"Formroutinen:&emsp;&emsp;&nbsp;optimal <b>keine</b><br/>",
								"globale Attribute:&emsp;optimal <b>keine</b><br/>",
								"lokale Klassen:&emsp;&ensp;&nbsp;maximal <b>1</b>"
                            ],		

							ui: 	"UI0",
							
							viewpoint : { 										// Überblick
								position: "-10612.86652 13430.80462 4497.83854",
								orientation: "-0.35719 -0.863 -0.35727 1.71781",
							},

                            entities:   [
                                "ID_0d3fa981f2e576a7ef02e0fce64799d965807ef0" 	// entspricht ZSD_SAM_KUEND_KONTROLLE_II
                            ]
                        },

                        { 	number:	13, // Funktionsgruppen
                            
                            text: 	[
								"<b>Umfang von Funktionsgruppenbestandteilen</b><br/><br/>",								
								"Funktionsbausteine:&emsp;maximal <b>2</b>",
								"Formroutinen:&emsp;&emsp;&emsp;&ensp;&nbsp;optimal <b>keine</b>",
								"globale Attribute:&emsp;&emsp;&ensp;optimal <b>keine</b>",
								"lokale Klassen:&emsp;&emsp;&emsp;&nbsp;maximal <b>1</b>"
                            ],		

							ui: 	"UI0",
							
							viewpoint : { 										// Überblick
								position: "-10612.86652 13430.80462 4497.83854",
								orientation: "-0.35719 -0.863 -0.35727 1.71781",
							},

                            entities : [
                                "ID_1e627bbdcff730a946cb466b40db63af3a48e41a"	// entspricht /RZ1/SAM_SD018_CHANGE_INET
                            ]
						},
						
						{ 	number:	14, // number of statements
                            
                            text: 	[
								"<b>Umfang von Quellcode-Objekten</b><br/><br/>",								
								"Quellcode-Objekte:&emsp;Methoden, Reports, Formroutinen, Funktionsbausteine<br/>",
								"Höhe:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;optimal <b>30</b>, maximal <b>50</b>"
                            ],		

                            ui: 	"UI0",

                            viewpoint : { 										// Überblick
								position: "-10612.86652 13430.80462 4497.83854",
								orientation: "-0.35719 -0.863 -0.35727 1.71781",
							},

							entities : [
								"ID_4a1fcd61ea91761f22632560b0f27d84e18318fa" 	// entspricht ZI01
							]
						},
						
						{ 	number:	15, // Paketumfang
                            
                            text: 	[
								"<b>Umfang von Paketbestandteilen</b><br/><br/>",								
								"Quellcode-Objekte:&emsp;Methoden, Reports, Formroutinen, Funktionsbausteine<br/>",
								"Anzahl:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;mindestens <b>5</b>, optimal <b>10</b>, maximal <b>20</b><br/>",
                            ],		

                            ui: 	"UI0",

                            viewpoint : { 										// Überblick
								position: "-10612.86652 13430.80462 4497.83854",
								orientation: "-0.35719 -0.863 -0.35727 1.71781",
							},

							entities : [
								"ID_4a1fcd61ea91761f22632560b0f27d84e18318fa" 	// entspricht ZI01
							]
                        },
			]
			
		},

		{ 	name: 	"defaultLogger",
			logActionConsole	: false,
			logEventConsole		: false
		},
		
		{	name: 	"canvasHoverController",
		},

		{	name: 	"canvasSelectController" 
		},

        {	name: 	"canvasFlyToController",
			parentLevel: 1
		},
		
		{	name: 	"canvasFilterController" 
		},

		{   name: 	"legendController",
            entries: [{
                name: "Package",
                icon: "scripts/Legend/tutorial/package_district.png"
            }, {
                name: "Class",
                icon: "scripts/Legend/tutorial/class_district.png",
            },{
                name: "Report",
                icon: "scripts/Legend/tutorial/report_district.png",
            },{
                name: "Function Group",
                icon: "scripts/Legend/tutorial/functionGroup_district.png",
            }],
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
			zoomFactor: 0.7,

			macUser: false,
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
					size: "175px",	
					
					controllers: [	
						{ name: "experimentController" },
					],							
				},
				second: {
                    size: "80%",
                    collapsible: false,
                    area: {
                        orientation: "vertical",
                        name: "leftPanel",
                        first: {                            
							size: "10%",
							expanders: [
								{
									name: "legend",
									title: "Legend",
									controllers: [
										{ name: "legendController" }
									],
								},
							]
						},
                        second: {
							size: "90%",
							collapsible: false,
                            name: "canvas",
                            canvas: {},
							controllers: [
								{ name: "defaultLogger" },
								{ name: "canvasHoverController" },
								{ name: "canvasFlyToController" },
								{ name: "canvasSelectController" },
								{ name: "navigationCamController"},
							],
                        }
                    }
				}
			}
		},
	]
};