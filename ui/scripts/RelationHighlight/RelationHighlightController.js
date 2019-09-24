var relationHighlightController = function(){
		
	var relatedEntities = new Array();
	
	const typeProject = ["Class", "Interface", "ParameterizableClass", "Attribute", "Method"];
	const ddicElements = ["Domain", "DataElement", "ABAPStructure", "StrucElement", "Table", "TableElement", "TableType", "TableTypeElement"];
	const abapSCElements = ["Report", "Formroutine", "FunctionModule"];

	//for showing the dependance to the SAP standard
	const majorSCElements = ["Class", "Interface", "FunctionGroup", "Report"];
	const minorSCElements = ["Method", "FunctionModule", "Formroutine", "Attribute"];
	const majorDDICElements = ["Domain", "ABAPStructure", "Table"];
	const minorDDICElements = ["DataElement", "StrucElement", "TableElement", "TableType", "TableTypeElement"];
	
	var activated = false;

	//config parameters	
	var controllerConfig = {
		showDependanceToStandard: true,
		showChildrenOfMajorElements: true,
	}
	
	function initialize(config){		
		events.selected.on.subscribe(onRelationsChanged);
	}
	
	function activate(){	
		
		activated = true;
		if(relatedEntities.length != 0){
			highlightRelatedEntities();
		}
	}

	function deactivate(){	
		reset();
		activated = false;
	}
	
	function reset(){
		canvasManipulator.resetColorOfEntities(relatedEntities);
	}
	
	
	function resetColor(){
		if(relatedEntities.length == 0){	
			return;
		}

		var relatedEntitesMap = new Map();
		
		//highlight related entities
		relatedEntities.forEach(function(relatedEntity){		
			if(relatedEntity.marked){
				return;
			}
			
			if(relatedEntitesMap.has(relatedEntity)){
				return;
			}

			relatedEntitesMap.set(relatedEntity, relatedEntity);
		});

		canvasManipulator.resetColorOfEntities(Array.from(relatedEntitesMap.keys()));
	}
		
	
	function onRelationsChanged(applicationEvent) {
		
		resetColor();
		
		
		//get related entites
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
		}
		
		if(activated){
			highlightRelatedEntities();
		}
		
	}

	function getAllRelatedEntities(newSourceEntity, newRelatedEntities, ignore) {

		newRelatedEntities.forEach(function(relatedEntity) {

			if (relatedEntity.type == "FunctionModule")
				events.log.info.publish({ text: "debug"});

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

	function highlightRelatedEntities(){
		var relatedEntitesMap = new Map();
		
		//highlight related entities
		relatedEntities.forEach(function(relatedEntity){		
			if(relatedEntity.marked){
				return;
			}
			
			if(relatedEntitesMap.has(relatedEntity)){
				return;
			}

			relatedEntitesMap.set(relatedEntity, relatedEntity);
		});
			
		canvasManipulator.changeColorOfEntities(Array.from(relatedEntitesMap.keys()), "0 0 0");			
	}

		

	return {
        initialize	: initialize,
		reset		: reset,
		activate	: activate,
		deactivate	: deactivate
    };    

}();