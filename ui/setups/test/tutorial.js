var setup = {
	
	controllers: [
		
		//experimentController
		{	name: 	"experimentController",
		
			taskTextButtonTime: 10,
			taskTime: 5,
		
			stepOrder:	[ 10, 17 ],
						
			steps:		[				
							{ 	number:	10,
								
								text: 	[
										"Herzlich Willkommen zum Tutorial für die Evalution von VISAP.",
										"Dieses Tutorial gibt Ihnen einen Einblick in den bisherigen Stand der Softwarevisualisierung von ABAP.",
										"Die Visualisierung von ABAP-Quellcode soll dazu dienen, die kundeneigenen Entwicklungen in einem SAP-System unter einem strukturellen Aspekt zu untersuchen.",
										"Dafür wird die sogenannte Stadtmetapher verwendet, bei der die verschiedenen Bestandteile von ABAP als Distrikte (Stadtteile) oder Gebäude dargestellt werden.",
										"Betrachten Sie die Visualisierung kurz im Überblick und betätigen Sie anschließend die \"Aufgabe abgeschlossen!\"-Schaltfläche oben rechts zwei mal."
								],		

								ui: 	"UI0"
							},
							
							{ 	number:	11,
								
								text: 	[
										"Im Folgenden lernen Sie die einzelnen Bestandteile der Visualisierung kennen.",
										"Die grauen Distrikte repräsentieren die Pakete. Wenn Sie mit der Maus über einen grauen Distrikt hovern, erscheint im Tooltip der Name des Pakets.",
										"Auf dem Distrikt befinden sich die Visualisierungen der ABAP-Objekte, die dem entsprechenden Paket zugeordnet sind.",
										"Dies können Klassen, Datenelemente oder auch die Unterpakete des betrachteten Pakets sein. ",
										"Fahren Sie mit der Maus über einige Bestandteile des Pakets und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI0",
								
								entities : [
                                    "ID_919b44a73b780a53b5aaf69ae6a50250facf245c" 	// entspricht /GSA/VISAP_T_TEST
								]
							},

							{ 	number:	12,
								
								text: 	[
										"Wie Sie sehen können, sind die einzelnen Paket-Distrikte unterschiedlich verteilt. Die zentralen Distrikte der Visualisierung stellen stets die Pakete der Grundmenge dar.",
										"Zur Grundmenge gehören diejenigen Pakete, deren Strukturinformationen extrahiert werden sollen. Das ist in diesem Fall das eben betrachtete Paket mit dem Namen \"/GSA/VISAP_T_TEST\".",
										"Ringförmig um die Grundmenge befinden sich die Paket-Distrikte der kundeneigenen Entwicklungen, die von den Bestandteilen der Grundmenge referenziert werden.",
										"Wiederum ringförmig um die Grundmenge und den referenzierten, kundeneigenen Entwicklungen sind die von der Grundmenge verwendeten Paket-Distrikte des SAP-Standards dargestellt",
										"Fahren Sie mit der Maus über einige Paket-Distrikte und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI1",

								viewpoint : "335 300 4500"
							},

							{ 	number:	13,
								
								text: 	[
										"Klassen sind als dunkelblaue Gebäude in hellgrauen Stadtteilen, den Paketen, dargestellt.",
										"Jedes hellblaue Stockwerk ist eine Methode und jeder gelber Schornstein auf dem Dach des Gebäudes ein Attribut.",
										"Beim Überfahren der Elemente mit der Maus wird der Name in einem Tooltip angezeigt.",
										"Versuchen Sie sich in der Visualisierung zu bewegen und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI1",

								entities : [
                                    "ID_d20016547f489da25167fa1dbe9a00bfd82298c0" 	// entspricht /GSA/AQP_CL_HIST
								]
							},

							{ 	number:	14,
								
								text: 	[
										"Klassen sind als dunkelblaue Gebäude in hellgrauen Stadtteilen, den Paketen, dargestellt.",
										"Jedes hellblaue Stockwerk ist eine Methode und jeder gelber Schornstein auf dem Dach des Gebäudes ein Attribut.",
										"Beim Überfahren der Elemente mit der Maus wird der Name in einem Tooltip angezeigt.",
										"Versuchen Sie sich in der Visualisierung zu bewegen und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI1",

								viewpoint: "600 100 40"		// entspricht /GSA/VISAP_T_TEST_REPORT4
							},

							{ 	number:	15,
								
								text: 	[
										"Klassen sind als dunkelblaue Gebäude in hellgrauen Stadtteilen, den Paketen, dargestellt.",
										"Jedes hellblaue Stockwerk ist eine Methode und jeder gelber Schornstein auf dem Dach des Gebäudes ein Attribut.",
										"Beim Überfahren der Elemente mit der Maus wird der Name in einem Tooltip angezeigt.",
										"Versuchen Sie sich in der Visualisierung zu bewegen und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI1",

								entities : [
									"ID_42d2a6ad49f93ab4b987b1a9e738425aacb8d2af"	// entspricht /GSA/VISAP_T_TEST_FG2
								]
							},

							{ 	number:	16,
								
								text: 	[
										"Klassen sind als dunkelblaue Gebäude in hellgrauen Stadtteilen, den Paketen, dargestellt.",
										"Jedes hellblaue Stockwerk ist eine Methode und jeder gelber Schornstein auf dem Dach des Gebäudes ein Attribut.",
										"Beim Überfahren der Elemente mit der Maus wird der Name in einem Tooltip angezeigt.",
										"Versuchen Sie sich in der Visualisierung zu bewegen und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI1",

								viewpoint: "600 300 40"		// entspricht /GSA/VISAP_T_TEST_DO1
							},

							{ 	number:	17,
								
								text: 	[
										"Klassen sind als dunkelblaue Gebäude in hellgrauen Stadtteilen, den Paketen, dargestellt.",
										"Jedes hellblaue Stockwerk ist eine Methode und jeder gelber Schornstein auf dem Dach des Gebäudes ein Attribut.",
										"Beim Überfahren der Elemente mit der Maus wird der Name in einem Tooltip angezeigt.",
										"Versuchen Sie sich in der Visualisierung zu bewegen und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI1",

								entities : [
									"ID_412a33ae14746612317b013dc23213cd79b5f3f3"	// entspricht /GISA/BWBCI_EXTR_MAC
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
		
		
	],
	
	
	

	uis: [

		{	name: "UI0",
		
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
                        { name: "canvasResetViewController" }	
					],							
				},
				second: {
					size: "90%",	
					collapsible: false,
					
					
							
					canvas: { },
					
					controllers: [
						
						{ name: "defaultLogger" },
                        { name: "canvasHoverController" }								

					],						
				}
			}
			
		},

		{	name: "UI1",
		
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
					size: "90%",	
					collapsible: false,
					
					
							
					canvas: { },
					
					controllers: [
						{ name: "defaultLogger" },											

						{ name: "canvasHoverController" },
                        { name: "canvasSelectController" },
                        { name: "canvasFlyToController" },
					],						
				}
			}
			
		}
	
	]
};