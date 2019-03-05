package org.svis.generator.city.m2t

import java.util.List
import java.lang.reflect.*
import org.apache.commons.logging.LogFactory
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.EcoreUtil2
import org.svis.generator.city.m2m.CityLayout
import org.svis.generator.city.m2m.ABAPCityLayout
import org.svis.generator.city.m2m.Rectangle
import org.svis.xtext.city.Building
import org.svis.xtext.city.BuildingSegment
import org.svis.xtext.city.Entity
import org.svis.xtext.city.PanelSeparatorBox
import org.svis.xtext.city.PanelSeparatorCylinder
import org.svis.xtext.city.District
import org.svis.generator.SettingsConfiguration
import org.svis.generator.SettingsConfiguration.BuildingType
import org.svis.generator.SettingsConfiguration.AbapCityRepresentation
import org.svis.generator.city.m2m.customModels.*
import org.svis.generator.city.CityUtils
import org.svis.generator.city.m2m.abapAdvancedModeSets.AdvSet_Interface

class City2X3D_abap_adv {
			
	val log = LogFactory::getLog(getClass)
	val config = SettingsConfiguration.instance
	val advSetName = config.getAbapAdvCity_set.toString
	val advSetClass = try {
		Class.forName(advSetName)
	} catch (ClassNotFoundException e) {
		log.info("advSetName - Class not found")
		null
	}		
	
	var AdvSet_Interface advSetClass_Instance = advSetClass.newInstance() as AdvSet_Interface	
	
	def set(List<Entity> entities) {
		if (advSetClass === null) {
			log.info("Custom Set Class - not found")
			return null
		}		
		val x3d = try {
			entities.toX3DModel()	
		} catch (NoSuchMethodException e) {
			log.info("Check Method Parameters")
			null
		}
		return x3d	
	}
	
	// transform logic
	def String toX3DModel(List<Entity> entities) '''	
		<Group DEF='defineModels'>
			<Transform translation='0 -100 0'>
				<Shape>
					«advSetClass_Instance.defineElements()»
«««					<Appearance>
«««						<Material diffuseColor='0.8784313725490196 0.8392156862745098 0.39215686274509803' transparency='0'></Material>
«««					</Appearance>
				</Shape>
			</Transform>
		</Group>
			
  		«FOR entity : entities»
			«IF entity.type == "FAMIX.Namespace"  || entity.type == "reportDistrict"
				|| entity.type == "classDistrict" || entity.type == "functionGroupDistrict" 
				|| entity.type == "tableDistrict" || entity.type == "dcDataDistrict" || entity.type == "interfaceDistrict"
				|| entity.type == "domainDistrict" || entity.type == "structureDistrict"»
				«toDistrict(entity)»
			«ENDIF»
			«IF entity.type == "FAMIX.Class" || entity.type == "FAMIX.Interface"|| entity.type == "FAMIX.DataElement" 
				|| entity.type == "FAMIX.Report" || entity.type == "FAMIX.FunctionGroup" 
				|| entity.type == "FAMIX.ABAPStruc"	|| entity.type == "FAMIX.StrucElement" 
				|| entity.type == "FAMIX.Table" || entity.type == "FAMIX.TableElement" || entity.type == "FAMIX.Class" 
				|| entity.type == "FAMIX.Domain" || entity.type == "FAMIX.TableType"
				|| entity.type == "FAMIX.Method" || entity.type == "FAMIX.Attribute" || entity.type == "typeNames" 
				|| entity.type == "FAMIX.FunctionModule" || entity.type == "FAMIX.Formroutine"»
				«IF config.buildingType == BuildingType.CITY_ORIGINAL || config.showBuildingBase»
					«toBuilding(entity)»
				«ENDIF»
				«IF(config.buildingType == BuildingType::CITY_FLOOR)»
					«FOR chimney: (entity as Building).data»
						«toChimney(chimney, entity)»
					«ENDFOR»	
				«ENDIF»
		  	«ENDIF»
		«ENDFOR»
	'''
	
	def String toDistrict(Entity entity) '''
		<Group DEF='«entity.id»'>
			<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'>
				<Shape>
					«IF entity.type == "tableDistrict"»	
						<Box size='«entity.width +" "+ entity.height +" "+ entity.length»'></Box>
					«ELSE»
						<Box size='«entity.width +" "+ entity.height +" "+ entity.length»'></Box>
					«ENDIF»
					<Appearance>
						«IF(config.abapShowTextures && entity.textureURL !== null && entity.textureURL != "")»
							<ImageTexture url='«entity.textureURL»'></ImageTexture>
						«ELSE»
							<Material diffuseColor='«entity.color»' transparency='«entity.transparency»'></Material>
						«ENDIF»
					</Appearance>
				</Shape>
			</Transform>
		</Group>
	'''
	
	//Advanced ABAP buildings
	def String toBuilding(Entity entity)'''
		<Group DEF='«entity.id»'>
			<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»' 
					   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'>
			
			«IF entity.type == "FAMIX.DataElement"»
				«advSetClass_Instance.getElemFor_DataElement(entity)»
			«ELSEIF entity.type == "FAMIX.Domain"»
				«advSetClass_Instance.getElemFor_Domain(entity)»
			«ELSEIF entity.type == "FAMIX.StrucElement"»
				«advSetClass_Instance.getElemFor_StrucElement(entity)»
			«ELSEIF entity.type == "FAMIX.Table"»
				«advSetClass_Instance.getElemFor_Table(entity)»
			«ELSEIF entity.type == "FAMIX.Method"»
				«advSetClass_Instance.getElemFor_Method(entity)»
			«ELSEIF entity.type == "FAMIX.Class"»
				«advSetClass_Instance.getElemFor_Class(entity)»
			«ELSEIF entity.type == "FAMIX.FunctionModule"»
				«advSetClass_Instance.getElemFor_FunctionModule(entity)»
			«ELSEIF entity.type == "FAMIX.Report"»
				«advSetClass_Instance.getElemFor_Report(entity)»
			«ELSEIF entity.type == "FAMIX.Formroutine"»
				«advSetClass_Instance.getElemFor_Formroutine(entity)»
			«ELSEIF entity.type == "FAMIX.TableType"»
				«IF entity.rowType == "FAMIX.ABAPStruc"»
					«advSetClass_Instance.getElemFor_TableType_ABAPStruc(entity)»
				«ELSEIF entity.rowType == "FAMIX.Table"»
					«advSetClass_Instance.getElemFor_TableType_Table(entity)»
				«ENDIF»
			«ELSEIF entity.type == "FAMIX.Attribute"» 
				«IF entity.parentType == "FAMIX.FunctionGroup"»	
					«advSetClass_Instance.getElemFor_Attribute_FunctionGroup(entity)»
				«ELSEIF entity.parentType == "FAMIX.Class"»
					«advSetClass_Instance.getElemFor_Attribute_Class(entity)»
				«ENDIF»
			«ENDIF»
				
     	</Transform>
		</Group>
	'''
	
	def toChimney(BuildingSegment chimney, Entity entity) '''
		<Group DEF='«chimney.id»'>
		<Transform translation='«chimney.position.x +" "+ chimney.position.y +" "+ chimney.position.z»'
		                       scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale("FAMIX.InterfaceAttribute"))»'>
	    	«IF entity.parentType == "FAMIX.Report"»	      		
	
		     «ELSEIF entity.parentType == "FAMIX.Interface"»			 	 
	
		     «ELSEIF entity.parentType == "FAMIX.Table"»			 	 
	
			«ENDIF»
		</Transform>
		</Group>
	'''	

	// Return scale for building. Scale - for changing size
	def String getAdvBuildingScale(double scale)'''
		«scale + " " + scale +  " " + scale»
	'''
}