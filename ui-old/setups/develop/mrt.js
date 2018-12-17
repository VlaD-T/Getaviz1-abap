﻿var setup = {
		
	controllers: [	

		{ 	name: 	"defaultLogger",

			logActionConsole	: false,
			logActionEventConsole	: false,
			logEventConsole		: false,
			logInfoConsole : true,
            logWarningConsole: true,
            logErrorConsole: true
		},		
		{	name: 	"canvasHoverController",
			hoverColor: "blue",
			showVersion: false,
			showIncidents: true
		},	
		{	name: 	"canvasMarkController",
			//TODO pars by config
			eventHandler: [{
				handler : "onEntityMarked",
				event 	: events.marked.on
			},{
				handler : "onEntityUnmarked",
				event 	: events.marked.off
			}],
			
			//as function
			actionEventCoupling:	function(controller){
				actionController.actions.mouse.key[2].up.subscribe(function(actionEvent){
					if(!actionEvent.entity){
						return;
					}

					if(!actionController.actions.keyboard.key[32].pressed){
						return;
					}

					var entity = actionEvent.entity;

					var applicationEvent = {				
						sender		: canvasMarkController,
						entities	: [entity]		
					};
					
					if(entity.marked){
						events.marked.off.publish(applicationEvent);		
					} else {
						events.marked.on.publish(applicationEvent);		
					}
				});

				events.marked.on.subscribe(controller.onEntityMarked);
				events.marked.off.subscribe(controller.onEntityUnmarked); 
			},
			
			//as config
			//TODO pars by actionEventMapper			
			actionEventCouplingConfig: [{
				event		: events.marked.off,

				constraints	: [{
					action : actionController.actions.mouse.key[2].up						
				}, {
					entity : [{
						marked	: true
					}]
				}, {
					pressed : actionController.actions.keyboard.key[32].pressed
				}]					
			}, {
				event		: events.marked.on,

				constraints	: [{
					action : actionController.actions.mouse.key[2].up						
				}, {
					entity : [{
						marked	: false
					}]
				}, {
					pressed : actionController.actions.keyboard.key[32].pressed
				}],
			}],

		},
		{	name: 	"canvasFilterController" 
		},
		{ 	name: 	"canvasFlyToController" ,
                        targetType: "Namespace"
		},
		{ 	name: 	"canvasResetViewController" 
		},
		{	name: 	"searchController" 
		},
        {	name: 	"packageExplorerController",
		},
		{	name: 	"versionExplorerController",
		}
	],
	
	uis: [{
		name: "MRT",
		navigation: { type:	"examine" },
		area: {
            name: "search",
            orientation: "horizontal",
            collapsible: false,
            resizable: false,
            first: {
                size: "50px",
                controllers: [{ name: "searchController" }]
            },
		    second: {
			    collapsible: false,
                size: "80%",
                area: {
                    orientation: "vertical",
                    name: "topDown",
                    first: {
                        size: "20%",
                        collapsible: false,
                        expanders: [{
                            name: "packageExplorer",
                            title: "Package Explorer",
                            controllers: [{name: "packageExplorerController"}]
                        }]
                    },
                    second: {
                        size: "60%",
                        collapsible: false,
                        area: {
                            name: "canvas",
                            orientation: "vertical",
                            collapsible: false,
                            first: {
                                size: "80%",
                                canvas: {},
                                collapsible: false,
                                controllers: [
                                    {name: "defaultLogger"},
                                    {name: "canvasHoverController"},
                                    {name: "canvasFilterController"},
                                    {name: "canvasSelectController"},
                                    {name: "canvasMarkController"},
                                    {name: "canvasFlyToController"}
                                ]
                            },
                            second: {
                                size: "20%",
                                area: {
                                    //collapsible: false,
                                    orientation: "horizontal",
                                    first: {
                                        size: "100%",
                                        collapsible: false,
                                        expanders: [{
                                            name: "versionExplorer",
                                            title: "Version Selector",
                                            controllers: [{name: "versionExplorerController"}]
                                        }]
                                    },
                                    second: {}
                                    ,
                                },
                            },
                        },
                    },
                },
			},
		},
	}],
};