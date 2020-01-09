var setup = {
	
	controllers: [
		
		{	name: 	"experimentController",
		
			taskTextButtonTime: 10,
			taskTime: 5,
		
			stepOrder:	[ 13, 14, 15, 16, 17, 18 ],
						
            steps:	[				
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

                            ui: 	"UI0",

                           /* entities:   [
                                "ID_02615d941a7cc8a8dc867ab3bcdc6da1fdb8338f"	// entspricht ZCL_EXCEL_AUTOFILTER
                            ]*/
                        },

                        { 	number:	14, // Klassen-Layout
                            
                            text: 	[
                                "Außerdem exisitert ein spezielles Anordnungsschema für die Gebäude der Methoden und Attribute:",
								"Die Gebäude der Klassenbestandteile, die privat sind, werden vorrangig im Zentrum des Distrikts angeordnet, da sie nur innerhalb der Klasse verwendet werden können. Die Gebäude der " +
								"geschützten und öffentlichen Klassenbestandteile sind hingegen am Rand des Klassendistrikts positioniert.",
								"Grundsätzlich sollte für Klassen gelten, dass ein Großteil der Daten und Funktionalitäten privat gekapselt sind. Dementsprechend sollte die Metrik NumberOfStatements von privaten " +
								"Methoden größer sein als die von öffentlichen Methoden. Überhaupt sollten die öffentlichen Methoden nicht viel Funktionalität beinhalten.",
								"Ähnliches gilt für die Attribute einer Klasse. Eine Klasse sollte deutlich mehr private als öffentliche Attribute besitzen. Außerdem sollte ab einer Anzahl von 10 skalaren Attributen " +
								"stattdessen eine Struktur als Attribut verwendet werden. Genauso sollten mehr als 9 strukturierte Attribute in einem referenziellen Attribut gekapselt werden.",
								"Betrachten Sie die Visualisierung und suchen Sie nach einer globalen Klasse, die a) eine gute, b) eine mittelmäßige und c) eine schlechte Verteilung von Methoden und Attributen besitzt.",
								"Beenden Sie die Aufgabe über die Schaltfläche."
                            ],		

                            ui: 	"UI0",

                            entities:   [
                                "ID_02615d941a7cc8a8dc867ab3bcdc6da1fdb8338f" 	// entspricht ZCL_EXCEL_AUTOFILTER
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

                            ui: 	"UI0",

                            entities:   [
                                "ID_0d3fa981f2e576a7ef02e0fce64799d965807ef0" 	// entspricht ZSD_SAM_KUEND_KONTROLLE_II
                            ]
                        },

                        { 	number:	16, // Funktionsgruppen
                            
                            text: 	[
                                "Funktionsgruppen sind als violette Distrikte dargestellt. Auf einem Funktionsgruppen-Distrikt befinden sich Zylinder für die globalen Attribute, sowie graue Quader als Gebäude für die " +
                                "Funktionsbausteine und Formroutinen der Funktionsgruppe. Die Gebäude der Funktionsbausteine besitzen eine rechteckige Grundfläche, während die Grundfläche der Gebäude der Formroutinen " +
								"quadratisch ist. Die Höhe beider Gebäudearten ist ebenfalls durch die Anzahl ihrer Statements bestimmt.",
								"Funktionsgruppen und Funktionsbausteine sollten nur noch für RFC und den Aufruf klassischer Dynpros verwendet werden. Dementsprechend sollte eine Funktionsgruppe nicht mehr als zwei " +
								"Funktionsbausteine enthalten. Die Funktionsbausteine sollten die Verarbeitung sofort an eine globale oder lokale Klasse abgeben, sodass die Funktionsgruppe höchstens eine lokale Klasse " +
								"enthält. Auf Formroutinen sollte komplett verzichtet werden, ebenso sollten so wenig globale Attribute wie möglich verwendet werden.",
								"Erkunden Sie die Visualisierung der Funktionsgruppe. Suchen Sie in der gesamten Visualisierung nach Funktionsgruppen, die die Qualitätsempfehlungen a) vollständig, b) teilweise und c) " +
								"gar nicht umsetzen. Beenden Sie anschließend die Aufgabe wieder über die Schaltfläche."
                            ],		

                            ui: 	"UI0",

                            entities : [
                                "ID_27f7098606ea3a4efc3d54e3cf6bfd09c6c50932"	// entspricht /RZ1/SAM_SD018_CHANGE_INET
                            ]
						},
						
						{ 	number:	17, // number of statements
                            
                            text: 	[
								"Als nächstes soll die Metrik \"Number of Statements\" betrachtet werden. Die Höhe der Gebäude von Methoden, Reports, Formroutinen und Funktionsbausteinen korreliert linear mit der " +
								"Anzahl ihrer Code-Statements. Grundsätzlich sollte gelten, dass ein funktionales Quellcodeobjekt nicht mehr als 50 Statements enthält. Demzufolge sind alle ABAP-Objekte, die 50 oder " +
								"mehr Statements enthalen, als Gebäude mit der größten Höhe dargestellt. Besitzt beispielsweise eine Methode 25 Statements, ist sie entsprechend nur halb so hoch. Als Richtwert für eine " +
								"gute Anzahl von Statements kann 30 angesehen werden.",
								"Suchen Sie in der Visualisierung nach Gebäuden von funktionalen Quellcodeobjekten, die a) eine passende und b) eine zu große Anzahl an Statements besitzen. Beenden Sie die Aufgabe " +
								"wieder über die Schaltfläche"
                            ],		

                            ui: 	"UI0",

                            viewpoint : "4500 2000 17000" // Überblick
						},
						
						{ 	number:	18, // Paketumfang
                            
                            text: 	[
								"Abschließend soll der Umfang von Paketen eingeschätzt werden. Prinzipiell dient ein Paket dazu, ABAP-Objekte, die für einen größeren fachlichen Zweck erstellt wurden, zu modularisieren, " +
								"zu kapseln und zu entkoppeln. Die Funktionalität zur Erreichung des größeren fachlichen Zwecks soll dann auf mehrere Quellcodeobjekten verteilt werden. Dementsprechend sollte ein Paket " +
								"circa 10 Quellcodeobjekte enthalten, mindestens jedoch 5. Eine Verteilung der Funktionalität sollte dabei auf nicht mehr als 20 Quellcodeobjekte erfolgen, da in diesem Fall eine " +
								"feingranularere Aufteilung des fachlichen Zwecks in zwei Pakete sinnvoll erscheint. Zu der Anzahl der enthaltenen DDIC-Objekte soll keine Empfehlung gegeben werden.",
								"Suchen Sie in der Visualisierung nach Paketen, die a) zu wenig, b) eine passende Anzahl und c) zu viel Quellcodeobjekte besitzen. Beenden Sie die Aufgabe anschließend wieder über die " +
								"Schaltfläche" 
                            ],		

                            ui: 	"UI0",

                            viewpoint : "4500 2000 17000" // Überblick
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
								{ name: "canvasSelectController" }
							],
                        }
                    }
				}
			}
		},
	]
};