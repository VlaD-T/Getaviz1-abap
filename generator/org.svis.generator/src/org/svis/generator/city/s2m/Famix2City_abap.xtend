package org.svis.generator.city.s2m

import java.util.List
import java.util.ArrayList
import java.util.Set
import java.util.HashMap
import org.eclipse.emf.mwe.core.WorkflowContext
import org.eclipse.emf.mwe.core.issues.Issues
import org.eclipse.emf.mwe.core.monitor.ProgressMonitor
import org.svis.generator.FamixUtils
import org.svis.generator.city.CityUtils
import org.svis.xtext.city.Building
import org.svis.xtext.city.BuildingSegment
import org.svis.xtext.city.District
import org.svis.xtext.city.Root
import org.svis.xtext.city.impl.CityFactoryImpl
import org.svis.xtext.famix.Document
import org.svis.xtext.famix.FAMIXAttribute
import org.svis.xtext.famix.FAMIXEnum
import org.svis.xtext.famix.FAMIXEnumValue
import org.svis.xtext.famix.FAMIXFileAnchor
import org.svis.xtext.famix.FAMIXInheritance
import org.svis.xtext.famix.FAMIXLocalVariable
import org.svis.xtext.famix.FAMIXClass
import org.svis.xtext.famix.FAMIXMethod
import org.svis.xtext.famix.FAMIXNamespace
import org.svis.xtext.famix.FAMIXParameter
import org.svis.xtext.famix.FAMIXParameterizedType
import org.svis.xtext.famix.FAMIXPrimitiveType
import org.svis.xtext.famix.FAMIXReference
import org.svis.xtext.famix.FAMIXStructure
import org.svis.xtext.famix.IntegerReference
import org.svis.xtext.famix.impl.FamixFactoryImpl
import org.svis.generator.SettingsConfiguration
import org.eclipse.emf.mwe.core.lib.WorkflowComponentWithModelSlot
import org.apache.commons.logging.LogFactory
import org.svis.generator.SettingsConfiguration.BuildingType
import org.svis.generator.SettingsConfiguration.ClassElementsModes
import org.svis.generator.SettingsConfiguration.Original.BuildingMetric
import org.svis.generator.SettingsConfiguration.AbapCityRepresentation
import org.svis.generator.SettingsConfiguration.DataElementSorting
import static org.apache.commons.codec.digest.DigestUtils.sha1Hex

// ABAP
import org.svis.xtext.famix.FAMIXReport 
import org.svis.xtext.famix.FAMIXDictionaryData
import org.svis.xtext.famix.FAMIXDataElement
import org.svis.xtext.famix.FAMIXDomain
import org.svis.xtext.famix.FAMIXTable
import org.svis.xtext.famix.FAMIXABAPStruc
import org.svis.xtext.famix.FAMIXStrucElement
import org.svis.xtext.famix.FAMIXFunctionGroup
import org.svis.xtext.famix.FAMIXFunctionModule
import org.svis.xtext.famix.FAMIXFormroutine
import org.svis.xtext.famix.FAMIXMessageClass 
import org.svis.xtext.famix.FAMIXTableType 
import org.svis.xtext.famix.FAMIXTableTypeElement 
import org.svis.xtext.famix.FAMIXTypeOf
import org.svis.xtext.famix.FAMIXTableElement

class Famix2City_abap {
	
  val String[] typeNames = #["CHAR","INT4","NUMC","ACCP","CLNT","CUKY","CURR","DF16_DEC","DF16_RAW","DF34_DEC","DF34_RAW",
	                          "DATS","DEC","FLTP","INT1","INT2","INT8","LANG","LCHR","LRAW","QUAN","RAW","RAWSTRING", "SSTRING",
	                          "STRING","TIMS","UNIT"]
	                           
	//Import: cityDocument, to store all elements from famixDocument
	
	new(org.svis.xtext.city.Document imp_cityDocument, Document imp_famixDocument){
		cityDocument  = imp_cityDocument
		famixDocument = imp_famixDocument		
		
		if (config.clusterSubPackages) {
			rootPackages 		+= famixDocument.elements.filter(FAMIXNamespace).filter[parentScope === null]
			subPackages 		+= famixDocument.elements.filter(FAMIXNamespace).filter[parentScope !== null]			
		} else {
			rootPackages 		+= famixDocument.elements.filter(FAMIXNamespace)
		}
		
		structures 			+= famixDocument.elements.filter(FAMIXStructure)
 		classes 			+= famixDocument.elements.filter(FAMIXClass)
		methods 			+= famixDocument.elements.filter(FAMIXMethod)
		localVariables 		+= famixDocument.elements.filter(FAMIXLocalVariable)
		attributes 			+= famixDocument.elements.filter(FAMIXAttribute)
		enums 			    += famixDocument.elements.filter(FAMIXEnum)
		enumValues			+= famixDocument.elements.filter(FAMIXEnumValue)
		primitiveTypes 		+= famixDocument.elements.filter(FAMIXPrimitiveType)
		parameterizedTypes  += famixDocument.elements.filter(FAMIXParameterizedType)
		inheritances 		+= famixDocument.elements.filter(FAMIXInheritance)
		references 			+= famixDocument.elements.filter(FAMIXReference)
		parameters 			+= famixDocument.elements.filter(FAMIXParameter)
		
		//ABAP
		reports 	 	 += famixDocument.elements.filter(FAMIXReport)
		formroutines	 += famixDocument.elements.filter(FAMIXFormroutine)
		dataElements	 += famixDocument.elements.filter(FAMIXDataElement)
	    virtualDomains   += famixDocument.elements.filter(FAMIXDataElement) 
		domains			 += famixDocument.elements.filter(FAMIXDomain)
		tables			 += famixDocument.elements.filter(FAMIXTable)
		abapStrucs		 += famixDocument.elements.filter(FAMIXABAPStruc)
		abapStrucElem    += famixDocument.elements.filter(FAMIXStrucElement)
		functionGroups   += famixDocument.elements.filter(FAMIXFunctionGroup)
		functionModules  += famixDocument.elements.filter(FAMIXFunctionModule)
		messageClasses   += famixDocument.elements.filter(FAMIXMessageClass)
		tableTypes		 += famixDocument.elements.filter(FAMIXTableType)
		ttyElements	 	 += famixDocument.elements.filter(FAMIXTableTypeElement)
		typeOfs			 += famixDocument.elements.filter(FAMIXTypeOf)
		tableElements	 += famixDocument.elements.filter(FAMIXTableElement)
	
		
		if (config.abap_representation == AbapCityRepresentation::SIMPLE) {
			dcData += dataElements + domains + abapStrucs + tableTypes
			
			if (!config.showOwnTablesDistrict) {
				dcData += tables
			}
		} else {
			dcData += abapStrucs + tableTypes
		}

	}
		
	val config = SettingsConfiguration.instance
	val log = LogFactory::getLog(class)
	val cityFactory = new CityFactoryImpl
	val famixFactory = new FamixFactoryImpl()
	var Document famixDocument
	var org.svis.xtext.city.Document cityDocument
	
	extension FamixUtils util = new FamixUtils

	val Set<FAMIXNamespace> rootPackages = newLinkedHashSet
	val Set<FAMIXNamespace> subPackages = newLinkedHashSet
	val List<FAMIXStructure> structures = newArrayList
	val List<FAMIXClass> classes = newArrayList
	val List<FAMIXMethod> methods = newArrayList
	val List<FAMIXLocalVariable> localVariables = newArrayList
	val List<FAMIXAttribute> attributes = newArrayList
	val List<FAMIXEnum> enums = newArrayList
	val List<FAMIXEnumValue> enumValues = newArrayList
	val List<FAMIXPrimitiveType> primitiveTypes = newArrayList
	val List<FAMIXParameterizedType> parameterizedTypes = newArrayList
	var List<FAMIXInheritance> inheritances = newArrayList
	var List<FAMIXReference> references = newArrayList
	val List<FAMIXParameter> parameters = newArrayList
	
	var org.svis.xtext.city.District originDistrict = cityFactory.createDistrict
	
	//ABAP
	val List<FAMIXReport> reports = newArrayList 
	val List<FAMIXDictionaryData> dcData = newArrayList
	val List<FAMIXDataElement> dataElements = newArrayList 
    val List<FAMIXDataElement> virtualDomains = newArrayList
	val List<FAMIXDomain> domains = newArrayList
	val List<FAMIXTable> tables = newArrayList 
	val List<FAMIXABAPStruc> abapStrucs = newArrayList 
	val List<FAMIXStrucElement> abapStrucElem = newArrayList 
	val List<FAMIXFunctionModule> functionModules = newArrayList
	val List<FAMIXFormroutine> formroutines = newArrayList
	val List<FAMIXMessageClass> messageClasses = newArrayList
	val List<FAMIXFunctionGroup> functionGroups = newArrayList
	val List<FAMIXTableType> tableTypes = newArrayList 
	val List<FAMIXTypeOf> typeOfs = newArrayList
	val List<FAMIXTableElement> tableElements = newArrayList
	val List<FAMIXTableTypeElement> ttyElements = newArrayList
	
	
	def abapToModel() {		
		// Run transformation 
		if (config.abap_representation == AbapCityRepresentation::SIMPLE) {
			simpleModel()
		} else if (config.abap_representation == AbapCityRepresentation::ADVANCED) {
			advancedModel()
		}		
		
		return cityDocument
	}
	
	
	def void logElement(Object el){
		log.info(el)
	}
	
	
	/**
	 * Transform famix to City, SIMPLE representation
	 * 1. Groups objects by type and art
	 * 2. Creates district for groups
	 * 3. Uses simple forms (city2X3D)
	 */
	def simpleModel(){
		rootPackages.forEach[toDistrict(1)]
	}
	
	
	/**
	 * Transform famix to City, ADVANCED representation
	 * 1. Builds city using dependencies
	 * 2. Uses more complex buildings (city2X3D)
	 */
	def advancedModel(){
		rootPackages.forEach[
			toAdvancedDistrict(1)
		]
	}
	
	
	// Mode: simple
	def private District toDistrict(FAMIXNamespace elem, int level) {	
		
		// Create main district		
		val newDistrict = cityFactory.createDistrict
		newDistrict.name = elem.name
		newDistrict.value = elem.value
		newDistrict.fqn = elem.fqn
		newDistrict.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newDistrict.level = level
		newDistrict.isStandard = elem.isStandard
		newDistrict.id = elem.id
		if(elem.iteration >= 1){
			newDistrict.notInOrigin = "true"
		}	

		//Sub packages
		subPackages.filter[parentScope.ref === elem].forEach[newDistrict.entities += toDistrict(level + 1)]
		
		//Data Dictionary
		if (dcData.filter[container.ref == elem].length != 0){
			val dcDataDistrict = cityFactory.createDistrict
			dcDataDistrict.name = newDistrict.name + "_dcDataDistrict"
			dcDataDistrict.type = "dcDataDistrict"
			dcDataDistrict.id = elem.id + "_00002"
			dcDataDistrict.level = level + 1
			if(elem.iteration >= 1){
				dcDataDistrict.notInOrigin = "true"
			}
			
			dcData.filter[container.ref == elem].forEach[dcDataDistrict.entities += toBuilding(level + 2)]
			newDistrict.entities.add(dcDataDistrict)
		}
		
		//Reports (+forms)
		if (reports.filter[container.ref == elem].length != 0){
			val reportDistrict = cityFactory.createDistrict
			reportDistrict.name = newDistrict.name + "_reportDistrict"
			reportDistrict.type = "reportDistrict"
			reportDistrict.id = elem.id + "_00003"
			reportDistrict.level = level + 1
			if(elem.iteration >= 1){
				reportDistrict.notInOrigin = "true"
			}
			
			reports.filter[container.ref == elem].forEach[reportDistrict.entities += toBuilding(level + 2)]
			newDistrict.entities.add(reportDistrict)
		}
		
		//Classes (+included methods and attributes)
		if (classes.filter[container.ref == elem].length != 0){
			val classDistrict = cityFactory.createDistrict
			classDistrict.name = newDistrict.name + "_classDistrict"
			classDistrict.type = "classDistrict"
			classDistrict.level = level + 1
			classDistrict.id = elem.id + "_00004"
			if(elem.iteration >= 1){
				classDistrict.notInOrigin = "true"
			}
			
			classes.filter[container.ref === elem].forEach[classDistrict.entities += toBuilding(level + 2)]
			newDistrict.entities.add(classDistrict)
		}
		
		//Function Group (+function Modules)
		if (functionGroups.filter[container.ref == elem].length != 0){
			val functionGroupDistrict = cityFactory.createDistrict
			functionGroupDistrict.name = newDistrict.name + "_functionGroupDistrict"
			functionGroupDistrict.type = "functionGroupDistrict"
			functionGroupDistrict.level = level + 1
			functionGroupDistrict.id = elem.id + "_00005"
			if(elem.iteration >= 1){
				functionGroupDistrict.notInOrigin = "true"
			}
			
			functionGroups.filter[container.ref === elem].forEach[functionGroupDistrict.entities += toBuilding(level + 2)]
			newDistrict.entities.add(functionGroupDistrict)
		}
		
		//DB Tables - only if we need own district
		if(config.showOwnTablesDistrict){
			if (tables.filter[container.ref == elem].length != 0){
				val tableDistrict = cityFactory.createDistrict
				tableDistrict.name = newDistrict.name + "_tableDistrict"
				tableDistrict.type = "tableDistrict"
				tableDistrict.level = level + 1
				tableDistrict.id = elem.id + "_00006"
				if(elem.iteration >= 1){
					tableDistrict.notInOrigin = "true"
				}
				
				tables.filter[container.ref == elem].forEach[tableDistrict.entities += toBuilding(level + 2)]
				newDistrict.entities.add(tableDistrict)
			}
		}							
								
		
		cityDocument.entities += newDistrict
		return newDistrict
	}
	
	
	// Mode: advanced
	def private District toAdvancedDistrict(FAMIXNamespace elem, int level){
		val newDistrict = cityFactory.createDistrict
		newDistrict.name = elem.name
		newDistrict.value = elem.value 
		newDistrict.fqn = elem.fqn
		newDistrict.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newDistrict.level = level
		newDistrict.isStandard = elem.isStandard
		newDistrict.id = elem.id
		
		if(elem.iteration >= 1){
			newDistrict.notInOrigin = "true"
		}
        
        //sub packages
		subPackages.filter[parentScope.ref === elem].forEach[newDistrict.entities += toAdvancedDistrict(level + 1)]
        
        // domains with dtel where applicable
       	if (config.showDomainDistrict) {
			domains.filter[container.ref == elem].forEach [ doma |
				val newDomainDistrict = cityFactory.createDistrict
				newDomainDistrict.name = newDistrict.name + "_domainDistrict"
				newDomainDistrict.type = "domainDistrict"
//		  		newDomainDistrict.id = createID("DomainDistrict" + doma.id) + "_000031"
				newDomainDistrict.id = doma.id + "_000031"
				newDomainDistrict.level = level + 1
				
				if (config.showDomain) {
					newDomainDistrict.entities += toBuilding(doma, level + 2)
				}
				
				if (config.showDtel) {
					dataElements.filter[container.ref == elem].filter[domain == doma.value].forEach [
							newDomainDistrict.entities += toBuilding(level + 2)
					]
				}
				
				newDistrict.entities.add(newDomainDistrict)
			]
		}
		
		// for DataElements with Domains in other packages
		if (config.showDomainDistrictOnlyWithDtel) {
			val domainDtelMap = new HashMap<String, ArrayList<FAMIXDataElement>>()
			
			dataElements.filter[container.ref == elem].filter[domain !== null].forEach [ dtel |
				if (domains.filter[container.ref == elem].filter[it.value == dtel.domain].length == 0) {
					if (domainDtelMap.containsKey(dtel.domain)) {
						domainDtelMap.get(dtel.domain).add(dtel)
					} else {
						val newDataElements = new ArrayList<FAMIXDataElement>
						newDataElements.add(dtel)
						domainDtelMap.put(dtel.domain, newDataElements)
					}
				}
			]
			
			domainDtelMap.forEach [domain, dtelList |
				val newDomainDistrict = cityFactory.createDistrict
				newDomainDistrict.name = newDistrict.name + "_domainDistrict"
				newDomainDistrict.type = "domainDistrict"
//				newDomainDistrict.id = createID("DomainDistrict" + dtel.id)
				newDomainDistrict.id = dtelList.get(0).id + "_000071"
				newDomainDistrict.level = level + 1
				
				dtelList.forEach [
					newDomainDistrict.entities += toBuilding(level + 2)
				]
				
				newDistrict.entities.add(newDomainDistrict)			 
			]
		}
		 
		if (config.showVirtualDomainDistrict) {
			typeNames.forEach [ typeName |
					if (dataElements.filter[container.ref == elem].filter[domain === null].filter[datatype == typeName].length != 0) {
						val newVirtualDomainDistrict = cityFactory.createDistrict
						newVirtualDomainDistrict.name = newDistrict.name + "_virtualDomainDistrict"
						newVirtualDomainDistrict.type = "virtualDomainDistrict"
//			 			newVirtualDomainDistrict.id = createID(typeName + elem.id) + "_000051"
						newVirtualDomainDistrict.id = elem.id + "_000051"
						newVirtualDomainDistrict.level = level + 1
						
						if (config.showDtel) {
							dataElements.filter[container.ref == elem].filter[domain === null].filter[datatype == typeName].
								forEach [
									newVirtualDomainDistrict.entities += toBuilding(level + 2)
									// workaround
									newVirtualDomainDistrict.id = it.id + "_000051"
								]
						}
						
						if (config.showVirtualDomain) {
							val domainBuilding = cityFactory.createBuilding
							domainBuilding.name = elem.name
							domainBuilding.type = "FAMIX.VirtualDomain"
							domainBuilding.level = level + 2
						 // domainBuilding.id = createID(typeName + elem.id) + "_000061"
							domainBuilding.id = newVirtualDomainDistrict.id + "1"
							newVirtualDomainDistrict.entities += domainBuilding
						}

						newDistrict.entities.add(newVirtualDomainDistrict)
					}
			]
		}
        
        if (config.showStructureDistrict) {
			abapStrucs.filter[container.ref == elem].forEach [ struc |
				val newStructureDistrict = cityFactory.createDistrict
				newStructureDistrict.name = newDistrict.name + "_structureDistrict"
				newStructureDistrict.type = "structureDistrict"
				newStructureDistrict.id = struc.id
				newStructureDistrict.level + 1
				if (elem.iteration >= 1) {
					newStructureDistrict.notInOrigin = "true"
				}

				if (config.showStructure) {
					abapStrucElem.filter[container.ref == struc].forEach [
						newStructureDistrict.entities += toBuilding(level + 2)
					]
				}

				if (config.showTableTypeStructure) {
					tableTypes.filter[container.ref == elem].filter[rowType == struc.value].forEach [
						newStructureDistrict.entities += toBuilding(level + 2, false)
					]
				}

				newDistrict.entities.add(newStructureDistrict)
			]
		} 
            
		//schlecht implementiert
//		if (config.showStructureDistrictWithNotOriginalElements) {
//			abapStrucs.filter[iteration != 0].forEach [ struc |
//				val newStructureDistrict = cityFactory.createDistrict
//				newStructureDistrict.name = newDistrict.name + "_structureDistrict"
//				newStructureDistrict.type = "structureDistrict"
//				newStructureDistrict.color = CityUtils.getRGBFromHEX("#b2de92")
//				newStructureDistrict.id = struc.id + "_000021"
//				newStructureDistrict.level = level + 1
//				
//				tableTypes.filter[container.ref == elem].filter[iteration == 0].filter[rowType == struc.value].forEach [
//					newStructureDistrict.entities += toBuilding(level + 2, false)
//				]
//
//				if (newStructureDistrict.entities.size == 0) {
//					return
//				}
//
//				newDistrict.entities.add(newStructureDistrict)
//			]
//			
////			tableTypes.filter[container.ref == elem]
//		} 
		
		// for TableTypes with structures/tables in other packages
		if (config.showStrucTablDistrictOnlyWithTtyp) {			
			val ttypStrucMap = new HashMap<String, ArrayList<FAMIXTableType>>()
			val ttypTableMap = new HashMap<String, ArrayList<FAMIXTableType>>()
			
			tableTypes.filter[container.ref == elem].forEach [ ttyp |	
				if (abapStrucs.filter[container.ref != elem].filter[value == ttyp.rowType].length == 1) {
					if (ttypStrucMap.containsKey(ttyp.rowType)) {
						ttypStrucMap.get(ttyp.rowType).add(ttyp)
					} else {
						val newTtypes = new ArrayList<FAMIXTableType>
						newTtypes.add(ttyp)
						ttypStrucMap.put(ttyp.rowType, newTtypes)
					}
				} else if (tables.filter[container.ref != elem].filter[value == ttyp.rowType].length == 1) {
					if (ttypTableMap.containsKey(ttyp.rowType)) {
						ttypTableMap.get(ttyp.rowType).add(ttyp)
					} else {
						val newTtypes = new ArrayList<FAMIXTableType>
						newTtypes.add(ttyp)
						ttypTableMap.put(ttyp.rowType, newTtypes)
					}
				}
			]
	
			ttypStrucMap.putAll(ttypTableMap)
			ttypStrucMap.forEach [ strucOrTable, ttypList |
				val newTtypDistrict = cityFactory.createDistrict
				newTtypDistrict.name = newDistrict.name + "_tableTypeDistrict"
				
				if (ttypTableMap.containsValue(ttypList.get(0)))
					newTtypDistrict.type = "tableDistrict"
				else
					newTtypDistrict.type = "structureDistrict"

//				newTtypDistrict.id = createID("TableTypeDistrict" + ttyp.id)
				newTtypDistrict.id = ttypList.get(0).id + "_000081" 
				newTtypDistrict.level = level + 1
				
				if ((newTtypDistrict.type == "tableDistrict" && config.showTableTypeTable) ||
					(newTtypDistrict.type == "structureDistrict" && config.showTableTypeStructure)) {
					ttypList.forEach [
						newTtypDistrict.entities += toBuilding(level + 2)					
					]
				}				
				
				newDistrict.entities.add(newTtypDistrict)
			]
		}
		  
	    // table District	   	
	    if (config.showTableDistrict) {
			tables.filter[container.ref == elem].forEach [ table |
				val newTableDistrict = cityFactory.createDistrict
				newTableDistrict.name = newDistrict.name + "_tableDistrict"
				newTableDistrict.type = "tableDistrict"
				newTableDistrict.level = level // + 1
//				newTableDistrict.id = createID("TableDistrict" + table.id)
				newTableDistrict.id = table.id + "_00007"
				if (elem.iteration >= 1) {
//					newTableDistrict.notInOrigin = "true"
				}

				if (config.showTables) {
					newTableDistrict.entities += toAdvBuilding(table, level, true)
				}

				if (config.showTableTypeTable) {
					tableTypes.filter[container.ref == elem].filter[rowType == table.value].forEach [
						newTableDistrict.entities += toBuilding(level + 2, true)
					]
				}

				newDistrict.entities.add(newTableDistrict)
			]
		}
	      
//	    // rudimentär
//	    if (config.showTableDistrictWithNotOriginalElements) {
//			tables.filter[iteration == 1].forEach [ table |
//				val newTableDistrict = cityFactory.createDistrict
//				newTableDistrict.name = newDistrict.name + "_tableDistrict"
//				newTableDistrict.type = "tableDistrict"
//				newTableDistrict.id = createID("TableDistrictWithNotOriginalElements" + table.id + elem.id)
//				newTableDistrict.level = level + 1
//				newTableDistrict.color = CityUtils.getRGBFromHEX("#0253d8")
//				
//				tableTypes.filter[container.ref == elem].filter[iteration == 0].filter[rowType == table.value].forEach [
//					newTableDistrict.entities += toBuilding(level + 2, true)
//				]
//
//				if (newTableDistrict.entities.size == 0) {
//					return
//				}
//
//				if (elem.iteration >= 1) {
////					newTableDistrict.notInOrigin = "true"				
//				}
//
//				newDistrict.entities.add(newTableDistrict)
//
//			]
//		}	
		  
        // for classes
        if (config.showClassDistrict) {
			classes.filter[container.ref == elem].filter[isInterface == "false"].forEach [ class |
				val newClassDistrict = cityFactory.createDistrict
				newClassDistrict.name = newDistrict.name + "_classDistrict"
				newClassDistrict.type = "classDistrict"
				newClassDistrict.id = class.id
				newClassDistrict.level = level + 1

				// newClassDistrict.entities += toBuilding(class, level + 2)
				if (config.showMethod) {
					methods.filter[parentType.ref == class].forEach[newClassDistrict.entities += toBuilding(level + 2)]
				}

				if (config.showClassAttributes) {
					attributes.filter[parentType.ref == class].forEach [
						newClassDistrict.entities += toBuilding(level + 2, true)
					]
				}

				// local classes
				if (config.showLocalClassDistrict) {
					classes.filter[container.ref == class].forEach [ localClass |
						val newLocalClassDistrict = cityFactory.createDistrict
						newLocalClassDistrict.name = newDistrict.name + "_classDistrict"
						newLocalClassDistrict.type = "classDistrict"
						newLocalClassDistrict.id = localClass.id
						newLocalClassDistrict.level = level + 1

						if (config.showLocalMethod) {
							methods.filter[parentType.ref == localClass].forEach [
								newLocalClassDistrict.entities += toBuilding(level + 2)
							]
						}

						if (config.showLocalAttribute) {
							attributes.filter[parentType.ref == localClass].forEach [
								newLocalClassDistrict.entities += toBuilding(level + 2, true)
							]
						}

						newClassDistrict.entities.add(newLocalClassDistrict)
					]
				}

				newDistrict.entities.add(newClassDistrict)
			]
		}
		
		// for interfaces
		if (config.showInterfaceDistrict) {
			classes.filter[container.ref == elem].filter[isInterface == "true"].forEach [ class |
				val newInterfaceDistrict = cityFactory.createDistrict
				newInterfaceDistrict.name = newDistrict.name + "_interfaceDistrict"
				newInterfaceDistrict.type = "interfaceDistrict"
//				newInterfaceDistrict.id = createID(class.id) + "_000091"
				newInterfaceDistrict.id = class.id + "_000091"			
				newInterfaceDistrict.level = level + 1

				if (config.showInterface) {
					newInterfaceDistrict.entities += toAdvBuilding(class, level + 2, true)
				}

				newDistrict.entities.add(newInterfaceDistrict)
			]
		}
		
		if (config.showFuGrDistrict) {
			functionGroups.filter[container.ref == elem].forEach [ functionGroup |
				val newFunctionGroupDistrict = cityFactory.createDistrict
				newFunctionGroupDistrict.name = newDistrict.name + "_functionGroupDistrict"
				newFunctionGroupDistrict.type = "functionGroupDistrict"
				newFunctionGroupDistrict.id = functionGroup.id
				newFunctionGroupDistrict.level = level + 1

				if (config.showFumo) {
					functionModules.filter[parentType.ref == functionGroup].forEach [
						newFunctionGroupDistrict.entities += toBuilding(level + 2)
					]
				}
				if (config.showFormOfFugr) {
					formroutines.filter[parentType.ref == functionGroup].forEach [
						newFunctionGroupDistrict.entities += toBuilding(level + 2)
					]
				}
				if (config.showFuGrAttributes) {
					attributes.filter[parentType.ref == functionGroup].forEach [
						newFunctionGroupDistrict.entities += toFumoBuilding(level + 2)
					]
				}
				// local classes
				if (config.showLocalClassDistrict) {
					classes.filter[it.container.ref == functionGroup].forEach [ localClass |
						val newLocalClassDistrict = cityFactory.createDistrict
						newLocalClassDistrict.name = newDistrict.name + "_classDistrict"
						newLocalClassDistrict.type = "classDistrict"
						newLocalClassDistrict.id = localClass.id
						newLocalClassDistrict.level = level + 1

						if (config.showLocalMethod) {
							methods.filter[parentType.ref == localClass].forEach [
								newLocalClassDistrict.entities += toBuilding(level + 2)
							]
						}

						if (config.showLocalAttribute) {
							attributes.filter[parentType.ref == localClass].forEach [
								newLocalClassDistrict.entities += toBuilding(level + 2, true)
							]
						}

						newFunctionGroupDistrict.entities.add(newLocalClassDistrict)
					]
				}

				newDistrict.entities.add(newFunctionGroupDistrict)
			]
		}
		
		if (config.showReportDistrict) {
			reports.filter[container.ref == elem].forEach [ report |
				val newReportDistrict = cityFactory.createDistrict
				newReportDistrict.name = newDistrict.name + "_reportDistrict"
				newReportDistrict.type = "reportDistrict"
				// newReportDistrict.id = createID("ReportDistrict" + report.id) + "_00005"
				newReportDistrict.id = report.id + "_00005"
				newReportDistrict.level = level + 1

				if (config.showReport) {
					newReportDistrict.entities += toAdvBuilding(report, level + 2, true)
				}
				if (config.showForm) {
					formroutines.filter[parentType.ref == report].forEach [
						newReportDistrict.entities += toBuilding(level + 2)
					]
				}

				if (config.showReportAdvAttributes)
					attributes.filter[parentType.ref == report].forEach [
						newReportDistrict.entities += toRepoBuilding(level + 2)
					]

				// local classes
				if (config.showLocalClassDistrict) {
					classes.filter[container.ref == report].forEach [ localClass |
						val newLocalClassDistrict = cityFactory.createDistrict
						newLocalClassDistrict.name = newDistrict.name + "_classDistrict"
						newLocalClassDistrict.type = "classDistrict"
						newLocalClassDistrict.id = localClass.id
						newLocalClassDistrict.level = level + 1

						if (config.showLocalMethod) {
							methods.filter[parentType.ref == localClass].forEach [
								newLocalClassDistrict.entities += toBuilding(level + 2)
							]
						}

						if (config.showLocalAttribute) {
							attributes.filter[parentType.ref == localClass].forEach [
								newLocalClassDistrict.entities += toBuilding(level + 2, true)
							]
						}

						newReportDistrict.entities.add(newLocalClassDistrict)
					]
				}

				newDistrict.entities.add(newReportDistrict)
			]
		}  
	     
		// no empty districts
		if (newDistrict.entities.length != 0) {
			cityDocument.entities += newDistrict
		}		
		
		// why?? 
		return newDistrict
	}
	
	// End of Advanced Mode
	
	// Methods to build buildings
	
	def Building toBuilding(FAMIXReport elem, int level){
		val newBuilding = cityFactory.createBuilding
		newBuilding.name = elem.name
		newBuilding.value = elem.value
		newBuilding.fqn = elem.fqn
		newBuilding.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newBuilding.level = level
		newBuilding.id = elem.id
		newBuilding.methodCounter = formroutines.filter[parentType.ref == elem].length
		newBuilding.dataCounter = attributes.filter[parentType.ref === elem].length
		if(elem.iteration >= 1){
			newBuilding.notInOrigin = "true"
		}
		
		formroutines.filter[parentType.ref == elem].forEach[newBuilding.methods.add(toFloor)]
		
		if(config.showReportAttributes){
			newBuilding.dataCounter = attributes.filter[parentType.ref == elem].length
			attributes.filter[parentType.ref == elem].forEach[newBuilding.data.add(toChimney)]
		}
		
		return newBuilding
	}
	
	def Building toBuilding(FAMIXFunctionGroup elem, int level){
		val newBuilding = cityFactory.createBuilding
		newBuilding.name = elem.name
		newBuilding.value = elem.value
		newBuilding.fqn = elem.fqn
		newBuilding.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newBuilding.level = level
		newBuilding.id = elem.id
		newBuilding.methodCounter = functionModules.filter[parentType.ref == elem].length
		newBuilding.dataCounter = attributes.filter[parentType.ref === elem].length
		if(elem.iteration >= 1){
			newBuilding.notInOrigin = "true"
		}
		
		functionModules.filter[parentType.ref == elem].forEach[newBuilding.methods.add(toFloor)]
		
		if(config.showFugrAttributes){
			newBuilding.dataCounter = attributes.filter[parentType.ref == elem].length
			attributes.filter[parentType.ref == elem].forEach[newBuilding.data.add(toChimney)]
		}
		
		return newBuilding
	}
	
	def Building toBuilding(FAMIXDictionaryData elem, int level){
		val newBuilding = cityFactory.createBuilding
		newBuilding.name = elem.name
		newBuilding.value = elem.value
		newBuilding.fqn = elem.fqn
		newBuilding.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newBuilding.level = level 
		newBuilding.id = elem.id
		//newBuilding.dataCounter = 1  //- width/length
		if(elem.iteration >= 1){
			newBuilding.notInOrigin = "true"
		}
		
		//ABAPStruc segments
		if(newBuilding.type == "FAMIX.ABAPStruc"){
			newBuilding.methodCounter = abapStrucElem.filter[container.ref == elem].length
			abapStrucElem.filter[container.ref == elem].forEach[newBuilding.methods.add(toFloor)]
		}
		
		//TableType segments
		if(newBuilding.type == "FAMIX.TableType"){
			newBuilding.methodCounter = ttyElements.filter[tableType.ref == elem].length
			ttyElements.filter[tableType.ref == elem].forEach[newBuilding.methods.add(toFloor)]
		}
		
		//Table segments
		if(newBuilding.type == "FAMIX.Table"){
			newBuilding.methodCounter = tableElements.filter[container.ref == elem].length
			tableElements.filter[container.ref == elem].forEach[newBuilding.methods.add(toFloor)]
		}
		
		return newBuilding
	}
	
	def private Building toBuilding(FAMIXClass elem, int level) {
		val newBuilding = cityFactory.createBuilding
		newBuilding.name = elem.name
		newBuilding.value = elem.value
		newBuilding.fqn = elem.fqn
		newBuilding.type = CityUtils.getFamixClassString(elem.class.simpleName)
		if(elem.iteration >= 1){
			newBuilding.notInOrigin = "true"
		}
		
		// Is interface?
		if(elem.isInterface == "true") {
			newBuilding.type = "FAMIX.Interface"
		}else{
			newBuilding.type = "FAMIX.Class"
		}

		newBuilding.level = level
		newBuilding.id = elem.id

		inheritances.filter[subclass.ref === elem].forEach [ i |
			val inheritance = cityFactory.createReference
			inheritance.type = "Inheritance"
			inheritance.name = i.superclass.ref.name
			//inheritance.fqn = i.superclass.ref.fqn
			newBuilding.references += inheritance
		]
		
		val currentMethods = methods.filter[parentType.ref === elem]
		val currentAttributes = attributes.filter[parentType.ref === elem]

		newBuilding.dataCounter = currentAttributes.length
		newBuilding.methodCounter = currentMethods.length

		if (config.buildingType == BuildingType::CITY_FLOOR) {
			methods.filter[parentType.ref.equals(elem)].forEach[newBuilding.methods.add(toFloor)]
			attributes.filter[parentType.ref.equals(elem)].forEach[newBuilding.data.add(toChimney)]
		} 
		return newBuilding
	}

	/**
	 * Sets values for current class and searches for nested elements
	 * 
	 * @param elem Source class for the building
	 * @param level Hierarchy level of the building
	 * @return new Building
	 */
	def private Building toBuilding(FAMIXStructure elem, int level) {
		val newBuilding = cityFactory.createBuilding
		newBuilding.name = elem.name
		newBuilding.value = elem.value
		newBuilding.fqn = elem.fqn
		newBuilding.type = CityUtils.getFamixClassString(elem.class.simpleName)
		
		newBuilding.level = level
		newBuilding.id = elem.id
		inheritances.filter[subclass.ref === elem].forEach [ i |
			val inheritance = cityFactory.createReference
			inheritance.type = "Inheritance"
			inheritance.name = i.superclass.ref.name
			//inheritance.fqn = i.superclass.ref.fqn
			newBuilding.references += inheritance
		]


		newBuilding.dataCounter = methods.filter[parentType.ref === elem].length
		newBuilding.methodCounter = attributes.filter[parentType.ref === elem].length

		if (config.buildingType == BuildingType::CITY_FLOOR) {
			methods.filter[parentType.ref.equals(elem)].forEach[newBuilding.methods.add(toFloor)]
			attributes.filter[parentType.ref.equals(elem)].forEach[newBuilding.data.add(toChimney)]
		}
		return newBuilding
	}

	def private Building toBuilding(FAMIXMethod elem, int level) {
		val newBuilding = cityFactory.createBuilding
		newBuilding.name = elem.name
		newBuilding.value = elem.value
		newBuilding.fqn = elem.fqn
		newBuilding.signature = elem.signature
		newBuilding.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newBuilding.level = level
		newBuilding.id = elem.id
		if(elem.iteration >= 1){
			newBuilding.notInOrigin = "true"
		}
	    newBuilding.methodCounter = elem.numberOfStatements
		
		newBuilding.visibility = elem.modifiers.findFirst[it == "PRIVATE" || it == "PROTECTED" || it == "PUBLIC"]
		if (newBuilding.visibility === null) {
			newBuilding.visibility = "PUBLIC"	
		}			 

		return newBuilding
	}
	
	def private Building toBuilding(FAMIXAttribute elem, int level , boolean isClass) {
		val newBuilding = cityFactory.createBuilding
		newBuilding.name = elem.name
		newBuilding.value = elem.value
		newBuilding.fqn = elem.fqn
		newBuilding.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newBuilding.level = level
		newBuilding.id = elem.id
		if(elem.iteration >= 1){
			newBuilding.notInOrigin = "true"
		}
		if (isClass) {
			newBuilding.parentType = "FAMIX.Class"
			val dataType = typeOfs.findFirst[element.ref == elem]

			if (dataType === null || dataType.typeOf.ref.getClass.toString.contains("FAMIXDataElement")) {
				newBuilding.dataCounter = 1.0
			} else if (dataType.typeOf.ref.getClass.toString.contains("FAMIXABAPStruc")) {
				newBuilding.dataCounter = 2.0
			} else if (dataType.typeOf.ref.getClass.toString.contains("FAMIXTable") || dataType.typeOf.ref.getClass.toString.contains("FAMIXTableType") || dataType.typeOf.ref.getClass.toString.contains("FAMIXClass")) {
				newBuilding.dataCounter = 3.0
			}
			
			newBuilding.visibility = elem.modifiers.findFirst[it == "PRIVATE" || it == "PROTECTED" || it == "PUBLIC"] 
			
			return newBuilding	
		
		} else {
			newBuilding.parentType = "FAMIX.Interface"
			newBuilding.visibility = elem.modifiers.findFirst[it == "PRIVATE" || it == "PROTECTED" || it == "PUBLIC"] 
		
			return newBuilding	
		}		
	}
	
	def private Building toRepoBuilding(FAMIXAttribute elem, int level) {
		val newBuilding = cityFactory.createBuilding
		newBuilding.name = elem.name
		newBuilding.value = elem.value
		newBuilding.fqn = elem.fqn
		newBuilding.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newBuilding.level = level
		newBuilding.id = elem.id
		newBuilding.parentType = "FAMIX.Report"
		if(elem.iteration >= 1){
			newBuilding.notInOrigin = "true"
		}
		
		newBuilding.visibility = elem.modifiers.findFirst[it == "PRIVATE" || it == "PROTECTED" || it == "PUBLIC"] 
		
		return newBuilding		
	}
	
	def private Building toFumoBuilding(FAMIXAttribute elem, int level) {
		val newBuilding = cityFactory.createBuilding
		newBuilding.name = elem.name
		newBuilding.value = elem.value
		newBuilding.fqn = elem.fqn
		newBuilding.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newBuilding.level = level
		newBuilding.id = elem.id
		newBuilding.parentType = "FAMIX.FunctionGroup"
		if(elem.iteration >= 1){
			newBuilding.notInOrigin = "true"
		}
			
		newBuilding.visibility = elem.modifiers.findFirst[it == "PRIVATE" || it == "PROTECTED" || it == "PUBLIC"] 
		
		return newBuilding		
	}
	
	def private Building toBuilding(FAMIXFunctionModule elem, int level) {
		val newBuilding = cityFactory.createBuilding
		newBuilding.name = elem.name
		newBuilding.value = elem.value
		newBuilding.fqn = elem.fqn
		newBuilding.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newBuilding.level = level
		newBuilding.id = elem.id
		if(elem.iteration >= 1){
			newBuilding.notInOrigin = "true"
		}
		newBuilding.methodCounter = elem.numberOfStatements + 2
		
		return newBuilding		
	}
	
	def private Building toBuilding(FAMIXFormroutine elem, int level) {
		val newBuilding = cityFactory.createBuilding
		newBuilding.name = elem.name
		newBuilding.value = elem.value
		newBuilding.fqn = elem.fqn
		newBuilding.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newBuilding.level = level
		newBuilding.id = elem.id
		if(elem.iteration >= 1){
			newBuilding.notInOrigin = "true"
		}
		newBuilding.methodCounter = elem.numberOfStatements
		
		return newBuilding		
	}
	
	def private Building toAdvBuilding(FAMIXReport elem, int level, boolean reportAttr) {
		val newBuilding = cityFactory.createBuilding
		newBuilding.name = elem.name
		newBuilding.value = elem.value
		newBuilding.fqn = elem.fqn
		newBuilding.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newBuilding.dataCounter = attributes.filter[parentType.ref === elem].length
		newBuilding.level = level
		newBuilding.id = elem.id
		if(elem.iteration >= 1){
			newBuilding.notInOrigin = "true"
		}
		
		newBuilding.methodCounter = elem.numberOfStatements
		
		if(config.showReportAdvAttributes){
		  if(reportAttr){
		  	newBuilding.parentType = "FAMIX.Report"
		  	}
			newBuilding.dataCounter = attributes.filter[parentType.ref == elem].length 
		    attributes.filter[parentType.ref == elem].forEach[newBuilding.data.add(toChimney)]
		}
		
		
		return newBuilding		
	}
	
	def private Building toBuilding(FAMIXStrucElement elem, int level) {
		val newBuilding = cityFactory.createBuilding
		newBuilding.name = elem.name
		newBuilding.value = elem.value
		newBuilding.fqn = elem.fqn
		newBuilding.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newBuilding.level = level
		newBuilding.id = elem.id
		if(elem.iteration >= 1){
			newBuilding.notInOrigin = "true"
		}
        
		return newBuilding		
	}
	
	def private Building toAdvBuilding(FAMIXABAPStruc elem, int level) {
		val newBuilding = cityFactory.createBuilding
		newBuilding.name = elem.name
		newBuilding.value = elem.value
		newBuilding.fqn = elem.fqn
		newBuilding.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newBuilding.level = level
		newBuilding.id = createID("StrucElem" + elem.id)
		if(elem.iteration >= 1){
			newBuilding.notInOrigin = "true"
		}
        
		return newBuilding		
	}
	
	def private Building toBuilding(FAMIXTableType elem, int level, boolean rowTypeTable) {
		val newBuilding = cityFactory.createBuilding
		newBuilding.name = elem.name
		newBuilding.value = elem.value
		newBuilding.fqn = elem.fqn
		newBuilding.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newBuilding.level = level
		newBuilding.id = elem.id
		if(elem.iteration >= 1){
			newBuilding.notInOrigin = "true"
		}

        if (rowTypeTable) {
			newBuilding.rowType = "FAMIX.Table"
        } else {
        	newBuilding.rowType = "FAMIX.ABAPStruc"
        }
		return newBuilding		
	}
	
	def private Building toAdvBuilding(FAMIXClass elem, int level, boolean interfaceAttr) {
		val newBuilding = cityFactory.createBuilding
		newBuilding.name = elem.name
		newBuilding.value = elem.value
		newBuilding.fqn = elem.fqn
		newBuilding.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newBuilding.level = level
		newBuilding.id = elem.id
		if(elem.iteration >= 1){
			newBuilding.notInOrigin = "true"
		}
		
		newBuilding.methodCounter = methods.filter[parentType.ref == elem].length + 1
		
		if(config.showInterfaceAttributes){
		  if(interfaceAttr){
		  	newBuilding.parentType = "FAMIX.Interface"
		  }
			newBuilding.dataCounter = attributes.filter[parentType.ref == elem].length 
		    attributes.filter[parentType.ref == elem].forEach[newBuilding.data.add(toChimney)]
		}
        
		return newBuilding		
	}
	
	def private Building toAdvBuilding(FAMIXTable elem, int level, boolean tableFields) {
		val newBuilding = cityFactory.createBuilding
		newBuilding.name = elem.name
		newBuilding.value = elem.value
		newBuilding.fqn = elem.fqn
		newBuilding.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newBuilding.dataCounter = tableElements.filter[container.ref === elem].length
		newBuilding.level = level
		newBuilding.id = elem.id
		if(elem.iteration >= 1){
			newBuilding.notInOrigin = "true"
		}
		
	    if(config.showTableElements){
			if(tableFields){
			  	newBuilding.parentType = "FAMIX.Table"
			  	}
				newBuilding.dataCounter = tableElements.filter[container.ref == elem].length
				tableElements.filter[container.ref == elem].forEach[newBuilding.data.add(toChimney)]		
			}
		
		return newBuilding		
	}
	
	
	
	/**
	 * Sets values for current method of the {@code parent} class.
	 * 
	 * @param elem Source method for the buildingSegment
	 * @param level Hierarchy level of the underlying district/package
	 * @return new BuildingSegment
	 * @see toBuildingSegment_Attribute(FAMIXAttribute, Building, int)
	 */
	def private BuildingSegment toBuildingSegment_Method(FAMIXMethod elem, Building parent, int level) {
		val newBuildingSegment = cityFactory.createBuildingSegment
		newBuildingSegment.name = elem.name
		newBuildingSegment.value = elem.value
		newBuildingSegment.fqn = elem.fqn
		newBuildingSegment.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newBuildingSegment.level = level
		newBuildingSegment.id = elem.id
		newBuildingSegment.signature = elem.signature
		newBuildingSegment.modifiers = elem.modifiers.toString
		newBuildingSegment.numberOfStatements = elem.numberOfStatements
		newBuildingSegment.parent = parent
		newBuildingSegment.methodKind = elem.kind
		//newBuildingSegment.declaredType = CityUtils.fillDeclaredType(cityFactory.createDeclaredType, elem.declaredType)

		newBuildingSegment.localVariableCounter = localVariables.filter[parentBehaviouralEntity.ref === elem].length

		newBuildingSegment.parameterCounter = parameters.filter[parentBehaviouralEntity.ref === elem].length

		return newBuildingSegment
	}

	/**
	 * Sets values for current attribute of the {@code parent} class.
	 * 
	 * @param elem Source method for the buildingSegment
	 * @param level Hierarchy level of the underlying district/package
	 * @return new BuildingSegment
	 * @see toBuildingSegment_Method(FAMIXMethod, Building, int)
	 */
	def private BuildingSegment toBuildingSegment_Attribute(FAMIXAttribute elem, Building parent, int level) {
		val newBuildingSegment = cityFactory.createBuildingSegment
		newBuildingSegment.name = elem.name
		newBuildingSegment.value = elem.value
		newBuildingSegment.fqn = elem.fqn
		newBuildingSegment.type = CityUtils.getFamixClassString(elem.class.simpleName)
		newBuildingSegment.level = level
		newBuildingSegment.id = elem.id
		newBuildingSegment.modifiers = elem.modifiers.toString
		newBuildingSegment.parent = parent
		//newBuildingSegment.declaredType = CityUtils.fillDeclaredType(cityFactory.createDeclaredType, elem.declaredType)

		return newBuildingSegment
	}

	// pko 2016
	def BuildingSegment create newBuildingSegment: cityFactory.createBuildingSegment toFloor(FAMIXMethod famixMethod) {
		newBuildingSegment.name = famixMethod.name
		newBuildingSegment.value = famixMethod.value
		newBuildingSegment.fqn = famixMethod.fqn
		newBuildingSegment.id = famixMethod.id
	}

	// pko 2016
	def BuildingSegment create newBuildingSegment: cityFactory.createBuildingSegment toChimney(
		FAMIXAttribute famixAttribute) {
		newBuildingSegment.name = famixAttribute.name
		newBuildingSegment.value = famixAttribute.value
		newBuildingSegment.fqn = famixAttribute.fqn
		newBuildingSegment.id = famixAttribute.id
	}
	
	def BuildingSegment create newBuildingSegment: cityFactory.createBuildingSegment toChimney(
		FAMIXTableElement famixTableElement) {
		newBuildingSegment.name = famixTableElement.name
		newBuildingSegment.value = famixTableElement.value
		newBuildingSegment.fqn = famixTableElement.fqn
		newBuildingSegment.id = famixTableElement.id
	}
	
	//ABAP
	def BuildingSegment create newBuildingSegment: cityFactory.createBuildingSegment toFloor(FAMIXFormroutine famixFormroutine) {
		newBuildingSegment.name = famixFormroutine.name
		newBuildingSegment.value = famixFormroutine.value
		newBuildingSegment.fqn = famixFormroutine.fqn
		newBuildingSegment.id = famixFormroutine.id
	}  

	def BuildingSegment create newBuildingSegment: cityFactory.createBuildingSegment toFloor(FAMIXFunctionModule famixFuncModule) {
		newBuildingSegment.name = famixFuncModule.name
		newBuildingSegment.value = famixFuncModule.value
		newBuildingSegment.fqn = famixFuncModule.fqn
		newBuildingSegment.id = famixFuncModule.id
	} 
	
	def BuildingSegment create newBuildingSegment: cityFactory.createBuildingSegment toFloor(FAMIXDictionaryData famixElement) {
		newBuildingSegment.name = famixElement.name
		newBuildingSegment.value = famixElement.value
		newBuildingSegment.fqn = famixElement.fqn
		newBuildingSegment.id = famixElement.id
	}
     
   
     def createID(String fqn) {
     	return "ID_" + sha1Hex(fqn + config.repositoryName + config.repositoryOwner)
     }

}