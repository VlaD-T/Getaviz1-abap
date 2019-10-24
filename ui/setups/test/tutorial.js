var setup = {
	
	controllers: [
		
		//experimentController
		{	name: 	"experimentController",
		
			taskTextButtonTime: 10,
			taskTime: 5,
		
			stepOrder:	[ 10, 11, 12, 13, 14, 15, 16, 17, 18 ],
						
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

							{ 	number:	14,
								
								text: 	[
										"Reports und ihre Bestandteile sind auf den hellblauen Distrikten dargestellt. Dabei wird ein Report selbst durch einen dunkelblauen Quader im Zentrum des Distrikts repräsentiert.",
										"Außerdem befinden sich auf dem Distrikt die Gebäude für die Formroutinen des Reports (graue Quader). Die Höhe der Gebäude der Formroutinen und des Reports sind abhängig von",
										"der Anzahl ihrer Statements. Die globalen Attribute des Reports sind als Zylinder dargestellt.",
										"Erkunden Sie die Visualisierung des Reports und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI1",

								viewpoint: "100 300 40"		// entspricht /GSA/VISAP_T_TEST_REPORT
							},

							{ 	number:	15,
								
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

							{ 	number:	16,
								
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

							{ 	number:	17,
								
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

							{ 	number:	18,
								
								text: 	[
										"In diesem Bildausschnitt sehen Sie die Visualisierung von Datenbanktabellen. Diese befinden sich auf einem dunkelblauen Distrikt und sind als flache, braune Quader dargestellt.",
										"Auf diesem braunen Quader befinden sich türkisfarbene Quader, die die Tabellenelemente, also die Spalten, repräsentieren.", 
										"Sind ein oder mehrere Tabellentypen aus dem gleichen Paket von der Tabelle abgeleitet, befinden diese sich wie bei Strukturen auf dem gleichen Distrikt.",
										"Erkunden Sie die Visualisierung der Tabelle und beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI1",

								viewpoint: "680 30 130"	// entspricht /GSA/VISAP_T_T2
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