var setup = {
	
	controllers: [
		
		//experimentController
		{	name: 	"experimentController",
		
			taskTextButtonTime: 10,
			taskTime: 5,
		
			stepOrder:	[ 10, 11, 12, 13, 14, 15 ],
						
			steps:		[				
							{ 	number:	10, // allgemeine Einführung
								
								text: 	[
									"Herzlich Willkommen zur Evaluation der bisherigen Entwicklungen des Projekts \"VISAP\".",
									"Am Anfang erhalten Sie eine kurze Einführung in die Softwarevisualisierung von ABAP sowie in die Bestandteile des User Interface. Anschließend lernen Sie die einzelnen Elemente der " +
									"Visualisierung kennen. Bei manchen Visualisierungen von ABAP-Objekten werden Ihnen Qualitätsempfehlungen für das entsprechende ABAP-Objekt gegeben. Ziel dieser Evaluation soll keine " +
									"Diskussion der Qualitätsempfehlungen sein, sondern die Überprüfung ebendieser mit dem bisherigen Stand der Softwarevisualisierung. Diesbezüglich wird Ihnen als Aufgabe gestellt, bestimmte " +
									"Elemente in der Visualisierung zu selektieren.", 
									"Grundsätzlich soll die Visualisierung von ABAP-Quellcode dazu dienen, die kundeneigenen Entwicklungen in einem SAP-System unter einem strukturellen Aspekt zu untersuchen. Dafür wird die " +
									"Stadtmetapher verwendet, bei der die verschiedenen Bestandteile von ABAP als Distrikte (Stadtteile) oder Gebäude dargestellt werden.",
									"Betrachten Sie die Visualisierung kurz im Überblick und betätigen Sie anschließend die \"Aufgabe abgeschlossen!\"-Schaltfläche oben rechts zwei mal."
								],		

								ui: 	"UI0"
							},
							
							{ 	number:	11, // Einführung Tooltip
								
								text: 	[
									"Im Folgenden lernen Sie die einzelnen Bestandteile des User Interface kennen.",
									"In der Visualisierung werden die Distrikte oder Gebäude, die die ABAP-Objekte repräsentieren, stets auf einem grauen Distrikt positioniert, der das enthaltende Paket darstellt. Wenn Sie " +
									"die Maus über die Bestandteile der Visualisierung bewegen, erscheint ein Tooltip. Dieser Tooltip enthält zum einen den Namen des enthaltenden Pakets. Darunter steht der Typ des " +
									"repräsentierten ABAP-Objekts sowie anschließend dessen Bezeichner.",
									"Fahren Sie mit der Maus über einige Bestandteile des Pakets und machen Sie sich damit vertraut, welche Objekttypen alles dargestellt werden können. Beenden Sie die Aufgabe wieder über " +
									"die Schaltfläche."
								],		

								ui: 	"UI1",
								
								entities : [
                                    "ID_4a1fcd61ea91761f22632560b0f27d84e18318fa" 	// entspricht ZI01
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

								viewpoint : "4500 2750 20000" // Überblick
							},

							{ 	number:	13, // Navigationsmodi // TODO Beschreibung des neuen Navigationsmodus einbauen
								
								text: 	[
									"Nachdem Sie jetzt alle Bestandteile der Metapher kennengelernt haben, werden Sie mit der Steuerung vertraut gemacht.",
									"Durch Drücken der linken Maustaste und gleichzeitigem Bewegen der Maus wird das Modell um den zentralen Punkt gedreht.",
									"Außerdem können Sie in das Modell hinein- beziehungsweise aus dem Modell herauszoomen, indem Sie die rechte Maustaste gedrückt halten und die Maus bewegen.",
									"Abschließend ist es durch Drücken der mittleren Maustaste und gleichzeitigem Bewegen der Maus möglich, in dem Modell entsprechend der Mausbewegung zu navigieren.",
									"Probieren Sie die einzelnen Steuerungsvarianten aus und navigieren Sie durch das Modell. Beenden Sie anschließend die Aufgabe über die Schaltfläche."
								],		

								ui: 	"UI2",

								viewpoint : "4500 2750 20000" // Überblick
							},

							{ 	number:	14, // Suchleiste
								
								text: 	[
									"Nachdem Sie nun mit der Steuerung in der Metapher vertraut sind, lernen Sie die weiteren Funktionalitäten des UIs kennen.",
									"Zunächst wird Ihnen die Suchleiste vorgestellt. Wenn Sie das Gebäude eines bestimmten ABAP-Objekts näher untersuchen möchten, geben Sie dessen Bezeichner in der Suchleiste über dem Modell " +
									"ein. Besitzt das ABAP-Objekt keinen eindeutigen Bezeichner (wie beispielsweise bei Methoden), empfiehlt es sich, den eindeutigen Bezeichner des übergeordnenten ABAP-Objekts mit einem " +
									"abschließenden \".\" voranzustellen. Soll beispielsweise Methode \"Y\" der Klasse \"X\" untersucht werden, würde der Suchstring so aussehen: \"X.Y\".",
									"Während der Eingabe des Suchbegriffs erscheinen in einem Dropdown-Menü verschiedene Suchvorschläge in alphanumerischer Reihenfolge. Klicken Sie auf den Bezeichner des gesuchten ABAP-Objekts, " + 
									"fliegt die Kamera zu dem entsprechenden Gebäude. Dieses wird dann auch rot hervorgehoben.",
									"Probieren Sie die Suchleiste und suchen beispielsweise nach der Klasse \"ZCL_ZI_CHANGE_PSP_DATE_SRV\". Beenden Sie anschließend die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI3",

								viewpoint : "4500 2750 20000" // Überblick
							},

							{ 	number:	15, // Package Explorer
								
								text: 	[
									"Als nächstes lernen Sie den Package Explorer kennen. Diesen sehen Sie links neben der Visualisierung. Im Package Explorer finden Sie in einer hierarchischen Ordnung alle ABAP-Objekte, " +
									"die in der Visualisierung dargestellt sind. In diesem Beispiel sind anfangs nur die Bezeichner aller Oberpakete zu sehen. Klicken Sie auf den Pfeil ganz links von einem Bezeichner, " +
									"werden die Bezeichner der dem Paket untergeordneten ABAP-Objekte angezeigt.",
									"Wenn Sie im Package Explorer auf den Bezeichner eines ABAP-Objekts klicken, fliegt die Kamera zu dem ABAP-Objekt und es wird rot hervorgehoben.",
									"Eine weitere nützliche Funktionalität des Package Explorers besteht darin, Objekte in der Visalisierung ausblenden zu können. Dazu klicken Sie auf das Häkchen links neben dem Bezeichner " +
									"eines ABAP-Objekts. Anschließend werden dessen Gebäude sowie die Gebäude aller dem selektierten ABAP-Objekt untergeordneten ABAP-Objekte ausgeblendet.",
									"Lassen Sie die Kamera zu der Klasse \"ZCL_EXCEL_DRAWING\" aus dem Paket \"ZSD_CWS_PRINT_ABAP2XLSX\" fliegen, indem Sie sie im Package Explorer suchen. Blenden Sie die Klasse vollständig aus.",
									"Beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI4",

								viewpoint : "4500 2750 20000" // Überblick
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

		{   name:   "navigationCamController",

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
                        { name:	"navigationCamController" },
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
					size: "220px",	
					
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
                        { name:	"navigationCamController" },
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
							size: "20%",
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
								{ name:	"navigationCamController" },
							],
                        }
                    }
				}			
			}
		},
	]
};