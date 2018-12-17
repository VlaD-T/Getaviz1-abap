var sourceCodeController = (function(){    


    // extra Fenster zur Darstellung des Quellcodes, bietet mehr Platz
    let codeWindow = null;
    // Welche Klasse, Type(Klasse, Methode, Attribut), Attributename
    let lastObject = {file: null, classEntity: null, entity: null};
    


    //config parameters	
	let controllerConfig = {
		fileType : "java",
        url: "",
	};
    
	function initialize(setupConfig){
		application.transferConfigParams(setupConfig, controllerConfig);
	}
	
	function activate(rootDiv){

        //load zTree javascript-files
		$.getScript("libs/prism/prism.js", function(){
			$.getScript("scripts/SourceCode/CodeHelperFunctions.js", function(){	
				
				//load zTree css-files
				let cssLink = document.createElement("link");
				cssLink.type = "text/css";
				cssLink.rel = "stylesheet";
				cssLink.href = "libs/prism/prism.css";
				document.getElementsByTagName("head")[0].appendChild(cssLink);
				
				
				cssLink = document.createElement("link");
				cssLink.type = "text/css";
				cssLink.rel = "stylesheet";
				cssLink.href = "libs/prism/prismPluginCodeController.css";
				document.getElementsByTagName("head")[0].appendChild(cssLink);
				
				//create html elements
				let codeViewDiv = document.createElement("DIV");
				codeViewDiv.id = "codeViewDiv";

                //button                                
                let codeWindowButton = document.createElement("BUTTON");
                codeWindowButton.type = "button";
                codeWindowButton.style = "width: 98%;height: 25px;margin: 2px 0px -2px 2px;";
                codeWindowButton.addEventListener("click", openWindow, false);

                let fullScreenImage = document.createElement("IMG");
                fullScreenImage.src = "scripts/SourceCode/images/fullscreen.png";
                fullScreenImage.style = "width: 25px; height: 20px;";
                
                codeWindowButton.appendChild(fullScreenImage);
                codeViewDiv.appendChild(codeWindowButton);


                //codeField
                let codeValueDiv = document.createElement("DIV");
                codeValueDiv.id = "codeValueDiv";
                
                let codePre = document.createElement("PRE");
                codePre.className = "line-numbers language-java";
                codePre.id = "codePre";
                codePre.style = "overflow:auto;";

                let codeTag = document.createElement("CODE");
                codeTag.id = "codeTag";
                
                codePre.appendChild(codeTag);
                codeValueDiv.appendChild(codePre);
                codeViewDiv.appendChild(codeValueDiv);

				rootDiv.appendChild(codeViewDiv);
            });
		});

        events.selected.on.subscribe(onEntitySelected);
    }


  

    function reset() {                
        resetSourceCode();
		
        if(codeWindow) {
            codeWindow.close();
        }
    }

    function resetSourceCode(){
        lastObject = {file: null, classEntity: null, entity: null};        
        //var codeTag = $("#codeTag")[0].textContent = "";
		
        if(codeWindow) {
            codeWindow.reset();
        }
    }

    function openWindow(){
        codeWindow = window.open("scripts/SourceCode/codepage.html", "CodePage", "width=500,"+
                "height=500, menubar=no, status=no, titlebar=no,"+
                "toolbar=no, scrollbars");
        // lade Quellcode, des zuletzt betrachteten Objekts
        codeWindow.addEventListener('load', displayCodeChild, true);
    }

    function displayCodeChild(){        
        if(codeWindow) {
            codeWindow.displayCode(lastObject.file, lastObject.classEntity, lastObject.entity);
        }
    }

    function onEntitySelected(applicationEvent) {
		
        const entity = applicationEvent.entities[0];

       	if (entity.type === "Namespace"){
			// Package 
			resetSourceCode();
			return;
		}
		// classEntity = Klasse, in der sich das selektierte Element befindet
		// inner Klassen werden auf Hauptklasse aufgeloest
		let classEntity = entity;
		while( classEntity.type !== "Class" ){
			classEntity = classEntity.belongsTo;
		}		
		
		// ersetze . durch / und fuege .java an -> file
        const javaCodeFile = classEntity.qualifiedName.replace(/\./g, "/") + "." + controllerConfig.fileType;

        displayCode(javaCodeFile, classEntity, entity);          
    }

    function displayCode(file, classEntity, entity){
        if (controllerConfig.url === "") {
            file = "../../" + modelUrl + "/src/" + file;
        } else {
            file = controllerConfig.url + file;
        }
       
       // fuer das Extrafenster
       lastObject.file = file;       
       lastObject.classEntity = classEntity;
       lastObject.entity = entity;
       displayCodeChild();

       codeHelperFunction.displayCode(file, classEntity, entity, publishOnEntitySelected);                
    }     

    function publishOnEntitySelected(entityId){
        const applicationEvent = {
            sender: sourceCodeController,
            entities: [model.getEntityById(entityId)]
        };
        
        events.selected.on.publish(applicationEvent);	
    } 



    return {
        initialize          : initialize,
        activate            : activate,
        reset               : reset,
        openWindow          : openWindow,
    };
})();
