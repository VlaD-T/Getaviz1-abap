var setup = {
	
	controllers: [
		
		{	name: 	"experimentController",
		
			taskTextButtonTime: 10,
			taskTime: 3,
		
			stepOrder:	[ 10, 11 ],
						
            steps:	[				
                        { 	number:	10, // Anzeigen von Aufrufbeziehungen
                            
                            text: 	[
								"Um sich die Aufrufbeziehungen eines ABAP-Objekts anzeigen zu lassen, müssen Sie das entsprechende Gebäude in der Visualisierung mit Linksklick selektieren. Das selektierte Gebäude, " +
								"beispielsweise eine Methode, wird dann rot hervorgehoben. Alle Gebäude, die nicht mit dem selektierten Gebäude in Beziehung stehen, werden transparent dargestellt. Sofern sie sich nicht " +
                                " auf dem gleichen Distrikt befinden, werden sie zudem durch eine blaue Linie mit dem roten Gebäude verbunden. Hierbei werden nicht nur die direkten Beziehungen des selektierten ABAP-Objekts " +
                                "angezeigt, sondern auch die indirekten. Ruft beispielsweise Methode \"A\" die Methode \"B\" und Methode \"B\" die Methode \"C\" auf, wird bei Selektion von \"A\" nicht nur die Beziehung zu " +
                                "\"B\" dargestellt, sondern auch die Beziehung von \"B\" zu \"C\".",
                                "Wählen Sie die Methode \"GET_FACTSHEETS_FOR_POS()\" und lassen Sie sich deren Aufrufbeziehungen anzeigen. Verfolgen Sie, welche anderen Quellcodeobjekte die selektierte Methode aufruft. " +
                                "Beenden Sie die Aufgabe anschließend über die Schaltfläche."
                            ],		

                            ui: 	"UI0",

                            viewpoint : { 										// Überblick
								position: "-10612.86652 13430.80462 4497.83854",
								orientation: "-0.35719 -0.863 -0.35727 1.71781",
							},

                            entities:   [
                                "ID_c109a87493f1d48b8489f0d6fe0b4ecfff56a2f6" 	// entspricht ZCL_GM_FACTSHEET_CALCULATOR - GET_FACTSHEETS_FOR_POS()
                            ]
                        },

                        { 	number:	11, // kaskadierende Abbildung
                            
                            text: 	[
								"<b>Abhängigkeiten</b><br/>",
								"... zum eigenen Paket:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<b>viele</b><br/>",
								"... zur Grundmenge:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<b>wenige</b><br/>",
								"... zum referenzierten, kundeneigenen Entwicklungen:&emsp;<b>keine</b><br/>",
								"... zum SAP-Standard:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<b>wenige</b>",
                            ],		

                            ui: 	"UI0",

                            viewpoint : { 										// Überblick
								position: "-10612.86652 13430.80462 4497.83854",
								orientation: "-0.35719 -0.863 -0.35727 1.71781",
							},

                            entities:   [
                                "ID_0ea84be9f8e11d2684eccf7239bce2cacfb6ac79" 	// entspricht ZGM_SERVICE_DELIVERY (erstmal nur ein Paket, da die Klassen aus evaluationUmfang betrachtet werden sollen)
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
		
		{ 	name: 	"searchController" 
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

        { 	name: 	"relationConnectorController",
            showInnerRelations: false,
            sourceStartAtBorder: false,
            targetEndAtBorder: false,
			showDependanceToStandard : true,
			showChildrenOfMajorElements : true,
		},
		
		{ 	name: 	"relationTransparencyController",
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
					size: "225px",	
					
					controllers: [	
						{ name: "experimentController" },
						{ name: "searchController" },
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
								{ name: "canvasFilterController" },								
								{ name: "canvasSelectController" },
								{ name:	"relationConnectorController" },
								{ name:	"relationTransparencyController" },
								{ name: "navigationCamController"},
							],
                        }
                    }
				}
			}
		},

	]
};