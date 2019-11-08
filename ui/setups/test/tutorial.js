var setup = {
	
	controllers: [
		
		//experimentController
		{	name: 	"experimentController",
		
			taskTextButtonTime: 10,
			taskTime: 5,
		
			stepOrder:	[ 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 ],
			//stepOrder:	[ 10, 21 ],
						
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
									"Wie Sie sehen können, sind die einzelnen Paket-Distrikte unterschiedlich verteilt. Die zentralen Distrikte der Visualisierung stellen stets die Pakete der Grundmenge dar.",
									"Zur Grundmenge gehören diejenigen Pakete, deren Strukturinformationen extrahiert werden sollen. Das ist in diesem Fall das eben betrachtete Paket mit dem Namen \"/GSA/VISAP_T_TEST\".",
									"Ringförmig um die Grundmenge befinden sich die Paket-Distrikte der kundeneigenen Entwicklungen, die von den Bestandteilen der Grundmenge referenziert werden.",
									"Wiederum ringförmig um die Grundmenge und den referenzierten, kundeneigenen Entwicklungen sind die von der Grundmenge verwendeten Paket-Distrikte des SAP-Standards dargestellt",
									"Fahren Sie mit der Maus über einige Paket-Distrikte und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI1",

								viewpoint : "330 550 5500"
							},

							{ 	number:	13, // Klassen
								
								text: 	[
									"Globale Klassen werden als gelbe Distrikte visualisiert. Auf den  gelben Distrikten befinden sich die Bestandteile der Klasse als Gebäude.",
									"Methoden sind hierbei als graue Quader dargestellt, deren Höhe abhängig von ihrer Anzahl der Statements ist.",
									"Die Attribute der Klasse werden durch Zylinder repräsentiert, deren Höhe wiederum durch die Komplexität der Information, die das entsprechende Attribut speichert,",
									"bestimmt wird. Außerdem exisitert ein spezielles Anordnungsschema für die Gebäude der Methoden und Attribute:",
									"Die Gebäude der Klassenbestandteile, die privat sind, werden im Zentrum des Distrikts angeordnet, wohingegen die geschützten und öffentlichen am Rand positioniert sind.",
									"Lokale Klassen werden analog zu globalen visualisiert. Jedoch befinden sie sich nicht direkt auf einem Paketdistrikt wie der Distrikt einer globalen Klasse,",
									"sondern sie sind auf dem Distrikt des definierenden ABAP-Objekts platziert. Dies können neben denen der globalen Klassen auch die Distrikte der Funktionsgruppen und Reports sein.",
									"Betrachten Sie die Visualisierung der Klasse und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI1",

								entities : [
                                    "ID_d20016547f489da25167fa1dbe9a00bfd82298c0" 	// entspricht /GSA/AQP_CL_HIST
								]
							},

							{ 	number:	14, // Reports
								
								text: 	[
									"Reports und ihre Bestandteile sind auf den hellblauen Distrikten dargestellt. Dabei wird ein Report selbst durch einen dunkelblauen Quader im Zentrum des Distrikts repräsentiert.",
									"Außerdem befinden sich auf dem Distrikt die Gebäude für die Formroutinen des Reports (graue Quader). Die Höhe der Gebäude der Formroutinen und des Reports sind abhängig von",
									"der Anzahl ihrer Statements. Die globalen Attribute des Reports sind als Zylinder dargestellt.",
									"Erkunden Sie die Visualisierung des Reports und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI1",

								viewpoint: "100 300 40"		// entspricht /GSA/VISAP_T_TEST_REPORT
							},

							{ 	number:	15, // Funktionsgruppen
								
								text: 	[
									"Funktionsgruppen sind analog zu Klassen als violette Distrikte dargestellt. Auf einem Funktionsgruppen-Distrikt befinden sich Zylinder für die globalen Attribute,",
									"sowie graue Quader als Gebäude für die Funktionsbausteine und Formroutinen der Funktionsgruppe. Die Gebäude der Funktionsbausteine besitzen eine rechteckige Grundfläche,",
									"während die Grundfläche der Gebäude der Formroutinen quadratisch ist. Die Höhe beider Gebäudearten ist ebenfalls durch die Anzahl ihrer Statements bestimmt.",
									"Erkunden Sie die Visualisierung der Funktionsgruppe und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI1",

								entities : [
									"ID_4dea1daedbe9dc1d643b0f0eb8ab57c7d532f771"	// entspricht /GSA/VISAP_T_TEST_FG1
								]
							},

							{ 	number:	16, // Domänen und Datenelemente
								
								text: 	[
									"Domänen und Datenelemente sind auf grünen Distrikten dargestellt. Domänen sind hierbei als grüne Zylinder im Zentrum des Distrikts visualisiert.",
									"Diejenigen Datenelemente, welche von der Domäne aus dem gleichen Paket abgeleitet sind, sind am Rand des Distrikts durch dunkelgrüne Zylinder repräsentiert.",
									"Außerdem befinden sich die Gebäude der Datenelemente, die vom gleichen eingebauten Typ abgeleitet sind, auf einem gemeinsamen Distrikt ohne Domänengebäude,",
									"ebenso wie die Gebäude der Datenelemente, die von einer Domäne aus einem anderen Paket abgeleitet sind.",
									"Erkunden Sie die Visualisierung der Domäne und Datenelemente und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI1",

								viewpoint: "800 280 20"		// entspricht /GSA/VISAP_T_TEST_DO1
							},

							{ 	number:	17, // Strukturen
								
								text: 	[
									"Strukturen sind als hellgrüne Distrikte dargestellt. Auf den hellgrünen Distrikten befinden sich die Gebäude der Komponenten der Struktur, die sogenannten Strukturelemente.",
									"Dies sind graue Kegel, die am Rand des Struktur-Distrikts positioniert sind. Sind ein oder mehrere Tabellentypen aus dem gleichen Paket von der Struktur abgeleitet,",
									"befinden sich diese ebenfalls auf dem Struktur-Distrikt. Sie sind dann als rosafarbene Kegel visualisiert.",
									"Erkunden Sie die Visualisierung der Struktur und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI1",

								entities : [
									"ID_412a33ae14746612317b013dc23213cd79b5f3f3"	// entspricht /GISA/BWBCI_EXTR_MAC
								]
							},

							{ 	number:	18, // Tabellen
								
								text: 	[
									"In diesem Bildausschnitt sehen Sie die Visualisierung von Datenbanktabellen. Diese befinden sich auf einem dunkelblauen Distrikt und sind als flache, braune Quader dargestellt.",
									"Auf diesem braunen Quader befinden sich türkisfarbene Quader, die die Tabellenelemente, also die Spalten, repräsentieren.", 
									"Sind ein oder mehrere Tabellentypen aus dem gleichen Paket von der Tabelle abgeleitet, befinden diese sich wie bei Strukturen auf dem gleichen Distrikt.",
									"Erkunden Sie die Visualisierung der Tabelle und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI1",

								viewpoint: "680 30 130"	// entspricht /GSA/VISAP_T_T2
							},

							{ 	number:	19, // Navigationsmodi
								
								text: 	[
									"Nachdem Sie jetzt alle Bestandteile der Metapher kennengelernt haben, werden Sie mit der Steuerung vertraut gemacht.",
									"Durch Drücken der rechten Maustaste und gleichzeitigem Bewegen der Maus wird das Modell um den zentralen Punkt gedreht.",
									"Außerdem können Sie in das Modell hinein- beziehungsweise aus dem Modell herauszoomen, indem Sie das Mausrad herunter- beziehungsweise hochscrollen.",
									"Abschließend ist es durch Drücken der linken Maustaste und gleichzeitigem Bewegen der Maus möglich, in dem Modell entsprechend der Mausbewegung zu navigieren.",
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

		{   name: "legendController",
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
            },{
                name: "Domain/Data Element",
                icon: "scripts/Legend/tutorial/domain_district.png",
            },{
                name: "Structure",
                icon: "scripts/Legend/tutorial/structure_district.png",
            },{
                name: "Table",
                icon: "scripts/Legend/tutorial/table_district.png",
            }],
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
							],
                        }
                    }
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
								//{ name:	"navigationCamControllerPZR" },
							],
                        }
                    }
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
							],
                        }
                    }
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
							area: {
								size: "50%",
								collapsible: false,
								orientation: "horizontal",
								name: "packagePanel",
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
									size: "90%",
									expanders: [								
										{
											name: "legend",
											title: "Legend",
											controllers: [
												{ name: "legendController" }
											],
										},
									]
								}
							}							
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