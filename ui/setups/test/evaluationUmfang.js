var setup = {
	
	controllers: [
		
		{	name: 	"experimentController",
		
			taskTextButtonTime: 10,
			taskTime: 3,
		
			stepOrder:	[ 10, 11, 12, 13, 14, 15 ],
						
            steps:	[				
						{ 	number:	10, // Klassen
                            
                            text: 	[
								"Globale Klassen werden als gelbe Distrikte visualisiert. Auf den gelben Distrikten befinden sich die Bestandteile der Klasse als Gebäude. Methoden sind hierbei als graue Quader " +
                                "dargestellt, deren Höhe abhängig von der Anzahl ihrer Statements ist. Die Attribute der Klasse werden durch schwarze Zylinder repräsentiert, deren Höhe wiederum durch den Typ des " +
								"des Attributs bestimmt wird. Attribute von elementarem Typ werden kleiner als die Attribute von strukturierten Typen dargestellt. Am größten sind Attribute, die eine interne Tabelle oder " +
								"eine Klassenreferenz darstellen.",
                                "Im Gegensatz zu globalen Klassen befinden sich lokale Klassen auf den Distrikten ihrer übergeordneten ABAP-Objekte. Dies können neben globalen Klassen auch Funktionsgruppen oder Reports " +
                                "sein. Grundsätzlich sollten globale Klassen höchstens eine lokale Klasse für Unit-Tests besitzen. Die Funktionalität der Klasse sollte über mindestens drei Methoden realisiert werden. Je " +
								"nach Funktionalität sollten Klassen etwa 10, jedoch nicht mehr als 15 Methoden besitzen.",
								"Betrachten Sie die Visualisierung der Klasse der Grundmenge und suchen Sie nach globalen Klassen, die a) einen guten, b) einen mittelmäßigen und c) einen schlechten Umfang an Methoden und " +
								"Attributen besitzen. Beenden Sie anschließend die Aufgabe wieder über die Schaltfläche."
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
                                "Für die Gebäude der Methoden und Attribute exisitert ein spezielles Anordnungsschema:",
								"Die Gebäude der privaten Klassenbestandteile werden vorrangig im Zentrum des Distrikts angeordnet, da sie nur innerhalb der Klasse verwendet werden können. Die Gebäude der öffentlichen " +
								"Klassenbestandteile sind hingegen am Rand des Klassendistrikts positioniert.",
								"Grundsätzlich gilt für Klassen, dass der Großteil der Daten und Funktionalitäten privat gehalten werden soll. Dementsprechend sollte die Metrik \"Number Of Statements\" von privaten " +
								"Methoden größer sein als die von öffentlichen Methoden. Überhaupt sollten die öffentlichen Methoden wenig Funktionalität enthalten.",
								"Ähnliches gilt für die Attribute einer Klasse. Eine Klasse sollte deutlich mehr private als öffentliche Attribute besitzen. Außerdem sollte ab einer Anzahl von 10 skalaren Attributen " +
								"stattdessen eine Struktur als Attribut verwendet werden. Genauso sollten mehr als 9 strukturierte Attribute in einem referenziellen Attribut gekapselt werden.",
								"Betrachten Sie die Visualisierung und suchen Sie nach einer globalen Klasse, die a) eine gute, b) eine mittelmäßige und c) eine schlechte Verteilung von Methoden und Attributen besitzt.",
								"Beenden Sie die Aufgabe über die Schaltfläche."
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
                                "Reports und ihre Bestandteile sind auf den hellblauen Distrikten dargestellt. Im Zentrum des Distrikts steht der Report selbst noch einmal als dunkelblauer Quader. Darum befinden sich die " +
                                "die Gebäude für die Formroutinen des Reports (graue Quader) und die globalen Attribute als Zylinder. Die Höhe der Gebäude der Formroutinen und des Reports ist wie bei Klassen abhängig von " +
								"der Metrik \"Number Of Statements\".",
								"Reports sollten ausschließlich als aufrufendes Element für Funktionalität aus Klassen eingesetzt werden. Die dafür notwendige Funktionalität sollte in einer lokalen Klasse gehalten werden. " +
								"Formroutinen oder globale Attribute werden somit nicht benötigt und sollten vermieden werden.",
								"Erkunden Sie die Visualisierung des Reports. Suchen Sie in der gesamten Visualisierung nach mehreren Reports, die die Qualitätskriterien a) vollständig, b) teilweise und c) gar nicht " +
								"umsetzen. Beenden Sie die Aufgabe wieder über die Schaltfläche."
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
                                "Funktionsgruppen sind als violette Distrikte dargestellt. Auf einem Funktionsgruppen-Distrikt befinden sich Zylinder für die globalen Attribute sowie graue Quader als Gebäude für die " +
                                "Funktionsbausteine und Formroutinen der Funktionsgruppe. Die Gebäude der Funktionsbausteine besitzen eine rechteckige Grundfläche, während die Grundfläche der Gebäude der Formroutinen " +
								"quadratisch ist. Die Höhe beider Gebäudearten ist wieder durch die Metrik \"Number Of Statements\" bestimmt.",
								"Funktionsgruppen sollten nur noch für RFC und den Aufruf klassischer Dynpros in Popups verwendet werden. Dementsprechend sollte eine Funktionsgruppe nicht mehr als zwei Funktionsbausteine " +
								"enthalten. Die Funktionsbausteine sollten die Verarbeitung sofort an eine globale oder lokale Klasse abgeben, sodass die Funktionsgruppe höchstens eine lokale Klasse enthält. Auf " +
								"Formroutinen und globale Attribute sollte dagegen komplett verzichtet werden.",
								"Erkunden Sie die Visualisierung der Funktionsgruppe. Suchen Sie in der gesamten Visualisierung nach Funktionsgruppen, die die Qualitätsempfehlungen a) vollständig, b) teilweise und c) " +
								"gar nicht umsetzen. Beenden Sie anschließend die Aufgabe wieder über die Schaltfläche."
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
								"Als nächstes soll die Metrik \"Number of Statements\" betrachtet werden. Die Höhe der Gebäude von Methoden, Reports, Formroutinen und Funktionsbausteinen korreliert linear mit der " +
								"Anzahl ihrer Code-Statements. Grundsätzlich sollte gelten, dass ein funktionales Quellcodeobjekt nicht mehr als 50 Statements enthält. Demzufolge sind alle ABAP-Objekte, die 50 oder " +
								"mehr Statements enthalten, als Gebäude mit der größten Höhe dargestellt. Besitzt beispielsweise eine Methode 25 Statements, ist sie entsprechend nur halb so hoch. Als Richtwert für eine " +
								"gute Anzahl von Statements kann 30 angesehen werden.",
								"Suchen Sie in der Visualisierung nach Gebäuden von funktionalen Quellcodeobjekten, die a) eine passende und b) eine zu große Anzahl an Statements besitzen. Beenden Sie die Aufgabe " +
								"wieder über die Schaltfläche."
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
								"Abschließend soll der Umfang von Paketen eingeschätzt werden. Prinzipiell dient ein Paket dazu, ABAP-Objekte, die für einen größeren fachlichen Zweck erstellt wurden, zu modularisieren. " +
								"Die Funktionalität zur Erreichung des größeren fachlichen Zwecks soll dann auf mehrere Quellcodeobjekte verteilt werden. Dementsprechend sollte ein Paket circa 10 Quellcodeobjekte " +
								"enthalten, mindestens jedoch 5. Eine Verteilung der Funktionalität sollte dabei auf nicht mehr als 20 Quellcodeobjekte erfolgen, da in diesem Fall eine feinere Aufteilung in mehrere " +
								"Pakete zu prüfen ist.",
								"Suchen Sie in der Visualisierung im Bereich der Grundmenge nach Paketen, die a) zu wenige, b) eine passende Anzahl und c) zu viele Quellcodeobjekte besitzen. Beenden Sie die Aufgabe " +
								"anschließend wieder über die Schaltfläche." 
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

		{ 	name: 	"canvasResetViewController" 
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