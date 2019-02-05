package org.svis.generator.city.m2m.abapAdvancedModeSets

import java.util.List
import org.apache.commons.logging.LogFactory
import org.svis.xtext.city.Entity
import org.svis.generator.SettingsConfiguration
import org.svis.generator.SettingsConfiguration.BuildingType
import org.svis.generator.city.m2m.RGBColor

class AdvSet_SimpleBlocks {
	val log = LogFactory::getLog(getClass)
	val config = SettingsConfiguration.instance
	
	def set(List<Entity> entities) {
		return entities.toX3DModel()
	}
	
	// transform logic
	def String toX3DModel(List<Entity> entities) '''
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
				|| entity.type == "FAMIX.Table" || entity.type == "FAMIX.Class" 
				|| entity.type == "FAMIX.Domain" || entity.type == "FAMIX.TableType"
				|| entity.type == "FAMIX.Method" || entity.type == "FAMIX.Attribute" || entity.type == "typeNames" 
				|| entity.type == "FAMIX.FunctionModule" || entity.type == "FAMIX.Formroutine"»
				«IF config.buildingType == BuildingType.CITY_ORIGINAL || config.showBuildingBase»
					«toBuilding(entity)»
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
						<Material diffuseColor='«entity.color»' transparency='«entity.transparency»'></Material>
					</Appearance>
				</Shape>
			</Transform>
		</Group>
	'''
	
	def String toBuilding(Entity entity)'''
		«IF entity.type == "FAMIX.DataElement"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ (entity.position.y + config.getAbapSimpleBlock_element_height(entity.type) / 2) +" "+ entity.position.z»'>
					<Shape>
						<Cylinder radius='«entity.width/2»' height='«config.getAbapSimpleBlock_element_height(entity.type)»'></Cylinder>
						<Appearance>
							<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
						</Appearance>
					</Shape>
				</Transform>
			</Group>

		«ELSEIF entity.type == "FAMIX.Domain"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ (entity.position.y + config.getAbapSimpleBlock_element_height(entity.type) / 2) +" "+ entity.position.z»'>
					<Shape>
						<Cylinder radius='«entity.width/3»' height='«config.getAbapSimpleBlock_element_height(entity.type)»' ></Cylinder>
						<Appearance>
							<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
						</Appearance>
					</Shape>
				</Transform>
			</Group>
								
		«ELSEIF entity.type == "FAMIX.Table"»
««« TODO
		
		«ELSEIF entity.type == "FAMIX.StrucElement"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ (entity.position.y + config.getAbapSimpleBlock_element_height(entity.type) / 2) +" "+ entity.position.z»'>
					<Shape>
						<Cone bottomRadius='«entity.width/3»' height='«config.getAbapSimpleBlock_element_height(entity.type)»' ></Cone>
						<Appearance>
							<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
						</Appearance>
					</Shape>
				</Transform>
			</Group>
								
		«ELSEIF entity.type == "FAMIX.TableType"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ (entity.position.y + config.getAbapSimpleBlock_element_height(entity.type) / 2) +" "+ entity.position.z»'>
					<Shape>
						<Cone bottomRadius='«entity.width»' height='«config.getAbapSimpleBlock_element_height(entity.type)»' ></Cone>
						<Appearance>
							<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
						</Appearance>
					</Shape>
				</Transform>
			</Group>
			
		«ELSEIF entity.type == "FAMIX.Method"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ (entity.position.y + entity.height * config.getAbapSimpleBlock_element_height(entity.type) / 2) +" "+ entity.position.z»'>
					<Shape>
						<Box size='«entity.width / 2 +" "+ entity.height * config.getAbapSimpleBlock_element_height(entity.type)+" "+ entity.length / 2»'></Box>
						<Appearance>
							<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
						</Appearance>
					</Shape>
				</Transform>
			</Group>

		«ELSEIF entity.type == "FAMIX.Class"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ (entity.position.y + entity.height * config.getAbapSimpleBlock_element_height(entity.type) / 2) +" "+ entity.position.z»'>
					<Shape>
						<Box size='«entity.width / 2 +" "+ entity.height * config.getAbapSimpleBlock_element_height(entity.type)+" "+ entity.length / 2»'></Box>
						<Appearance>
							<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
						</Appearance>
					</Shape>
				</Transform>
			</Group>

		«ELSEIF entity.type == "FAMIX.Attribute"»
««« TODO

		«ELSEIF entity.type == "FAMIX.FunctionModule"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ (entity.position.y + entity.height * config.getAbapSimpleBlock_element_height(entity.type) / 2) +" "+ entity.position.z»'>
					<Shape>
						<Box size='«entity.width / 2 +" "+ entity.height * config.getAbapSimpleBlock_element_height(entity.type)+" "+ entity.length / 2»'></Box>
						<Appearance>
							<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
						</Appearance>
					</Shape>
				</Transform>
			</Group>

		«ELSEIF entity.type == "FAMIX.Report"»		
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ (entity.position.y + entity.height * config.getAbapSimpleBlock_element_height(entity.type) / 2) +" "+ entity.position.z»'>
					<Shape>
						<Box size='«entity.width / 2 +" "+ entity.height * config.getAbapSimpleBlock_element_height(entity.type)+" "+ entity.length / 2»'></Box>
						<Appearance>
							<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
						</Appearance>
					</Shape>
				</Transform>
			</Group>
			
		«ELSEIF entity.type == "FAMIX.Formroutine"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ (entity.position.y + entity.height * config.getAbapSimpleBlock_element_height(entity.type) / 2) +" "+ entity.position.z»'>
					<Shape>
						<Box size='«entity.width +" "+ entity.height * config.getAbapSimpleBlock_element_height(entity.type)+" "+ entity.length»'></Box>
						<Appearance>
							<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
						</Appearance>
					</Shape>
				</Transform>
			</Group>
						
		«ENDIF»		
	'''
	
	def String getColor(String type) {
		if (config.getAbapBuildingColor(type) !== null) {
			return new RGBColor(config.getAbapBuildingColor(type)).asPercentage
		} else if (config.getAbapBuildingSegmentColor(type) !== null) {
			return new RGBColor(config.getAbapBuildingSegmentColor(type)).asPercentage
		} else {
			return new RGBColor(config.getColor("#000000")).asPercentage
		}
	}	
}