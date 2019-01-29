package org.svis.generator.city.m2m.abapAdvancedModeSets

import java.util.List
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

class AdvSet_SimpleBlocks {
	val log = LogFactory::getLog(getClass)
	val config = SettingsConfiguration.instance
	var defineCMSimpleHouse = true
	var defineCMSkyScraper = true
	var defineCMRadioTower = true
	var defineCMApartmentBuilding = true
	var defineCMBoat = true
	var defineCMCarPark = true
	var defineCMTableType = true
	var defineCMTownHall = true
	var defineCMFactoryBuilding = true
	var defineCMFactoryHall = true
	var defineCMFactoryBuildingFumo = true
	
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
		«IF entity.type == "FAMIX.DataElement"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ (entity.position.y + 4) +" "+ entity.position.z»'>
					<Shape>
						<Cylinder radius='«entity.width/2»' height='«8»'></Cylinder>
						<Appearance>
							<Material diffuseColor='«entity.color»' transparency='«entity.transparency»'></Material>
						</Appearance>
					</Shape>
				</Transform>
			</Group>

		«ELSEIF entity.type == "FAMIX.Domain"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ (entity.position.y + 10) +" "+ entity.position.z»'>
					<Shape>
						<Cone bottomRadius='«entity.width/3»' height='«20»' ></Cone>
						<Appearance>
							<Material diffuseColor='«entity.color»' transparency='«entity.transparency»'></Material>
						</Appearance>
					</Shape>
				</Transform>
			</Group>
								
		«ELSEIF entity.type == "FAMIX.Table"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'
						   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
						   rotation='0 0.707107 0.707107 3.141593'>
					«IF defineCMBoat»
						«defineCMBoat = false»
						«CustomModel_Boat::defineBoatFront»
						«FOR n : 1..entity.height.intValue»
							«CustomModel_Boat::defineBoatMiddle(config.getAbapTableFrontWidth + (n - 1) * config.getAbapTableMiddleWidth)»
						«ENDFOR»
						«CustomModel_Boat::defineBoatBack(config.getAbapTableFrontWidth + entity.width * config.getAbapTableMiddleWidth)»
					«ELSE»
						«CustomModel_Boat::createBoatFront»
						«FOR n : 1..entity.height.intValue»
							«CustomModel_Boat::createBoatMiddle(config.getAbapTableFrontWidth + (n - 1) * config.getAbapTableMiddleWidth)»
						«ENDFOR»
						«CustomModel_Boat::createBoatBack(config.getAbapTableFrontWidth + entity.width * config.getAbapTableMiddleWidth)»
					«ENDIF»
				</Transform>
			</Group>
								
		«ELSEIF entity.type == "FAMIX.StrucElement"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'
						   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
						   rotation='0 0.707107 0.707107 3.141593'>
					«IF defineCMApartmentBuilding»
						«defineCMApartmentBuilding = false»
						«CustomModel_ApartmentBuilding::defineApartmentBuildingBase»
						«FOR n : 1..entity.height.intValue»
							«CustomModel_ApartmentBuilding::defineApartmentBuildingFloor(config.getAbapStrucElementBaseHeight + (n - 1) * config.getAbapStrucElementFloorHeight)»
						«ENDFOR»
						«CustomModel_ApartmentBuilding::defineApartmentBuildingRoof(config.getAbapStrucElementBaseHeight + entity.height * config.getAbapStrucElementFloorHeight)»
					«ELSE»
						«CustomModel_ApartmentBuilding::createApartmentBuildingBase»
						«FOR n : 1..entity.height.intValue»
							«CustomModel_ApartmentBuilding::createApartmentBuildingFloor(config.getAbapStrucElementBaseHeight + (n - 1) * config.getAbapStrucElementFloorHeight)»
						«ENDFOR»
						«CustomModel_ApartmentBuilding::createApartmentBuildingRoof(config.getAbapStrucElementBaseHeight + entity.height * config.getAbapStrucElementFloorHeight)»
					«ENDIF»
				</Transform>
			</Group>
								
		«ELSEIF entity.type == "FAMIX.TableType"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'>
					<Shape>
   						<Cylinder radius='«entity.width»' height='«entity.height*4»'></Cylinder>	
						<Appearance>
   						   	<Material diffuseColor='«entity.color»' transparency='«entity.transparency»'></Material>
   						</Appearance>
					</Shape>
				</Transform>
			</Group>
			
		«ELSEIF entity.type == "FAMIX.Method"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»' 
						   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
						   rotation='0.000000 0.707107 0.707107 3.141593'>
					«IF defineCMSkyScraper»
«««						«CustomModel_SkyScraper::defineSkyScraperShape(config.getAbapAdvBuildingScale(entity.type), entity.numberOfStatements, entity.position.y)»
						«defineCMSkyScraper = false»
						«FOR part : entity.getBuildingParts»
							«IF part.type == "Base"»
								«CustomModel_SkyScraper::defineSkyScraperBase(part.height)»
							«ELSEIF part.type == "Roof"»
								«CustomModel_SkyScraper::defineSkyScraperRoof(part.height)»
							«ELSEIF part.type == "Floor"»
								«CustomModel_SkyScraper::defineSkyScraperFloor(part.height)»
							«ENDIF»						
						«ENDFOR»
					«ELSE»
«««						«CustomModel_SkyScraper::createSkyScraperShape(config.getAbapAdvBuildingScale(entity.type), entity.numberOfStatements, entity.position.y)»
						«FOR part : entity.getBuildingParts»
							«IF part.type == "Base"»
								«CustomModel_SkyScraper::createSkyScraperBase(part.height)»
							«ELSEIF part.type == "Roof"»
								«CustomModel_SkyScraper::createSkyScraperRoof(part.height)»
							«ELSEIF part.type == "Floor"»
								«CustomModel_SkyScraper::createSkyScraperFloor(part.height)»
							«ENDIF»						
						«ENDFOR»
					«ENDIF»	
				</Transform>
			</Group>

		«ELSEIF entity.type == "FAMIX.Class"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'
						   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
						   rotation='0 0.707107 0.707107 3.141593'>
					«IF defineCMRadioTower»
						«defineCMRadioTower = false»
						«CustomModel_RadioTower::defineRadioTowerBase»
						«FOR n : 1..entity.height.intValue»
							«CustomModel_RadioTower::defineRadioTowerFloor(config.getAbapClassBaseHeight + (n - 1) * config.getAbapClassFloorHeight)»
						«ENDFOR»
						«CustomModel_RadioTower::defineRadioTowerRoof(config.getAbapClassBaseHeight + entity.height * config.getAbapClassFloorHeight)»
					«ELSE»
						«CustomModel_RadioTower::createRadioTowerBase»
						«FOR n : 1..entity.height.intValue»
							«CustomModel_RadioTower::createRadioTowerFloor(config.getAbapClassBaseHeight + (n - 1) * config.getAbapClassFloorHeight)»
						«ENDFOR»
						«CustomModel_RadioTower::createRadioTowerRoof(config.getAbapClassBaseHeight + entity.height * config.getAbapClassFloorHeight)»
					«ENDIF»
				</Transform>
			</Group>
		
		«ELSEIF entity.type == "FAMIX.Attribute"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'
						   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
						   rotation='0 0.707107 0.707107 3.141593'>
					«IF defineCMCarPark»
						«defineCMCarPark = false»
						«CustomModel_CarPark::defineCarParkBase»
						«FOR n : 1..entity.height.intValue»
							«CustomModel_CarPark::defineCarParkFloor(config.getAbapAttributeBaseHeight + (n - 1) * config.getAbapAttributeFloorHeight)»
						«ENDFOR»
						«CustomModel_CarPark::defineCarParkRoof(config.getAbapAttributeBaseHeight + entity.height * config.getAbapAttributeFloorHeight)»
					«ELSE»
						«CustomModel_CarPark::createCarParkBase»
						«FOR n : 1..entity.height.intValue»
							«CustomModel_CarPark::createCarParkFloor(config.getAbapAttributeBaseHeight + (n - 1) * config.getAbapAttributeFloorHeight)»
						«ENDFOR»
						«CustomModel_CarPark::createCarParkRoof(config.getAbapAttributeBaseHeight + entity.height * config.getAbapAttributeFloorHeight)»
					«ENDIF»
				</Transform>
			</Group>


		«ELSEIF entity.type == "FAMIX.FunctionModule"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'
						   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
						   rotation='0 0.707107 0.707107 3.141593'>
					«IF defineCMFactoryBuildingFumo»
						«defineCMFactoryBuildingFumo = false»
						«CustomModel_FactoryBuildingFumo::defineFactoryBuildingFumoBase»
						«FOR n : 1..entity.height.intValue»
							«CustomModel_FactoryBuildingFumo::defineFactoryBuildingFumoFloor(config.getAbapFumoBaseHeight + (n - 1) * config.getAbapFumoFloorHeight)»
						«ENDFOR»
						«CustomModel_FactoryBuildingFumo::defineFactoryBuildingFumoRoof(config.getAbapFumoBaseHeight + entity.height * config.getAbapFumoFloorHeight)»
					«ELSE»
						«CustomModel_FactoryBuildingFumo::createFactoryBuildingFumoBase»
						«FOR n : 1..entity.height.intValue»
							«CustomModel_FactoryBuildingFumo::createFactoryBuildingFumoFloor(config.getAbapFumoBaseHeight + (n - 1) * config.getAbapFumoFloorHeight)»
						«ENDFOR»
						«CustomModel_FactoryBuildingFumo::createFactoryBuildingFumoRoof(config.getAbapFumoBaseHeight + entity.height * config.getAbapFumoFloorHeight)»
					«ENDIF»
				</Transform>
			</Group>

		«ELSEIF entity.type == "FAMIX.Report"»		
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»' 
						   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
						   rotation='0.000000 0.707107 0.707107 3.141593'>
					«IF defineCMFactoryHall»
						«CustomModel_FactoryHall::defineFactoryHallShape»
						«defineCMFactoryHall = false»
					«ELSE»
						«CustomModel_FactoryHall::createFactoryHallShape»
					«ENDIF»					
				</Transform>
			</Group>
			
		«ELSEIF entity.type == "FAMIX.Formroutine"»
«««			<Group DEF='«entity.id»'>
«««				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'>
«««					<Shape>
«««						<Box size='«entity.width +" "+ entity.height +" "+ entity.length»'></Box>
«««						
«««						<Appearance>
«««							<Material diffuseColor='«entity.color»' transparency='«entity.transparency»'></Material>
«««						</Appearance>
«««					</Shape>
«««				</Transform>
«««			</Group>
			
			 <Group DEF='«entity.id»'>
			     <Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'
			           		scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
			           		rotation='0 0.707107 0.707107 3.141593'>
			           		«IF defineCMFactoryBuilding»
			           		«defineCMFactoryBuilding = false»
			           		«CustomModel_FactoryBuilding::defineFactoryBuildingBase»
			           		«FOR n : 1..entity.height.intValue»
			           			«CustomModel_FactoryBuilding::defineFactoryBuildingFloor(config.getAbapFormBaseHeight + (n - 1) * config.getAbapFormFloorHeight)»
			           		«ENDFOR»
			           			«CustomModel_FactoryBuilding::defineFactoryBuildingRoof(config.getAbapFormBaseHeight + entity.height * config.getAbapFormFloorHeight)»
			           		«ELSE»
			           			«CustomModel_FactoryBuilding::createFactoryBuildingBase»
			           			«FOR n : 1..entity.height.intValue»
			           				«CustomModel_FactoryBuilding::createFactoryBuildingFloor(config.getAbapFormBaseHeight + (n - 1) * config.getAbapFormFloorHeight)»
			           			«ENDFOR»
			           				«CustomModel_FactoryBuilding::createFactoryBuildingRoof(config.getAbapFormBaseHeight + entity.height * config.getAbapFormFloorHeight)»
		           			«ENDIF»
			     </Transform>
			</Group>
			
		«ENDIF»		
	'''
		
	// Return scale for building
	def String getAdvBuildingScale(double scale)'''
		«scale + " " + scale +  " " + scale»
	'''
	
	// Own logic for ABAP buildings shapes
	def String abapBuildingShape(Entity entity)'''
		«IF entity.type == "FAMIX.Interface"»
			<Box size='«entity.width +" "+ entity.height +" "+ entity.length»'></Box>
		«ELSEIF entity.type == "FAMIX.DataElement"»
			<Cone bottomRadius='«entity.width»' height='«entity.height»' ></Cone>
		«ELSEIF entity.type == "FAMIX.ABAPStruc"»
			<Box size='«entity.width/4 +" "+ entity.height +" "+ entity.length/4»'></Box>
		«ELSEIF entity.type == "FAMIX.TableType"»
			<Cylinder radius='«entity.width/2»' height='«entity.height»'></Cylinder>
		«ELSEIF entity.type == "FAMIX.Table"»
			<Cylinder radius='«entity.width/2»' height='«entity.height»'></Cylinder>
		«ELSE»
			<Box size='«entity.width +" "+ entity.height +" "+ entity.length»'></Box>				
		«ENDIF»
	'''
}