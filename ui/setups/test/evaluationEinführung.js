var setup = {
	
	controllers: [
		
		{	name: 	"experimentController",
		
			taskTextButtonTime: 10,
			taskTime: 3,
		
			stepOrder:	[ 10, 11, 12 ],
						
			steps:	[				
						{ 	number:	10, // Einführung Tooltip
							
							text: 	[
								"Herzlich Willkommen zur Evaluation des aktuellen Stands des Projekts \"VISAP\".",
								"Für die Visualisierung von ABAP-Quellcode wird die Stadtmetapher verwendet, bei der die verschiedenen Bestandteile von ABAP als Distrikte (Stadtteile) oder Gebäude dargestellt werden. " +
								"Alle Gebäude der dargestellten ABAP-Objekte sind auf einem Distrikt positioniert, der das Oberobjekt beziehungsweise das zugehörige Paket repräsentiert. Wenn Sie die Maus über die " + 
								"Bestandteile der Visualisierung bewegen, erscheint ein Tooltip mit zusätzlichen Informationen zum ABAP-Objekt, wie der Name des zugehörigen Pakets, der Objekttyp und der Bezeichner.",
								"Betrachten Sie die Visualisierung und finden Sie heraus, welches ABAP-Objekt durch den großen, violetten Distrikt repräsentiert wird und zu welchem Paket es gehört. Betätigen Sie " +
								"anschließend die \"Aufgabe abgeschlossen!\"-Schaltfläche oben rechts zwei mal."
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

						{ 	number:	11, // Paket-Layout
							
							text: 	[
								"Die zentralen Distrikte der Visualisierung stellen die Pakete der Grundmenge dar, die analysiert werden sollen. Für die Evaluation sind dies mehrere Z-Pakete aus dem GT3-System. " +
								"Ringförmig um die Grundmenge befinden sich die grauen Paket-Distrikte der kundeneigenen Entwicklungen, die von den Objekten der Grundmenge referenziert werden.",
								"Wiederum ringförmig um diese referenzierten, kundeneigenen Entwicklungen sind die von der Grundmenge verwendeten, grauen Paket-Distrikte des SAP-Standards dargestellt",
								"Fahren Sie mit der Maus über einige Paket-Distrikte und bestimmen Sie den Namen des größten Pakets, welches zu den kundeneigenen Entwicklungen aber nicht zur Grundmenge gehört. "+
								"Beenden Sie die Aufgabe wieder über die Schaltfläche rechts oben."
							],		

							ui: 	"UI0",

							viewpoint : { 										// Überblick
								position: "-10612.86652 13430.80462 4497.83854",
								orientation: "-0.35719 -0.863 -0.35727 1.71781",
							},

						},

						{ 	number:	12, // Navigationsmodi
							
							text: 	[							
								"Durch Drücken der linken Maustaste und gleichzeitigem Bewegen der Maus kann das Modell verschoben werden.",
								"Außerdem können Sie die Kamera schwenken, indem Sie die rechte Maustaste gedrückt halten und die Maus bewegen.",
								"Das Hinein- beziehungsweise Herauszoomen aus dem Modell erfolgt über die Drehung des Mausrads nach vorn beziehungsweise nach hinten.",								
								"Probieren Sie die einzelnen Steuerungsvarianten aus und navigieren Sie zum größten Distrikt des SAP-Standards. Beenden Sie anschließend die Aufgabe über die Schaltfläche."
							],		

							ui: 	"UI1",

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

		{	name: "UI0", // hover
		
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
							],
                        }
                    }
				}
			}
		},

		{	name: "UI1", // hover + navigation
		
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
								{ name: "navigationCamController"},
							],
                        }
                    }
				}
			}
		},
	]
};