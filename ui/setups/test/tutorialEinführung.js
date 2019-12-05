var setup = {
	
	controllers: [
		
		//experimentController
		{	name: 	"experimentController",
		
			taskTextButtonTime: 10,
			taskTime: 5,
		
			//stepOrder:	[ 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 ],
			stepOrder:	[ 10, 22 ],
						
			steps:		[				
							{ 	number:	10, // allgemeine Einführung
								
								text: 	[
									"Herzlich Willkommen zum Tutorial für die Evaluation von VISAP.",
									"Dieses Tutorial gibt Ihnen einen Einblick in den bisherigen Stand der Softwarevisualisierung von ABAP.",
									"Die Visualisierung von ABAP-Quellcode soll dazu dienen, die kundeneigenen Entwicklungen in einem SAP-System unter einem strukturellen Aspekt zu untersuchen.",
									"Dafür wird die sogenannte Stadtmetapher verwendet, bei der die verschiedenen Bestandteile von ABAP als Distrikte (Stadtteile) oder Gebäude dargestellt werden.",
									"Betrachten Sie die Visualisierung kurz im Überblick und betätigen Sie anschließend die \"Aufgabe abgeschlossen!\"-Schaltfläche oben rechts zwei mal."
								],		

								ui: 	"UI0"
							},
							
							{ 	number:	11, // Einführung Tooltip
								
								text: 	[
									"Im Folgenden lernen Sie die einzelnen Bestandteile der Visualisierung kennen.",
									"Die grauen Distrikte repräsentieren die Pakete. Wenn Sie die Maus über einen grauen Distrikt bewegen, erscheint im Tooltip der Name des Pakets.",
									"Auf dem Distrikt befinden sich die Visualisierungen der ABAP-Objekte, die dem entsprechenden Paket zugeordnet sind.",
									"Dies können Klassen, Datenelemente oder auch die Unterpakete des betrachteten Pakets sein.",
									"Fahren Sie mit der Maus über einige Bestandteile des Pakets und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI1",
								
								entities : [
                                    "ID_919b44a73b780a53b5aaf69ae6a50250facf245c" 	// entspricht /GSA/VISAP_T_TEST
								]
							},

							{ 	number:	12, // Paket-Layout
								
								text: 	[
									"Wie Sie sehen können, sind die einzelnen Paket-Distrikte unterschiedlich verteilt. Die zentralen Distrikte der Visualisierung stellen stets die Pakete der Grundmenge dar. Zur Grundmenge " +
									"gehören diejenigen Pakete, deren Strukturinformationen extrahiert werden sollen. Das ist in diesem Fall das eben betrachtete Paket mit dem Namen \"/GSA/VISAP_T_TEST\". Grundsätzlich kann " +
									"die Grundmenge auch aus mehreren Paketen bestehen, denn je nach Granularität der Analyse können die Pakete von genau einem Modul bis zu allen Paketen eines Namensraums extrahiert werden.",
									"Ringförmig um die Grundmenge befinden sich die Paket-Distrikte der kundeneigenen Entwicklungen, die von den Bestandteilen der Grundmenge referenziert werden.",
									"Wiederum ringförmig um die Grundmenge und den referenzierten, kundeneigenen Entwicklungen sind die von der Grundmenge verwendeten Paket-Distrikte des SAP-Standards dargestellt",
									"Fahren Sie mit der Maus über einige Paket-Distrikte und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI1",

								viewpoint : "330 550 5500"
							},

							{ 	number:	19, // Navigationsmodi
								
								text: 	[
									"Nachdem Sie jetzt alle Bestandteile der Metapher kennengelernt haben, werden Sie mit der Steuerung vertraut gemacht.",
									"Durch Drücken der linken Maustaste und gleichzeitigem Bewegen der Maus wird das Modell um den zentralen Punkt gedreht.",
									"Außerdem können Sie in das Modell hinein- beziehungsweise aus dem Modell herauszoomen, indem Sie das Mausrad herunter- beziehungsweise hochscrollen.",
									"Abschließend ist es durch Drücken der mittleren Maustaste und gleichzeitigem Bewegen der Maus möglich, in dem Modell entsprechend der Mausbewegung zu navigieren.",
									"Probieren Sie die einzelnen Steuerungsvarianten aus und navigieren Sie durch das Modell. Beenden Sie anschließend die Aufgabe über die Schaltfläche."
								],		

								ui: 	"UI2",

								viewpoint : "330 550 5500"
							},

							{ 	number:	20, // Suchleiste
								
								text: 	[
									"Nachdem Sie nun mit der Steuerung in der Metapher vertraut sind, lernen Sie die weiteren Funktionalitäten des UIs kennen.",
									"Zunächst wird Ihnen die Suchleiste vorgestellt. Wenn Sie das Gebäude eines bestimmten ABAP-Objekts näher untersuchen möchten, geben Sie dessen Bezeichner in der Suchleiste über dem Modell ein. "
									+ "Besitzt das ABAP-Objekt keinen eindeutigen Bezeichner (wie beispielsweise bei Methoden), empfiehlt es sich, den eindeutigen Bezeichner des übergeordnenten ABAP-Objekts mit einem " 
									+ "abschließenden \".\" voranzustellen. Soll beispielsweise Methode \"Y\" der Klasse \"X\" untersucht werden, würde der Suchstring so aussehen: \"X.Y\".",
									"Während der Eingabe des Suchbegriffs erscheinen in einem Dropdown-Menü verschiedene Suchvorschläge in alphanumerischer Reihenfolge. Klicken Sie auf den Bezeichner des gesuchten ABAP-Objekts, " + 
									"fliegt die Kamera zu dem entsprechenden Gebäude. Dieses wird dann auch rot hervorgehoben.",
									"Probieren Sie die Suchleiste und suchen beispielsweise nach der Klasse \"/GSA/CL_AQP_HIST\". Beenden Sie anschließend die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI3",

								viewpoint : "330 550 5500"
							},

							{ 	number:	21, // Package Explorer
								
								text: 	[
									"Als nächstes lernen Sie den Package Explorer kennen. Diesen sehen Sie links neben der Visualisierung. Im Package Explorer finden Sie in einer hierarchischen Ordnung alle ABAP-Objekte, " +
									"die in der Visualisierung dargestellt sind. In diesem Beispiel sind anfangs nur die Bezeichner aller Oberpakete zu sehen. Klicken Sie auf den Pfeil ganz links von einem Bezeichner, " +
									"werden die Bezeichner der dem Paket untergeordneten ABAP-Objekte angezeigt.",
									"Wenn Sie im Package Explorer auf den Bezeichner eines ABAP-Objekts klicken, fliegt die Kamera zu dem ABAP-Objekt und es wird rot hervorgehoben.",
									"Eine weitere nützliche Funktionalität des Package Explorers besteht darin, Objekte in der Visalisierung ausblenden zu können. Dazu klicken Sie auf das Häkchen links neben dem Bezeichner " +
									"eines ABAP-Objekts. Anschließend werden dessen Gebäude sowie die Gebäude aller dem selektierten ABAP-Objekt untergeordneten ABAP-Objekte ausgeblendet.",
									"Lassen Sie die Kamera zu der Klasse \"/GISA/CL_BWBCI_EXTRAC\" aus dem Paket \"/GISA/BWBCI_EXTRACT\" fliegen, indem Sie sie im Package Explorer suchen. Blenden Sie die Klasse vollständig aus.",
									"Beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI4",

								viewpoint : "330 550 5500"
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

        {	name: 	"canvasFlyToController",			
			parentLevel: 1
		},

		{	name:	"searchController",
		},

		{	name:	"packageExplorerController",
		},
		
		{	name: 	"canvasFilterController" 
		},

		{	name: 	"navigationCamControllerPZR",
			setCenterOfRotation : false,
			setCenterOfRotationFocus: false,
			showCenterOfRotation: false,
			macUser: false,
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
					],						
				}
			}
			
		},

		{	name: "UI1",
		
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
                    name: "canvas",
                    canvas: {},
                    controllers: [
                        { name: "defaultLogger" },
                        { name: "canvasHoverController" },
                    ],
				}
			}
		},

		{	name: "UI2",
		
			navigation: {
				//examine, walk, fly, helicopter, lookAt, turntable, game
				type:	"examine",
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
                    name: "canvas",
                    canvas: {},
                    controllers: [
                        { name: "defaultLogger" },
                        { name: "canvasHoverController" },
                        //{ name:	"navigationCamControllerPZR" },
                    ],
                }
			}
		},

		{	name: "UI3",
		
			navigation: {
				//examine, walk, fly, helicopter, lookAt, turntable, game
				type:	"examine",
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
						{ name: "searchController"},
					],							
				},
				second: {
                    size: "80%",
                    collapsible: false,
                    name: "canvas",
                    canvas: {},
                    controllers: [
                        { name: "defaultLogger" },
                        { name: "canvasHoverController" },
                        { name: "canvasFlyToController" },
                        { name: "canvasSelectController" },
                    ],
                }
			}
		},
		
		{	name: "UI4",
		
			navigation: {
				//examine, walk, fly, helicopter, lookAt, turntable, game
				type:	"examine",
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
						{ name: "searchController"},
					],							
				},
				
                second: {
                    size: "80%",
                    collapsible: false,
                    area: {
                        orientation: "vertical",
                        name: "leftPanel",
                        first: {                            
							size: "70%",
                            expanders: [
                                {
                                    name: "packageExplorer",
                                    title: "Package Explorer",
                                    controllers: [
                                        { name: "packageExplorerController" }
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
								{ name: "canvasFlyToController" },
							],
                        }
                    }
				}			
			}
		},
	]
};