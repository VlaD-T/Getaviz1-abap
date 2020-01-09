var setup = {
	
	controllers: [
		
		{	name: 	"experimentController",
		
			taskTextButtonTime: 10,
			taskTime: 5,
		
			stepOrder:	[ 10, 11 ],
						
            steps:	[				
                        { 	number:	10, // Anzeigen von Aufrufbeziehungen
                            
                            text: 	[
                                "Im UI ist das Anzeigen von Beziehungen möglich. Um sich die Beziehungen eines ABAP-Objekts anzeigen zu lassen, müssen Sie das entsprechende Gebäude in der Visualisierung mit " +
                                "Linksklick selektieren. Das selektierte Gebäude wird dann rot hervorgehoben. Die Gebäude der ABAP-Objekte, die mit dem selektierten ABAP-Objekt in Beziehung stehen, werden schwarz " +
                                "dargestellt und durch eine blaue Linie mit dem roten Gebäude verbunden, sofern sie sich nicht auf dem gleichen Distrikt befinden.",
                                "Grundsätzlich werden drei Arten von Beziehungen unterschieden, wobei jedoch für diese Evaluation lediglich die Aufrufbeziehungen relevant sind. Diese entstehen, wenn ein Quellcodeobjekt " +
                                "ein anderes Quellcodeobjekt, beispielsweise eine Methode einen Funktionsbaustein, aufruft. Hierbei werden nicht nur die direkten Beziehungen des selektierten ABAP-Objekts angezeigt, " +
                                "sondern auch die indirekten. Ruft beispielsweise Methode \"A\" die Methode \"B\" und Methode \"B\" die Methode \"C\" auf, wird bei Selektion von \"A\" nicht nur die Beziehung zu " +
                                "\"B\" dargestellt, sondern auch die Beziehung von \"B\" zu \"C\".",
                                "Wählen Sie beispielhaft eine Methode und lassen Sie sich deren Aufrufbeziehungen anzeigen. Verfolgen Sie, welche anderen Quellcodeobjekte und Tabellen die selektierte Methode aufruft. " +
                                "Beenden Sie die Aufgabe anschließend über die Schaltfläche."
                            ],		

                            ui: 	"UI0",

                            entities:   [
                                "ID_02615d941a7cc8a8dc867ab3bcdc6da1fdb8338f" 	// entspricht ZCL_EXCEL_AUTOFILTER
                            ]
                        },

                        { 	number:	11, // kaskadierende Abbildung
                            
                            text: 	[
								"Nun kann es sein, dass nicht nur die Beziehungen einzelner Methoden relevant sind, sondern die aller Methoden einer bestimmten Klasse. Für diese Szenarien gibt es im UI die Möglichkeit, " +
								"die Beziehungen von hierarchisch zusammengehörigen ABAP-Objekten gleichzeitig anzuzeigen. Dazu muss das entsprechende, übergeordnete Objekt, wie beispielsweise eine Klasse, " +
								"selektiert werden. Dann werden die Aufrufbeziehungen aller Methoden der selektierten Klasse angezeigt.",
								"Mittels der Anzeige von Beziehungen lassen sich die Abhängigkeiten der Objekte der Grundmenge zu anderen Paketen untersuchen. Grundsätzlich sollte gelten, dass die Quellcodeobjekte vorrangig" +
								"Beziehungen zu Objekten aus dem eigenen Paket besitzen, da dieses möglichst viele Bestandteile der zu realisierenden Funktionalität kapseln sollte. Weniger Beziehungen sollten zu Objekten " +
								"anderer Pakete der Grundmenge oder zum SAP-Standard bestehen. Des Weiteren sollten die Objekte der Grundmenge möglichst wenig Beziehungen zu den referenzierten, kundeneigenen Entwicklungen " +
								"besitzen, weil dies auf Abhängigkeiten fachlich eigentlich getrennter Module hinweist, was im Allgemeinen zu vermeiden ist.",
								"Betrachten Sie die Klassen von vorhin und schätzen Sie deren Abhängigkeiten ein. Beenden Sie anschließend die Aufgabe wieder über die Schaltfläche."
                            ],		

                            ui: 	"UI0",

                            entities:   [
                                "ID_02615d941a7cc8a8dc867ab3bcdc6da1fdb8338f" 	// entspricht ZCL_EXCEL_AUTOFILTER
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
								{ name: "canvasFilterController" },								
								{ name: "canvasSelectController" },
								{ name: "canvasFlyToController" },
								{ name:	"relationConnectorController" },
								{ name:	"relationHighlightController" },
								{ name:	"relationTransparencyController" },
							],
                        }
                    }
				}
			}
		},

	]
};