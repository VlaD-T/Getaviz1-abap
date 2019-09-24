var relationTransparencyController = (function() {

		
	var noFadeValue = 0;
	
	var relatedEntities = new Array();
	var parents = new Array();

	var activated = false;
	var faded = false;

	const typeProject = ["Class", "Interface", "ParameterizableClass", "Attribute", "Method"];
	const ddicElements = ["Domain", "DataElement", "ABAPStructure", "StrucElement", "Table", "TableElement", "TableType", "TableTypeElement"];
	const abapSCElements = ["Report", "Formroutine", "FunctionModule"];

	//for showing the dependance to the SAP standard
	const majorSCElements = ["Class", "Interface", "FunctionGroup", "Report"];
	const minorSCElements = ["Method", "FunctionModule", "Formroutine", "Attribute"];
	const majorDDICElements = ["Domain", "ABAPStructure", "Table"];
	const minorDDICElements = ["DataElement", "StrucElement", "TableElement", "TableType", "TableTypeElement"];
	
	//config parameters	
	var controllerConfig = {
		fullFadeValue : 0.85,
		halfFadeValue : 0.55,
		noFadeValue : 0,
		startFaded: false,
		showDependanceToStandard: true,
		showChildrenOfMajorElements: true,
	}
		
		
		
	
	
	function initialize(setupConfig){	
		
		application.transferConfigParams(setupConfig, controllerConfig);	

		

        events.selected.on.subscribe(onRelationsChanged);
    }
	
	function activate(){
		activated = true;	
		
		if(controllerConfig.startFaded){
			setTimeout(fadeAll, 1000);			
		}

		if(relatedEntities.length != 0){			
			fadeEntities();
		}
	}

	function deactivate(){
		reset();
		activated = false;
	}

	function reset(){
		if(faded){
			setTimeout(unfadeAll, 1000);							
		}
		faded = false;
	}

	
	function unfadeAll(){
		//realy realy bad fix for one model where elements in scene but not in model...
		//add an all elements functionality for canvasmanipulator anyway 
		var allCanvasElementIds = canvasManipulator.getElementIds();
		var allCanvasObjects = [];
		allCanvasElementIds.forEach(function(canvasElementId){
			allCanvasObjects.push({id:canvasElementId});
		});

		canvasManipulator.changeTransparencyOfEntities(allCanvasObjects, controllerConfig.noFadeValue);	
	}
	
	
	
	function onRelationsChanged(applicationEvent) {
		
		//fade old related entities and parents
		if(activated){	
			if(relatedEntities.length != 0){				
				canvasManipulator.changeTransparencyOfEntities(relatedEntities, controllerConfig.fullFadeValue);		
			}			
			if(parents.length != 0){			
				canvasManipulator.changeTransparencyOfEntities(parents, controllerConfig.fullFadeValue);						
			}	
		}


		//get new related entites
		var entity = applicationEvent.entities[0];	
		
		relatedEntities = new Array();
				
		if (controllerConfig.showDependanceToStandard) {
			if (majorSCElements.includes(entity.type)) {
				if (entity.type == "Class" || entity.type == "Interface") {
					relatedEntities = relatedEntities.concat(entity.superTypes);
					// relatedEntities = relatedEntities.concat(entity.subTypes);
					relatedEntities = relatedEntities.concat(entity.children);
				} else if (entity.type == "Report") {
					relatedEntities = relatedEntities.concat(entity.calls);
					relatedEntities = relatedEntities.concat(entity.children);
				} else if (entity.type == "FunctionGroup") {
					relatedEntities = relatedEntities.concat(entity.children);
				}
			} else if (minorSCElements.includes(entity.type)) {
				if (entity.type == "Attribute") {
					relatedEntities = relatedEntities.concat(entity.typeOf);
				} else { //Method or FunctionModule or Formroutine
					relatedEntities = relatedEntities.concat(entity.calls);
				}
			} else if (majorDDICElements.includes(entity.type)) {
				relatedEntities = relatedEntities.concat(entity.children);
			} else if (minorDDICElements.includes(entity.type)) {
				relatedEntities = relatedEntities.concat(entity.typeOf);
			} else if (entity.type == "Namespace")
				relatedEntities = relatedEntities.concat(entity.children);
		} else {
			if (typeProject.includes(entity.type)) {
				if (entity.type == "Class" || entity.type == "ParameterizableClass" || entity.type == "Interface") {
					relatedEntities = relatedEntities.concat(entity.superTypes);
					relatedEntities = relatedEntities.concat(entity.subTypes);
				} else if (entity.type == "Attribute") {
					//relatedEntities = entity.accessedBy;
					relatedEntities = relatedEntities.concat(entity.accessedBy);
					relatedEntities = relatedEntities.concat(entity.typeOf);
				} else if (entity.type == "Method") {
					relatedEntities = relatedEntities.concat(entity.calls);
					relatedEntities = relatedEntities.concat(entity.calledBy);
				}
			} else if (abapSCElements.includes(entity.type)) {
				relatedEntities = relatedEntities.concat(entity.calls);
				relatedEntities = relatedEntities.concat(entity.calledBy);
			} else if (ddicElements.includes(entity.type)) {
				if (entity.type == "Domain" || entity.type == "Table" || entity.type == "ABAPStructure") {
					relatedEntities = relatedEntities.concat(entity.typeUsedBy);
				} else {
					relatedEntities = relatedEntities.concat(entity.typeOf);
					relatedEntities = relatedEntities.concat(entity.typeUsedBy);
				}
			}
		}

		
		if(relatedEntities.length == 0){
			return;
		}

		

		if (controllerConfig.showDependanceToStandard) {
			getAllRelatedEntities(entity, relatedEntities, true);
		} else {
			//get parents of related entities
			parents = new Array();
			relatedEntities.forEach(function(relatedEntity){
				parents = parents.concat(relatedEntity.allParents);
			});
		}

		if(activated){
			fadeEntities();
		}
		
	}
	
	function getAllRelatedEntities(newSourceEntity, newRelatedEntities, ignore) {

		newRelatedEntities.forEach(function(relatedEntity) {

			if (!ignore) {
				if (relatedEntities.includes(relatedEntity)) {
					return;
				}
	
				//skipping recursive calls of newSourceEntity
				if (relatedEntity == newSourceEntity)
					return;
	
				relatedEntities.push(relatedEntity);
			}
			

			//only for non-standard-elements
			if (relatedEntity.allParents[relatedEntity.allParents.length - 1].isStandard == false) {
				//get further relations
				var newerRelatedEntities = getRelatedEntities(relatedEntity);
				
				if (newerRelatedEntities.length == 0)
					return;
				
				if (newerRelatedEntities[0] === undefined)
					return;			

				getAllRelatedEntities(relatedEntity, newerRelatedEntities, false);
				
			}	
		})
	}

	function getRelatedEntities(entity) {
		var newRelatedEntities = new Array();

		if (majorSCElements.includes(entity.type)) {
			if (entity.type == "Report") {
				newRelatedEntities = newRelatedEntities.concat(entity.calls);
			}
			if (controllerConfig.showChildrenOfMajorElements || (entity.type == "Class" && entity.belongsTo.type != "Namespace")) {
				newRelatedEntities = newRelatedEntities.concat(entity.children);
			}
		} else if (minorSCElements.includes(entity.type)) {
			if (entity.type == "Attribute") {
				newRelatedEntities = newRelatedEntities.concat(entity.typeOf);
			} else {
				newRelatedEntities = newRelatedEntities.concat(entity.calls);
			}
		} else if (majorDDICElements.includes(entity.type)) {
			if (entity.type == "ABAPStructure" || entity.type == "Table")
				newRelatedEntities = newRelatedEntities.concat(entity.children);
		} else if (minorDDICElements.includes(entity.type)) {
			newRelatedEntities = newRelatedEntities.concat(entity.typeOf);
		}
		return newRelatedEntities;
	}

	function fadeEntities(){
		
		//first relation selected -> fade all entities				
		fadeAll();
						
		//unfade related entities
		canvasManipulator.changeTransparencyOfEntities(relatedEntities, controllerConfig.noFadeValue);
				
		//unfade parents of related entities				
		canvasManipulator.changeTransparencyOfEntities(parents, controllerConfig.halfFadeValue);
	}

	function fadeAll(){
		if(!faded){			
			//really really bad fix for one model where elements in scene but not in model...
			//add an all elements functionality for canvasmanipulator anyway 
			var allCanvasElementIds = canvasManipulator.getElementIds();
			var allCanvasObjects = [];
			allCanvasElementIds.forEach(function(canvasElementId){
				allCanvasObjects.push({id:canvasElementId});
			});


			canvasManipulator.changeTransparencyOfEntities(allCanvasObjects, controllerConfig.fullFadeValue);
			faded = true;
		}
	}
	
	
	 return {
        initialize: 	initialize,
		activate: 		activate,
		deactivate:		deactivate,
		reset: 			reset
    };    
})();
	
    