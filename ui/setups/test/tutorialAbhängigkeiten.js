var setup = {
	
	controllers: [
		
		//experimentController
		{	name: 	"experimentController",
		
			taskTextButtonTime: 10,
			taskTime: 5,
		
			//stepOrder:	[ 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 ],
			stepOrder:	[ 12, 13, 14, 15 ],
						
            steps:	[				
                        { 	number:	12, // Anzeigen von Aufrufbeziehungen
                            
                            text: 	[
                                "Eine weitere nützliche Funktionalität im UI ist das Anzeigen von Beziehungen. Um sich die Beziehungen eines ABAP-Objekts anzeigen zu lassen, müssen Sie entweder das entsprechende " +
                                "Gebäude direkt in der Visualisierung mit Linksklick selektieren, oder sie suchen das ABAP-Objekt über die Suchleiste bzw. den Package Explorer. Das selektierte Gebäude wird dann wie " +
                                "gewohnt rot hervorgehoben. Die Gebäude der ABAP-Objekte, die mit dem selektierten ABAP-Objekt in Beziehung stehen, werden schwarz dargestellt und durch eine blaue Linie mit dem roten " +
                                "Gebäude verbunden, sofern sie sich nicht auf dem gleichen Distrikt befinden.",
                                "Grundsätzlich werden drei Arten von Beziehungen unterschieden. Zum einen gibt es sogenannte Aufrufbeziehungen. Diese entstehen, wenn ein Quellcodeobjekt ein anderes Quellcoeobjekt, " +
                                "beispielsweise eine Methode einen Funktionsbaustein, aufruft oder auf eine Datenbanktabelle zugreift. Hierbei werden nicht nur die direkten Beziehungen des selektierten ABAP-Objekts " +
                                "angezeigt, sondern auch die indirekten. Ruft beispielsweise Methode \"A\" die Methode \"B\" und Methode \"B\" die Methode \"C\" auf, wird bei Selektion von \"A\" nicht nur die Beziehung " +
                                "zu \"B\" dargestellt, sondern auch die Beziehung von \"B\" zu \"C\".",
                                "Wählen Sie beispielhaft eine Methode und lassen Sie sich deren Aufrufbeziehungen anzeigen. Verfolgen Sie, welche anderen Quellcodeobjekte und Tabellen die selektierte Methode aufruft. " +
                                "Beenden Sie die Aufgabe anschließend über die Schaltfläche."
                            ],		

                            ui: 	"UI1",

                            entities:   [
                                "ID_d20016547f489da25167fa1dbe9a00bfd82298c0" 	// entspricht /GSA/AQP_CL_HIST
                            ]
                        },

                        { 	number:	13, // Anzeigen von Verwendungsbeziehungen
                            
                            text: 	[
								"Zum anderen gibt es sogenannte Verwendungsbeziehungen. Diese können einerseits zwischen DDIC-Objekten entstehen, wenn beispielsweise ein Datenelement von einer Domäne oder ein " + 
								"Tabellentyp von einer bestimmten Struktur abgeleitet ist. Andererseits bilden Verwendungsbeziehungen zusätzlich die Typ-Beziehungen von Attributen ab. Ist ein Attribut zum Beispiel vom " +
								"Typ einer Klasse oder eines Datenelements, existiert eine Verwendungsbeziehung zwischen dem Attribut und der Klasse beziehungsweise dem Datenelement.",
								"Die letzte Art von Beziehungen bilden die Vererbungs- und Implementierungsbeziehungen. Diese entstehen, wenn eine Klasse von einer anderen Klasse erbt, oder eine Klasse oder Interface " +
								"ein anderes Interface erweitert. Jene Beziehungsart soll an dieser Stelle jedoch nicht weiter betrachtet werden.",
								"Wählen Sie beispielhaft ein Strukurelement und lassen Sie sich dessen Verwendungsbeziehungen anzeigen. Verfolgen Sie, welches DDIC-Objekt von dem Strukturelement verwendet wird. Beenden " +
								"Sie die Aufgabe wieder über die Schaltfläche."
                            ],		

                            ui: 	"UI1",

                            entities:   [
                                "ID_d20016547f489da25167fa1dbe9a00bfd82298c0" 	// entspricht /GSA/AQP_CL_HIST
                            ]
                        },

                        { 	number:	14, // kaskadierende Abbildung
                            
                            text: 	[
								"Nun kann es sein, dass nicht nur die Verwendungsbeziehungen einzelner Strukturelemente relevant sind, sondern die der ganzen Struktur. Des Weiteren könnte man sich nicht nur für die " +
								"Beziehungen genau einer Methode interessieren, sondern auch für die aller Bestandteile einer Klasse oder gar eines Pakets. Für diese Szenarien gibt es im UI die Möglichkeit, sich die " +
								"Beziehungen von hierarchisch zusammengehörigen ABAP-Objekten gleichzeitig anzeigen zu lassen. Dazu muss das entsprechende, übergeordnete Objekt, wie beispielsweise eine Klasse, " +
								"selektiert werden. Dann werden die Verwendungsbeziehungen aller Attribute und die Aufrufbeziehungen aller Methoden der selektierten Klasse angezeigt.",
								"Mittels der Anzeige von Beziehungen lassen sich die Abhängigkeiten der Objekte der Grundmenge zu anderen Paketen untersuchen. Grundsätzlich sollte gelten, dass die DDIC- und Quellcode" +
								"objekte vorrangig Beziehungen zu Objekten aus dem eigenen Paket besitzen, da dieses möglichst viele Bestandteile der zu realisierenden Funktionalität kapseln sollte. Weniger Beziehungen " +
								"sollten zu Objekten anderer Pakete der Grundmenge oder zum SAP-Standard bestehen. Des Weiteren sollten die Objekte der Grundmenge möglichst wenig Beziehungen zu den referenzierten, " +
								"kundeneigenen Entwicklungen besitzen, weil dies auf Abhängigkeiten fachlich eigentlich getrennter Module hinweist, was im Allgemeinen zu vermeiden ist.",
								"Betrachten Sie die Klassen von vorhin und schätzen Sie deren Abhängigkeiten ein. Beenden Sie anschließend die Aufgabe wieder über die Schaltfläche."
                            ],		

                            ui: 	"UI1",

                            viewpoint: "100 300 40"		// entspricht /GSA/VISAP_T_TEST_REPORT
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