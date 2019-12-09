var setup = {
	
	controllers: [
		
		//experimentController
		{	name: 	"experimentController",
		
			taskTextButtonTime: 10,
			taskTime: 5,
		
			//stepOrder:	[ 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 ],
			stepOrder:	[ 17, 18 ],
						
            steps:	[				
						{ 	number:	10, // Domänen und Datenelemente
									
							text: 	[
								"Im Folgenden lernen Sie die einzelnen Bestandteile der Visualisierung kennen, beginnend bei den DDIC-Objekten.",
								"Domänen und Datenelemente sind auf grünen Distrikten dargestellt. Domänen sind hierbei als grüne Zylinder im Zentrum des Distrikts visualisiert. Diejenigen Datenelemente, welche von einer " +
								"Domäne aus dem gleichen Paket abgeleitet sind, sind am Rand des Distrikts durch dunkelgrüne Zylinder repräsentiert. Außerde, befinden sich die Gebäude der Datenelemente, die vom gleichen " +
								"eingebauten Typ abgeleitet sind, auf einem gemeinsamen Distrikt ohne Domänengebäude, ebenso wie die Gebäude der Datenelemente, die von einer Domäne aus einem anderen Paket abgeleitet sind",
								"Erkunden Sie die Visualisierung der Domäne und Datenelemente und beenden Sie die Aufgabe wieder über die Schaltfläche."
							],		

							ui: 	"UI1",

							viewpoint: "800 280 20"		// entspricht /GSA/VISAP_T_TEST_DO1
						},

						{ 	number:	11, // Strukturen
							
							text: 	[
								"Strukturen sind als hellgrüne Distrikte dargestellt. Auf den hellgrünen Distrikten befinden sich die Gebäude der Komponenten der Struktur, die sogenannten Strukturelemente. Dies sind " +
								"graue Kegel, die am Rand des Struktur-Distrikts positioniert sind. Sind ein oder mehrere Tabellentypen aus dem gleichen Paket von der Struktur abgeleitet, befinden sich diese ebenfalls " +
								"auf dem Struktur-Distrikt. Sie sind dann als rosafarbene Kegel visualisiert.",
								"Erkunden Sie die Visualisierung der Struktur. Beenden Sie die Aufgabe wieder über die Schaltfläche."
							],		

							ui: 	"UI1",

							entities : [
								"ID_412a33ae14746612317b013dc23213cd79b5f3f3"	// entspricht /GISA/BWBCI_EXTR_MAC
							]
						},

						{ 	number:	12, // Tabellen
							
							text: 	[
								"In diesem Bildausschnitt sehen Sie die Visualisierung von Datenbanktabellen. Diese befinden sich auf einem dunkelblauen Distrikt und sind als flache, braune Quader dargestellt. Auf " +
								"diesem braunen Quader befinden sich türkisfarbene Quader, die die Tabellenelemente, also die Spalten, repräsentieren. Sind ein oder mehrere Tabellentypen aus dem gleichen Paket von " + 
								"der Tabelle abgeleitet, befinden diese sich wie bei Strukturen auf dem gleichen Distrikt.",
								"Erkunden Sie die Visualisierung der Tabelle und beenden Sie die Aufgabe wieder über die Schaltfläche."
							],		

							ui: 	"UI1",

							viewpoint: "680 30 130"	// entspricht /GSA/VISAP_T_T2
						},
				
						{ 	number:	13, // Klassen
                            
                            text: 	[
								"Globale Klassen werden als gelbe Distrikte visualisiert. Auf den gelben Distrikten befinden sich die Bestandteile der Klasse als Gebäude. Methoden sind hierbei als graue Quader " +
                                "dargestellt, deren Höhe abhängig von ihrer Anzahl der Statements ist. Die Attribute der Klasse werden durch Zylinder repräsentiert, deren Höhe wiederum durch die Komplexität der " +
								"Information, die das entsprechende Attribut speichert, bestimmt wird. So ist ein Attribut von elementarem Typ kleiner als die Attribute, die von einem strukturierten Typ sind. Am " +
								"größten sind diejenigen Attribute, die tabellenartig sind oder eine Referenz auf eine Klasse darstellen.",
                                "Lokale Klassen werden analog zu globalen visualisiert. Jedoch befinden sie sich nicht direkt auf einem Paketdistrikt wie der Distrikt einer globalen Klasse, sondern sie sind auf " +
                                "dem Distrikt des definierenden ABAP-Objekts platziert. Dies können neben denen der globalen Klassen auch Distrikte von Funktionsgruppen und Reports sein.",
								"Grundsätzlich sollten globale Klassen höchstens eine lokale Klasse besitzen, nämlich für Unit-Tests. Die Funktionalität der Klasse wird in Methoden abgebildet. Dies sollte über mindestens " +
								"drei Methoden abgewickelt werden. Je nach Granularität der Funktionalität deuten circa 10 Methoden auf eine gute Aufteilung hin. Eine Klasse sollte für gewöhnlich höchstens 15 Methoden " +
								"enthalten. Die zur Erfüllung der Funktionalität benötigten Daten werden in Attributen gekapselt. Demzufolge sollte eine Klasse etwa 5 Attribute besitzen, jedoch mindestens eines und nicht " +
								"mehr als 10.",
								"Betrachten Sie die Visualisierung der Klasse und suchen Sie nach globalen Klassen, die a) einen guten, b) einen mittelmäßigen und c) einen schlechten Umfang an Methoden und Attributen " +
								"besitzen. Beenden Sie anschließend die Aufgabe wieder über die Schaltfläche."
                            ],		

                            ui: 	"UI1",

                            entities:   [
                                "ID_d20016547f489da25167fa1dbe9a00bfd82298c0" 	// entspricht /GSA/AQP_CL_HIST
                            ]
                        },

                        { 	number:	14, // Klassen-Layout
                            
                            text: 	[
                                "Außerdem exisitert ein spezielles Anordnungsschema für die Gebäude der Methoden und Attribute:",
								"Die Gebäude der Klassenbestandteile, die privat sind, werden vorrangig im Zentrum des Distrikts angeordnet, da sie nur von innerhalb der Klasse verwendet werden können. Die Gebäude der " +
								"geschützten und öffentlichen Klassenbestandteile sind hingegen am Rand des Klassendistrikts positioniert.",
								"Grundsätzlich sollte für Klassen gelten, dass ein Großteil der Daten und Funktionalitäten privat gekapselt sind. Dementsprechend sollte die Metrik NumberOfStatements von privaten " +
								"Methoden größer sein als die von öffentlichen Methoden. Überhaupt sollten die öffentlichen Methoden nicht viel Funktionalität beinhalten.",
								"Ähnliches gilt für die Attribute einer Klasse. Eine Klasse sollte deutlich mehr private als öffentliche Attribute besitzen. Außerdem sollte ab einer Anzahl von 10 skalaren Attributen " +
								"stattdessen ein strukturiertes Attribut verwendet werden. Genauso sollten mehr als 9 strukturierte Attribute in einem referenziellen Attribut gekapselt werden.",
								"Betrachten Sie die Visualisierung und suchen Sie nach einer globalen Klasse, die a) eine gute, b) eine mittelmäßige und c) eine schlechte Verteilung von Methoden und Attributen besitzt.",
								"Beenden Sie die Aufgabe über die Schaltfläche."
                            ],		

                            ui: 	"UI1",

                            entities:   [
                                "ID_d20016547f489da25167fa1dbe9a00bfd82298c0" 	// entspricht /GSA/AQP_CL_HIST
                            ]
                        },

                        { 	number:	15, // Reports
                            
                            text: 	[
                                "Reports und ihre Bestandteile sind auf den hellblauen Distrikten dargestellt. Dabei wird ein Report selbst durch einen dunkelblauen Quader im Zentrum des Distrikts repräsentiert. Außerdem " +
                                "befinden sich auf dem Distrikt die Gebäude für die Formroutinen des Reports (graue Quader). Die Höhe der Gebäude der Formroutinen und des Reports sind abhängig von der Anzahl ihrer " +
								"Statements. Die globalen Attribute des Reports sind als Zylinder dargestellt.",
								"Grundsätzlich sollte die Funktionalität eines Programms durch Objektorientierung gewährleistet werden. Reports sollten nur in begründeten Ausnahmefällen, wie zum Beispiel für Transaktionen, " +
								"verwendet werden. In diesen Fällen sollte die Funktionalität dennoch in eine lokale Klasse ausgelagert werden, sodass ein Report stets eine lokale Klasse enthalten sollte; im Ausnahmefall " +
								"auch zwei, wenn die zu realisierende Funktionalität fachlich zu trennen ist. Dementsprechend besteht für die Verwendung von Formroutinen keinerlei Notwendigkeit. Außerdem sollte ein Report " +
								"so wenig globale Attribute wie möglich besitzen.",
								"Erkunden Sie die Visualisierung des Reports. Suchen Sie in der gesamten Visualisierung nach mehreren Reports, die die Qualitätsempfehlungen a) vollständig, b) teilweise und c) gar nicht " +
								"umsetzen. Beenden Sie die Aufgabe wieder über die Schaltfläche."
                            ],		

                            ui: 	"UI1",

                            viewpoint: "100 300 40"		// entspricht /GSA/VISAP_T_TEST_REPORT
                        },

                        { 	number:	16, // Funktionsgruppen
                            
                            text: 	[
                                "Funktionsgruppen sind als violette Distrikte dargestellt. Auf einem Funktionsgruppen-Distrikt befinden sich Zylinder für die globalen Attribute, sowie graue Quader als Gebäude für die " +
                                "Funktionsbausteine und Formroutinen der Funktionsgruppe. Die Gebäude der Funktionsbausteine besitzen eine rechteckige Grundfläche, während die Grundfläche der Gebäude der Formroutinen " +
								"quadratisch ist. Die Höhe beider Gebäudearten ist ebenfalls durch die Anzahl ihrer Statements bestimmt.",
								"Funktionsgruppen und Funktionsbausteine sollten nur noch für RFC und den Aufruf klassischer Dynpros und Selektionsbilder verwendet werden. Dementsprechend sollte eine Funktionsgruppe " +
								"nicht mehr als zwei Funktionsbausteine enthalten. Die Funktionsbausteine sollten die Verarbeitung sofort an eine globale oder lokale Klasse abgeben, sodass die Funktionsgruppe höchstens " +
								"eine lokale Klasse enthält. Auf Formroutinen sollte komplett verzichtet werden, ebenso sollten so wenig globale Attribute wie möglich verwendet werden.",
								"Erkunden Sie die Visualisierung der Funktionsgruppe. Suchen Sie in der gesamten Visualisierung nach Funktionsgruppen, die die Qualitätsempfehlungen a) vollständig, b) teilweise und c) " +
								"gar nicht umsetzen. Beenden Sie anschließend die Aufgabe wieder über die Schaltfläche."
                            ],		

                            ui: 	"UI1",

                            entities : [
                                "ID_4dea1daedbe9dc1d643b0f0eb8ab57c7d532f771"	// entspricht /GSA/VISAP_T_TEST_FG1
                            ]
						},
						
						{ 	number:	17, // number of statements
                            
                            text: 	[
								"Nun kennen Sie alle Bestandteile der Visualisierung. Als nächstes soll die Metrik \"Number of Statements\" betrachtet werden. Die Höhe der Gebäude von Methoden, Reports, Formroutinen " +
								"und Funktionsbausteinen korreliert linear mit der Anzahl ihrer Code-Statements. Grundsätzlich sollte gelten, dass ein funktionales Quellcodeobjekt nicht mehr als 50 Statements enthält. " +
								"Demzufolge sind alle ABAP-Objekte, die 50 oder mehr Statements enthalen, als Gebäude mit der größten Höhe dargestellt. Besitzt beispielsweise eine Methode 25 Statements, ist sie " +
								"entsprechend nur halb so hoch. Als Richtwert für eine guten Anzahl von Statements kann 30 angesehen werden.",
								"Suchen Sie in der Visualisierung nach Gebäuden von funktionalen Quellcodeobjekten, die a) eine passende und b) eine zu große Anzahl an Statements besitzen. Beenden Sie die Aufgabe wieder " +
								"über die Schaltfläche"
                            ],		

                            ui: 	"UI2",

                            viewpoint : "330 550 5500"
						},
						
						{ 	number:	18, // Paketumfang
                            
                            text: 	[
								"Abschließend soll der Umfang von Paketen eingeschätzt werden. Prinzipiell dient ein Paket dazu, ABAP-Objekte, die für einen größeren fachlichen Zweck erstellt wurden, zu modularisieren " +
								"zu kapseln und zu entkoppeln. Die Funktionalität zur Erreichung des größeren fachlichen Zwecks soll dann auf mehrere Quellcodeobjekten verteilt werden. Dementsprechend sollte ein Paket " +
								"circa 10 Quellcodeobjekte enthalten, mindestens jedoch 5. Eine Verteilung der Funktionalität sollte dabei auf nicht mehr als 20 Quellcodeobjekte erfolgen, da in diesem Fall eine " +
								"feingranularere Aufteilung des fachlichen Zwecks in zwei Pakete sinnvoll sein erscheint. Zu der Anzahl der enthaltenen DDIC-Objekte soll keine Empfehlung gegeben werden.",
								"Suchen Sie in der Visualisierung nach Paketen, die a) zu wenig, b) eine passende Anzahl und c) zu viel Quellcodeobjekte besitzen. Beenden Sie die Aufgabe anschließend wieder über die " +
								"Schaltfläche" 
                            ],		

                            ui: 	"UI2",

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

		{	name: "UI5",
		
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
								{ name: "canvasSelectController" },
								{ name: "canvasFlyToController" },
							],
                        }
                    }
				}			
			}
		},	
	]
};