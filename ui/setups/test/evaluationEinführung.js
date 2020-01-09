var setup = {
	
	controllers: [
		
		{	name: 	"experimentController",
		
			taskTextButtonTime: 10,
			taskTime: 5,
		
			stepOrder:	[ 10, 11, 12 ],
						
			steps:		[				
							{ 	number:	10, // Einführung Tooltip
								
								text: 	[
									"Herzlich Willkommen zur Evaluation der bisherigen Entwicklungen des Projekts \"VISAP\".",
									"Für die Visualisierung von ABAP-Quellcode wird die Stadtmetapher verwendet, bei der die verschiedenen Bestandteile von ABAP als Distrikte (Stadtteile) oder Gebäude dargestellt werden. " +
									"Alle repräsentierten ABAP-Objekte werden stets auf einem grauen Distrikt positioniert, der das enthaltende Paket darstellt. Wenn Sie die Maus über die Bestandteile der Visualisierung " +
									"bewegen, erscheint ein Tooltip. Der Tooltip enthält Informationen zu dem ABAP-Objekt, welches durch das entsprechende Gebäude oder Distrikt repräsentiert wird. In der ersten Zeile "+
									"steht der Name des enthaltenden Pakets und darunter der Typ sowie der Bezeichner des ABAP-Objekts.",
									"Betrachten Sie die Visualisierung und finden Sie heraus, welches ABAP-Objekt durch den großen, violetten Distrikt repräsentiert wird und zu welchem Paket es gehört. Betätigen Sie " +
									"anschließend die \"Aufgabe abgeschlossen!\"-Schaltfläche oben rechts zwei mal."
								],		

								ui: 	"UI0",

								entities : [
                                    "ID_4a1fcd61ea91761f22632560b0f27d84e18318fa" 	// entspricht ZI01
								]
							},

							{ 	number:	11, // Paket-Layout
								
								text: 	[
									"Die zentralen Distrikte der Visualisierung stellen die Pakete der Grundmenge dar. Zur Grundmenge gehören diejenigen Pakete, deren Strukturinformationen extrahiert werden sollen. " +
									"Das sind in diesem Fall mehrere Z-Pakete aus dem GT3-System. Je nach Granularität der geforderten Analyse kann die Grundmenge aus Paketen genau eines Moduls bis zu allen Paketen eines " + 
									"Namensraums bestehen. Ringförmig um die Grundmenge befinden sich die Paket-Distrikte der kundeneigenen Entwicklungen, die von den Bestandteilen der Grundmenge referenziert werden.",
									"Wiederum ringförmig um die Grundmenge und den referenzierten, kundeneigenen Entwicklungen sind die von der Grundmenge verwendeten Paket-Distrikte des SAP-Standards dargestellt",
									"Fahren Sie mit der Maus über einige Paket-Distrikte und bestimmen Sie den Namen des größten Pakets, welches zu den kundeneigenen Entwicklungen aber nicht zur Grundmenge gehört. "+
									"Beenden Sie die Aufgabe wieder über die Schaltfläche."
								],		

								ui: 	"UI0",

								viewpoint : "4500 2000 17000" // Überblick

							},

							{ 	number:	12, // Navigationsmodi
								
								text: 	[
									"Nachdem Sie jetzt die Grundzüge der Metapher kennengelernt haben, werden Sie mit der Steuerung vertraut gemacht.",
									"Durch Drücken der linken Maustaste und gleichzeitigem Bewegen der Maus wird das Modell um einen festen Punkt gedreht.",
									"Außerdem können Sie in das Modell hinein- beziehungsweise aus dem Modell herauszoomen, indem Sie mit dem Mausrad hoch- beziehungsweise herunterscrollen.",
									"Abschließend ist es durch Drücken der mittleren Maustaste/des Mausrads und gleichzeitigem Bewegen der Maus möglich, in dem Modell entsprechend der Mausbewegung zu navigieren.",
									"Probieren Sie die einzelnen Steuerungsvarianten aus und navigieren Sie zum größten Distrikt des SAP-Standards. Beenden Sie anschließend die Aufgabe über die Schaltfläche."
								],		

								ui: 	"UI1",

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
	],
	
	
	

	uis: [

		{	name: "UI0", // hover
		
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

		{	name: "UI1", // hover + navigation
		
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
                    ],
                }
			}
		},
	]
};