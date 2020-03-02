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
								"beispielsweise eine Methode, wird dann rot hervorgehoben. Alle in Beziehung stehenden Gebäude werden schwarz hervorgehoben. Sofern sie sich nicht auf dem gleichen Distrikt befinden, " +
                                "werden sie zudem durch eine blaue Linie mit dem roten Gebäude verbunden. Hierbei werden nicht nur die direkten Beziehungen des selektierten ABAP-Objekts angezeigt, sondern auch die " +
                                "indirekten. Ruft beispielsweise Methode \"A\" die Methode \"B\" und Methode \"B\" die Methode \"C\" auf, wird bei Selektion von \"A\" nicht nur die Beziehung zu \"B\" dargestellt, " +
                                "sondern auch die Beziehung von \"B\" zu \"C\".",
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
								"Sind nicht nur die Beziehungen einzelner Methoden relevant, sondern beispielsweise die aller Methoden einer bestimmten Klasse, so kann dies ebenfalls visualisiert werden. Dazu muss das " +
								"entsprechend übergeordnete Objekt, im Beispiel also die Klasse, selektiert werden.",
								"Mittels der Anzeige von Beziehungen lassen sich die Abhängigkeiten der Objekte der Grundmenge zu anderen Paketen untersuchen. Grundsätzlich sollte gelten, dass die Quellcodeobjekte " +
								"vorrangig Beziehungen zu Objekten aus dem eigenen Paket besitzen, da dieses möglichst viele Bestandteile der zu realisierenden Funktionalität kapseln sollte. Weniger Beziehungen sollten zu " +
								"Objekten anderer Pakete der Grundmenge oder zum SAP-Standard bestehen. Des Weiteren sollten die Objekte der Grundmenge möglichst wenig Beziehungen zu den referenzierten, kundeneigenen " +
								"Entwicklungen besitzen, weil dies auf Abhängigkeiten fachlich getrennter Module hinweist.",
								"Betrachten Sie die Klassen von vorhin und schätzen Sie deren Abhängigkeiten ein. Beenden Sie anschließend die Aufgabe wieder über die Schaltfläche."
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

		{ 	name: 	"canvasResetViewController" 
		},
		
		{ 	name: 	"searchController" 
        },

		// {	name: 	"canvasFlyToController",
		// 	parentLevel: 1
		// },
		
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
			
		{ 	name: 	"relationHighlightController" 
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
			zoomFactor: 1.0,

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
					size: "250px",	
					
					controllers: [	
						{ name: "experimentController" },				
						{ name: "canvasResetViewController" },
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
							size: "20%",
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
							size: "80%",
							collapsible: false,
                            name: "canvas",
                            canvas: {},
							controllers: [
								{ name: "defaultLogger" },
								{ name: "canvasHoverController" },
								{ name: "canvasFilterController" },								
								{ name: "canvasSelectController" },
								{ name: "canvasFlyToController" },
								{ name:	"relationConnectorController" },
								//{ name:	"relationHighlightController" },
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