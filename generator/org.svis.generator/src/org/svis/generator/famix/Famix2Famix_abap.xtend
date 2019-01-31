package org.svis.generator.famix

import java.util.List
import org.svis.xtext.famix.FAMIXNamespace
import java.util.Set
import org.svis.xtext.famix.FAMIXClass
import org.svis.xtext.famix.FAMIXMethod
import org.svis.xtext.famix.FAMIXInheritance
import org.svis.xtext.famix.FAMIXAttribute
import org.svis.xtext.famix.FAMIXStructure
import org.svis.xtext.famix.Root
import java.util.Collections
import static org.apache.commons.codec.digest.DigestUtils.sha1Hex
import org.svis.xtext.famix.impl.FamixFactoryImpl
import org.svis.xtext.famix.IntegerReference
import org.svis.xtext.famix.FAMIXElement
import org.apache.commons.logging.LogFactory
import org.svis.generator.SettingsConfiguration
import org.svis.generator.SettingsConfiguration.AbapNotInOriginFilter
import org.svis.xtext.famix.FAMIXReference

//ABAP
import org.svis.xtext.famix.FAMIXABAPElements
import org.svis.xtext.famix.FAMIXReport 
import org.svis.xtext.famix.FAMIXFormroutine
import org.svis.xtext.famix.FAMIXFunctionGroup
import org.svis.xtext.famix.FAMIXFunctionModule
import org.svis.xtext.famix.FAMIXMacro
import org.svis.xtext.famix.FAMIXDictionaryData
import org.svis.xtext.famix.FAMIXDataElement
import org.svis.xtext.famix.FAMIXDomain
import org.svis.xtext.famix.FAMIXTable
import org.svis.xtext.famix.FAMIXTableElement
import org.svis.xtext.famix.FAMIXABAPStruc
import org.svis.xtext.famix.FAMIXStrucElement
import org.svis.xtext.famix.FAMIXTableType
import org.svis.xtext.famix.FAMIXTableTypeElement
import org.svis.xtext.famix.FAMIXTypeOf
import org.svis.xtext.famix.FAMIXMessageClass

class Famix2Famix_abap {
	val config = SettingsConfiguration.instance;
	val log = LogFactory::getLog(class)
	val static famixFactory = new FamixFactoryImpl()
	val Set<FAMIXNamespace> rootPackages = newLinkedHashSet
	val Set<FAMIXNamespace> subPackages = newLinkedHashSet
	val List<FAMIXStructure> allStructures = newArrayList
	val List<FAMIXMethod> methods = newArrayList
	val List<FAMIXAttribute> attributes = newArrayList
	val List<FAMIXStructure> structures = newArrayList
	val List<FAMIXReference> references = newArrayList
	val List<FAMIXInheritance> inheritances = newArrayList
	val List<FAMIXReport> reports = newArrayList 
	val List<FAMIXDataElement> dataElements = newArrayList
	val List<FAMIXDomain> domains = newArrayList
	val List<FAMIXTable> tables = newArrayList 
	val List<FAMIXABAPStruc> abapStrucs = newArrayList 
	val List<FAMIXStrucElement> abapStrucElem = newArrayList 
	val List<FAMIXFunctionModule> functionModules = newArrayList
	val List<FAMIXFormroutine> formroutines = newArrayList
	val List<FAMIXMacro> macros = newArrayList
	val List<FAMIXMessageClass> messageClasses = newArrayList
	val List<FAMIXFunctionGroup> functionGroups = newArrayList
	val List<FAMIXTableType> tableTypes = newArrayList
	val List<FAMIXTableTypeElement> ttypeElements = newArrayList
	val List<FAMIXTableElement> tableElements = newArrayList
	val List<FAMIXTypeOf> typeOf = newArrayList
			
	
	def run(Root famixRoot) {
		val config = SettingsConfiguration.instance;
		
		val famixDocument = famixRoot.document
		famixDocument.elements.removeAll(Collections::singleton(null))
		
		//Check filter. If filtered, select only origin packages.
		famixDocument.elements.forEach[element|
			if (config.abapNotInOrigin_filter == AbapNotInOriginFilter::FILTERED) {
				if (element instanceof FAMIXABAPElements) {
					if (element.iteration == 0) {
						addElementToList(element)
					}
				}
			} else {
				addElementToList(element)
			}			
		]
		
		val allPackages = famixDocument.elements.filter(FAMIXNamespace).toSet
		allStructures += famixDocument.elements.filter(FAMIXStructure).filter[container !== null]
		
		
		allPackages.forEach[getPackages]
		rootPackages.forEach[setQualifiedName]
		methods.forEach[setQualifiedName]
		messageClasses.forEach[setQualifiedName]
		reports.forEach[updParameters]
		formroutines.forEach[updParameters]
		functionGroups.forEach[setQualifiedName]
		functionModules.forEach[updParameters]
		macros.forEach[updParameters]
		tables.forEach[updParameters]
		tableElements.forEach[updParameters]
		abapStrucs.forEach[updParameters]
		abapStrucElem.forEach[updParameters]
		tableTypes.forEach[ tty | 
			updParameters(tty)
			createTableTypeElements(tty)
		]
		dataElements.forEach[updParameters]				
		domains.forEach[updParameters]				
		attributes.forEach[setQualifiedName]
		
		famixDocument.elements.clear
		famixDocument.elements.addAll(rootPackages)
		famixDocument.elements.addAll(subPackages)
		famixDocument.elements.addAll(structures)
		famixDocument.elements.addAll(references)
		famixDocument.elements.addAll(inheritances)
				
		famixDocument.elements.addAll(methods)
		famixDocument.elements.addAll(reports)
		famixDocument.elements.addAll(attributes)
		famixDocument.elements.addAll(dataElements)
		famixDocument.elements.addAll(domains)
		famixDocument.elements.addAll(tables)
		famixDocument.elements.addAll(abapStrucs)
		famixDocument.elements.addAll(abapStrucElem)
		famixDocument.elements.addAll(tableTypes)
		famixDocument.elements.addAll(functionModules)
		famixDocument.elements.addAll(functionGroups)
		famixDocument.elements.addAll(formroutines)
		famixDocument.elements.addAll(macros)
		famixDocument.elements.addAll(messageClasses)
		famixDocument.elements.addAll(tableElements)
		famixDocument.elements.addAll(ttypeElements)
		famixDocument.elements.addAll(typeOf)
		
		rootPackages.clear
		subPackages.clear
		allStructures.clear
		references.clear
		inheritances.clear
		methods.clear
		reports.clear
		dataElements.clear
		domains.clear
		tables.clear
		abapStrucs.clear
		abapStrucElem.clear
		tableTypes.clear
		attributes.clear
		structures.clear
		functionModules.clear
		functionGroups.clear
		formroutines.clear
		macros.clear
		messageClasses.clear
		tableElements.clear
		ttypeElements.clear
		typeOf.clear			
		
		return famixRoot
	}
	
	//Add elements to the corresponding list 
	def private addElementToList(FAMIXElement element) {
		switch element {
			FAMIXAttribute: attributes.add(element)					
			FAMIXMethod: methods.add(element)
			FAMIXReport: reports.add(element)
			FAMIXDataElement: dataElements.add(element)
			FAMIXDomain: domains.add(element)
			FAMIXTable: tables.add(element)
			FAMIXABAPStruc: abapStrucs.add(element)
			FAMIXStrucElement: abapStrucElem.add(element)
			FAMIXTableType: tableTypes.add(element)
			FAMIXFunctionModule: functionModules.add(element)
			FAMIXFormroutine: formroutines.add(element)
			FAMIXMacro: macros.add(element)
			FAMIXMessageClass: messageClasses.add(element)
			FAMIXFunctionGroup: functionGroups.add(element)
			FAMIXTableElement: tableElements.add(element)
			FAMIXTypeOf: typeOf.add(element)
			FAMIXReference: references.add(element)
			FAMIXInheritance: inheritances.add(element)
			FAMIXStructure: {
				if(element.container !== null){
					structures.add(element)
				}
			}
		}
	}
	
	def private void getPackages(FAMIXNamespace namespace) {
		if ((config.abapNotInOrigin_filter == AbapNotInOriginFilter::FILTERED && namespace.iteration == 0) || 
			(config.abapNotInOrigin_filter !== AbapNotInOriginFilter::FILTERED)) {
			if (namespace.parentScope === null) {
				rootPackages += namespace
			} else {
				subPackages += namespace
				getPackages(namespace.parentScope.ref as FAMIXNamespace)
			}
		}
	}
	
	def void setQualifiedName(FAMIXNamespace el) {
		if (el.parentScope === null) {
			el.fqn = el.value
		} else {
			el.fqn = (el.parentScope.ref as FAMIXNamespace).fqn + "." + el.value
		}

		el.id = createID(el.fqn)

		allStructures.filter[container.ref.equals(el)].forEach[setQualifiedName]
		subPackages.filter[parentScope.ref.equals(el)].forEach[setQualifiedName]
	}
	
	def void setQualifiedName(FAMIXMethod method) {
		val ref = method.parentType.ref
		var result = ""
		switch ref {
			FAMIXClass: result += ref.fqn + "." + method.value
			default: log.error("ERROR qualifiedName(FAMIXMethod famixMethod): " + method.value)
		}
		method.fqn = result
		method.id = createID(method.name) //name is ID from Famix file
		if(method.numberOfStatements >= 2){
			var nos = method.numberOfStatements - 2
			method.numberOfStatements = nos
		}
	}
	
	def void setQualifiedName(FAMIXStructure el) {
		val ref = el.container.ref
		var name = ""
		switch ref {
			FAMIXNamespace: name = ref.fqn
			FAMIXStructure: name = ref.fqn
			FAMIXReport: name = ref.fqn
			FAMIXMethod: name = ref.fqn
			default: log.error("ERROR qualifiedName(FAMIXStructure): " + el.value)
		}
		el.fqn = name + "." + el.value
		el.id = createID(el.name) //name is ID from Famix file

		allStructures.filter[container.ref.equals(el)].forEach[setQualifiedName]
	}
	
	def updParameters(FAMIXReport re){
		val ref = re.container.ref
		if (ref instanceof FAMIXNamespace) {
			re.fqn = ref.fqn + "." + re.value
		}
		re.id = createID(re.name) //name is ID from Famix file
	}
	
	def updParameters(FAMIXFormroutine fr){
		var ref = fr.parentType.ref
		switch ref {
			FAMIXReport: fr.fqn = ref.fqn + "." + fr.value
			FAMIXFunctionGroup: fr.fqn = ref.fqn + "." + fr.value
			default: log.error("ERROR qualifiedName(FAMIXFormroutine): " + fr.value)
		}	
		fr.id = createID(fr.name) //name is ID from Famix file
		if (fr.numberOfStatements >= 2) {
			var nos = fr.numberOfStatements - 2
			fr.numberOfStatements = nos
		}		
	}
	
	def updParameters(FAMIXFunctionModule fm){
		val ref = fm.parentType.ref
		switch ref {
			FAMIXFunctionGroup: fm.fqn = ref.fqn + "." + fm.value
			default: log.error("ERROR qualifiedName(FAMIXFunctionModule): " + fm.value)
		}	
		fm.id = createID(fm.name) //name is ID from Famix file
		if (fm.numberOfStatements >= 2) {
			var nos = fm.numberOfStatements - 2
			fm.numberOfStatements = nos
		}
	}
	
	def updParameters(FAMIXMacro ma){
		var ref = ma.parentType.ref
		switch ref {
			FAMIXReport: ma.fqn = ref.fqn + "." + ma.value
			FAMIXFormroutine: ma.fqn = ref.fqn + "." + ma.value
			FAMIXFunctionGroup: ma.fqn = ref.fqn + "." + ma.value
			FAMIXFunctionModule: ma.fqn = ref.fqn + "." + ma.value
			FAMIXStructure: ma.fqn = ref.fqn + "." + ma.value
			FAMIXMethod: ma.fqn = ref.fqn + "." + ma.value
			FAMIXNamespace: ma.fqn = ref.fqn + "." + ma.value
			default: log.error("ERROR qualifiedName(FAMIXMacro): " + ma.value) 
		}
		ma.id = createID(ma.name) //name is ID from Famix file
	}
	
	def updParameters(FAMIXDictionaryData dd){
		val ref = dd.container.ref
		switch ref {
			FAMIXDictionaryData: dd.fqn = ref.fqn + "." + dd.value
			FAMIXNamespace: dd.fqn = ref.fqn + "." + dd.value
			default: log.error("ERROR qualifiedName(FAMIXDictionaryData): " + dd.value)
		}
		dd.id = createID(dd.name) //name is ID from Famix file
	}
	
	def setQualifiedName(FAMIXAttribute attribute) {
		val ref = attribute.parentType.ref
		switch (ref) {
			FAMIXClass: attribute.fqn = ref.fqn + "." + attribute.value
			FAMIXReport: attribute.fqn = ref.fqn + "." + attribute.value
			FAMIXFormroutine: attribute.fqn = ref.fqn + "." + attribute.value
			FAMIXFunctionGroup: attribute.fqn = ref.fqn + "." + attribute.value
			FAMIXFunctionModule: attribute.fqn = ref.fqn + "." + attribute.value
			FAMIXMethod: attribute.fqn = ref.fqn + "." + attribute.value
			default: log.error("ERROR qualifiedName(FAMIXAttribute famixAttribute): " + attribute.value)
		}
		attribute.id = createID(attribute.name) //name is ID from Famix file
	}
	
	def createTableTypeElements(FAMIXTableType tt){
		val tableTypeOf = typeOf.filter[element.ref == tt]
				
		// find "parent" elements and add them to the TableTypeElem Array
		for(tty : tableTypeOf){
			if (tty.typeOf.ref instanceof FAMIXABAPStruc) {
				abapStrucElem.filter[container.ref == tty.typeOf.ref].forEach[ 
					createTableTypeElement(tty.element)
				]
			} else if (tty.typeOf.ref instanceof FAMIXTable) {
				tableElements.filter[container.ref == tty.typeOf.ref].forEach[ 
					createTableTypeElement(tty.element)
				]
			}
		}
	}
	
	def createTableTypeElement(FAMIXDictionaryData dd, IntegerReference element){
		var ttyElement  = famixFactory.createFAMIXTableTypeElement		
		if (dd instanceof FAMIXStrucElement || dd instanceof FAMIXTableElement){
			ttyElement.id = createID(dd.id + "TableTypeElement")
			ttyElement.name = dd.name
			ttyElement.value = dd.value
			ttyElement.fqn = dd.fqn
			ttyElement.container = famixFactory.createIntegerReference
			ttyElement.container.ref = dd.container.ref
			ttyElement.tableType = famixFactory.createIntegerReference
			ttyElement.tableType.ref = element.ref
			ttypeElements += ttyElement
		}
	}
	
	def createID(String fqn) {
		return "ID_" + sha1Hex(fqn + config.repositoryName + config.repositoryOwner)
	}
}