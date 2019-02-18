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
import org.svis.generator.city.CityUtils

class AdvSet_CustomModels {
	val log = LogFactory::getLog(getClass)
	val config = SettingsConfiguration.instance
	var defineCMSimpleHouse = true
	var defineCMSkyScraper = true
	var defineCMSkyScraper_floor = true
	var defineCMRadioTower = true
	var defineCMRadioTower_floor = true
	var defineCMApartmentBuilding = true
	var defineCMApartmentBuilding_floor = true
	var defineCMBoat = true
	var defineCMContainerShip = true
	var defineCMCarPark = true
	var defineCMCarPark_floor = true
	var defineCMParkingSlot = true
	var defineCMTownHall = true
	var defineCMFactoryBuilding = true
	var defineCMFactoryBuilding_floor = true
	var defineCMFactoryHall = true
	var defineCMFactoryHall_floor = true
	var defineCMFactoryBuildingFumo = true
	var defineCMFactoryBuildingFumo_floor = true
	var defineCMTube = true 
	
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
				«IF(config.buildingType == BuildingType::CITY_FLOOR)»
					«FOR floor: (entity as Building).methods»
						«toFloor(floor)»
					«ENDFOR»	
					«FOR chimney: (entity as Building).data»
						«toChimney(chimney)»
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
							<TextureTransform scale='1 1'/>
						«ELSE»
							<Material diffuseColor='«entity.color»' transparency='«entity.transparency»'></Material>
«««							<Material diffuseColor='«setDistrictColor(entity.type)»' transparency='«entity.transparency»'></Material>
						«ENDIF»
					</Appearance>
				</Shape>
			</Transform>
		</Group>
	'''
	
	def String setDistrictColor(String districtType) {
		if (districtType == "domainDistrict" || districtType == "dcDataDistrict" || districtType == "structureDistrict") {
			return CityUtils.getRGBFromHEX("#27ae60") //green
		} else if (districtType == "reportDistrict") {
			return CityUtils.getRGBFromHEX("#f1c40f") // yellow
		} else if (districtType == "classDistrict") {
			return CityUtils.getRGBFromHEX("#2980b9") // blue
		} else if (districtType == "interfaceDistrict") {
			return CityUtils.getRGBFromHEX("#2980b9") // blue
		} else if (districtType == "functionGroupDistrict") {
			return CityUtils.getRGBFromHEX("#d35400") // brown
		} else {
			return CityUtils.getRGBFromHEX("#bdc3c7")
		}
	}
	
	//Advanced ABAP buildings
	def String toBuilding(Entity entity)'''
		«IF entity.type == "FAMIX.DataElement"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»' 
						   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
						   rotation='0.000000 0.707107 0.707107 3.141593'>
					«IF defineCMSimpleHouse»
						«CustomModel_SimpleHouse::defineSimpleHouseShape»
						«defineCMSimpleHouse = false»
					«ELSE»
						«CustomModel_SimpleHouse::createSimpleHouseShape»
					«ENDIF»					
				</Transform>
			</Group>

		«ELSEIF entity.type == "FAMIX.Domain"»					
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»' 
						   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
						   rotation='0.000000 0.707107 0.707107 3.141593'>
					«IF defineCMTownHall»
						«CustomModel_TownHall::defineTownHallShape»
						«defineCMTownHall = false»
					«ELSE»
						«CustomModel_TownHall::createTownHallShape»
					«ENDIF»					
				</Transform>
			</Group>
					
		«ELSEIF entity.type == "FAMIX.Table"»
«««			<Group DEF='«entity.id»'>
«««				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'
«««						   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
«««						   rotation='0 0.707107 0.707107 3.141593'>
«««					«IF defineCMContainerShip»
«««						«defineCMContainerShip = false»
«««						«CustomModel_ContainerShip::defineContainerShipFront»
«««						«FOR n : 1..entity.width.intValue»
«««							«CustomModel_ContainerShip::defineContainerShipMiddle(config.getAbapTableFrontWidth + (n - 1) * config.getAbapTableMiddleWidth)»
«««						«ENDFOR»
«««						«CustomModel_ContainerShip::defineContainerShipBack(config.getAbapTableFrontWidth + entity.width * config.getAbapTableMiddleWidth)»
«««					«ELSE»
«««						«CustomModel_ContainerShip::createContainerShipFront»
«««						«FOR n : 1..entity.width.intValue»
«««							«CustomModel_ContainerShip::createContainerShipMiddle(config.getAbapTableFrontWidth + (n - 1) * config.getAbapTableMiddleWidth)»
«««						«ENDFOR»
«««						«CustomModel_ContainerShip::createContainerShipBack(config.getAbapTableFrontWidth + entity.width * config.getAbapTableMiddleWidth)»
«««					«ENDIF»
«««				</Transform>
«««			</Group>


			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»' 
						   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
						   rotation='0.000000 0.707107 0.707107 3.141593'>
					«IF defineCMContainerShip»
						«CustomModel_ContainerShip::defineContainerShipShape»
						«defineCMContainerShip = false»
					«ELSE»
						«CustomModel_ContainerShip::createContainerShipShape»
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
						«FOR part : entity.getBuildingParts»
							«IF part.type == "Base"»
								«CustomModel_ApartmentBuilding::defineApartmentBuildingBase(part.height)»
							«ELSEIF part.type == "Roof"»
								«CustomModel_ApartmentBuilding::defineApartmentBuildingRoof(part.height)»
							«ELSEIF part.type == "Floor"»
								«IF defineCMApartmentBuilding_floor»
									«defineCMApartmentBuilding_floor = false»
									«CustomModel_ApartmentBuilding::defineApartmentBuildingFloor(part.height)»
								«ELSE»
									«CustomModel_ApartmentBuilding::createApartmentBuildingFloor(part.height)»
								«ENDIF»								
							«ENDIF»						
						«ENDFOR»
					«ELSE»
						«FOR part : entity.getBuildingParts»
							«IF part.type == "Base"»
								«CustomModel_ApartmentBuilding::createApartmentBuildingBase(part.height)»
							«ELSEIF part.type == "Roof"»
								«CustomModel_ApartmentBuilding::createApartmentBuildingRoof(part.height)»
							«ELSEIF part.type == "Floor"»
								«IF defineCMApartmentBuilding_floor»
									«defineCMApartmentBuilding_floor = false»
									«CustomModel_ApartmentBuilding::defineApartmentBuildingFloor(part.height)»
								«ELSE»
									«CustomModel_ApartmentBuilding::createApartmentBuildingFloor(part.height)»
								«ENDIF»	
							«ENDIF»						
						«ENDFOR»
					«ENDIF»	
				</Transform>
			</Group>
								
		«ELSEIF entity.type == "FAMIX.TableType"»
			<Group DEF='«entity.id»'>
                <Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»' 
                           scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
                           rotation='0.000000 0.707107 0.707107 3.141593'>
                    «IF defineCMParkingSlot»
                        «CustomModel_ParkingSlot::defineParkingSlotShape»
                        «defineCMParkingSlot = false»
                    «ELSE»
                        «CustomModel_ParkingSlot::createParkingSlotShape»
                    «ENDIF»                 
                </Transform>
            </Group>
			
		«ELSEIF entity.type == "FAMIX.Method"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»' 
						   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
						   rotation='0.000000 0.707107 0.707107 3.141593'>
					«IF defineCMSkyScraper»
						«defineCMSkyScraper = false»
						«FOR part : entity.getBuildingParts»
							«IF part.type == "Base"»
								«CustomModel_SkyScraper::defineSkyScraperBase(part.height)»
							«ELSEIF part.type == "Roof"»
								«CustomModel_SkyScraper::defineSkyScraperRoof(part.height)»
							«ELSEIF part.type == "Floor"»
								«IF defineCMSkyScraper_floor»
									«defineCMSkyScraper_floor = false»
									«CustomModel_SkyScraper::defineSkyScraperFloor(part.height)»
								«ELSE»
									«CustomModel_SkyScraper::createSkyScraperFloor(part.height)»
								«ENDIF»								
							«ENDIF»						
						«ENDFOR»
					«ELSE»
						«FOR part : entity.getBuildingParts»
							«IF part.type == "Base"»
								«CustomModel_SkyScraper::createSkyScraperBase(part.height)»
							«ELSEIF part.type == "Roof"»
								«CustomModel_SkyScraper::createSkyScraperRoof(part.height)»
							«ELSEIF part.type == "Floor"»
								«IF defineCMSkyScraper_floor»
									«defineCMSkyScraper_floor = false»
									«CustomModel_SkyScraper::defineSkyScraperFloor(part.height)»
								«ELSE»
									«CustomModel_SkyScraper::createSkyScraperFloor(part.height)»
								«ENDIF»	
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
						«FOR part : entity.getBuildingParts»
							«IF part.type == "Base"»
								«CustomModel_RadioTower::defineRadioTowerBase(part.height)»
							«ELSEIF part.type == "Roof"»
								«CustomModel_RadioTower::defineRadioTowerRoof(part.height)»
							«ELSEIF part.type == "Floor"»
								«IF defineCMRadioTower_floor»
									«defineCMRadioTower_floor = false»
									«CustomModel_RadioTower::defineRadioTowerFloor(part.height)»
								«ELSE»
									«CustomModel_RadioTower::createRadioTowerFloor(part.height)»
								«ENDIF»								
							«ENDIF»						
						«ENDFOR»
					«ELSE»
						«FOR part : entity.getBuildingParts»
							«IF part.type == "Base"»
								«CustomModel_RadioTower::createRadioTowerBase(part.height)»
							«ELSEIF part.type == "Roof"»
								«CustomModel_RadioTower::createRadioTowerRoof(part.height)»
							«ELSEIF part.type == "Floor"»
								«IF defineCMRadioTower_floor»
									«defineCMRadioTower_floor = false»
									«CustomModel_RadioTower::defineRadioTowerFloor(part.height)»
								«ELSE»
									«CustomModel_RadioTower::createRadioTowerFloor(part.height)»
								«ENDIF»	
							«ENDIF»						
						«ENDFOR»
					«ENDIF»	
				</Transform>
			</Group>
		
		«ELSEIF entity.type == "FAMIX.Attribute"»
			«IF entity.parentType == "FAMIX.Report"»
				<Group DEF='«entity.id»'>
					<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'>
						<Shape>
							<Box size='«entity.width +" "+ entity.height +" "+ entity.length»'></Box>	
							<Appearance>
								<Material diffuseColor='«entity.color»' transparency='«entity.transparency»'></Material>
							</Appearance>
						</Shape>
					</Transform>
				</Group>
			«ELSEIF entity.parentType == "FAMIX.Interface"»
				<Group DEF='«entity.id»'>
					<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'>
						<Shape>
							<Box size='«entity.width / 4+" "+ entity.height +" "+ entity.length/4»'></Box>
							
							<Appearance>
								<Material diffuseColor='«entity.color»' transparency='«entity.transparency»'></Material>
							</Appearance>
						</Shape>
					</Transform>
				</Group>
			
			«ELSEIF entity.parentType == "FAMIX.FunctionGroup"»				
				<Group DEF='«entity.id»'>
	                <Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»' 
	                           scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
	                           rotation='0.000000 0.707107 0.707107 3.141593'>
	                    «IF defineCMTube»
	                        «CustomModel_Tube::defineTubeShape»
	                        «defineCMTube = false»
	                    «ELSE»
	                        «CustomModel_Tube::createTubeShape»
	                    «ENDIF»                 
	                </Transform>
	            </Group>		
	
			«ELSEIF entity.parentType == "FAMIX.Class"»
				<Group DEF='«entity.id»'>
					<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'
							   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
							   rotation='0 0.707107 0.707107 3.141593'>
					«IF defineCMCarPark»
						«defineCMCarPark = false»
						«FOR part : entity.getBuildingParts»
							«IF part.type == "Base"»
								«CustomModel_CarPark::defineCarParkBase(part.height)»
							«ELSEIF part.type == "Roof"»
								«CustomModel_CarPark::defineCarParkRoof(part.height)»
							«ELSEIF part.type == "Floor"»
								«IF defineCMCarPark_floor»
									«defineCMCarPark_floor = false»
									«CustomModel_CarPark::defineCarParkFloor(part.height)»
								«ELSE»
									«CustomModel_CarPark::createCarParkFloor(part.height)»
								«ENDIF»								
							«ENDIF»						
						«ENDFOR»
					«ELSE»
						«FOR part : entity.getBuildingParts»
							«IF part.type == "Base"»
								«CustomModel_CarPark::createCarParkBase(part.height)»
							«ELSEIF part.type == "Roof"»
								«CustomModel_CarPark::createCarParkRoof(part.height)»
							«ELSEIF part.type == "Floor"»
								«IF defineCMCarPark_floor»
									«defineCMCarPark_floor = false»
									«CustomModel_CarPark::defineCarParkFloor(part.height)»
								«ELSE»
									«CustomModel_CarPark::createCarParkFloor(part.height)»
								«ENDIF»	
							«ENDIF»						
						«ENDFOR»
					«ENDIF»	
					</Transform>
				</Group>
            «ENDIF»
            
		«ELSEIF entity.type == "FAMIX.FunctionModule"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'
						   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
						   rotation='0 0.707107 0.707107 3.141593'>
					«IF defineCMFactoryBuildingFumo»
						«defineCMFactoryBuildingFumo = false»
						«FOR part : entity.getBuildingParts»
							«IF part.type == "Base"»
								«CustomModel_FactoryBuildingFumo::defineFactoryBuildingFumoBase(part.height)»
							«ELSEIF part.type == "Roof"»
								«CustomModel_FactoryBuildingFumo::defineFactoryBuildingFumoRoof(part.height)»
							«ELSEIF part.type == "Floor"»
								«IF defineCMFactoryBuildingFumo_floor»
									«defineCMFactoryBuildingFumo_floor = false»
									«CustomModel_FactoryBuildingFumo::defineFactoryBuildingFumoFloor(part.height)»
								«ELSE»
									«CustomModel_FactoryBuildingFumo::createFactoryBuildingFumoFloor(part.height)»
								«ENDIF»								
							«ENDIF»						
						«ENDFOR»
					«ELSE»
						«FOR part : entity.getBuildingParts»
							«IF part.type == "Base"»
								«CustomModel_FactoryBuildingFumo::createFactoryBuildingFumoBase(part.height)»
							«ELSEIF part.type == "Roof"»
								«CustomModel_FactoryBuildingFumo::createFactoryBuildingFumoRoof(part.height)»
							«ELSEIF part.type == "Floor"»
								«IF defineCMFactoryBuildingFumo_floor»
									«defineCMFactoryBuildingFumo_floor = false»
									«CustomModel_FactoryBuildingFumo::defineFactoryBuildingFumoFloor(part.height)»
								«ELSE»
									«CustomModel_FactoryBuildingFumo::createFactoryBuildingFumoFloor(part.height)»
								«ENDIF»	
							«ENDIF»						
						«ENDFOR»
					«ENDIF»	
				</Transform>
			</Group>

		«ELSEIF entity.type == "FAMIX.Report"»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'
						   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
						   rotation='0 0.707107 0.707107 3.141593'>
					«IF defineCMFactoryHall»
						«defineCMFactoryHall = false»
						«FOR part : entity.getBuildingParts»
							«IF part.type == "Base"»
								«CustomModel_FactoryHall::defineFactoryHallBase(part.height)»
							«ELSEIF part.type == "Roof"»
								«CustomModel_FactoryHall::defineFactoryHallRoof(part.height)»
							«ELSEIF part.type == "Floor"»
								«IF defineCMFactoryHall_floor»
									«defineCMFactoryHall_floor = false»
									«CustomModel_FactoryHall::defineFactoryHallFloor(part.height)»
								«ELSE»
									«CustomModel_FactoryHall::createFactoryHallFloor(part.height)»
								«ENDIF»								
							«ENDIF»						
						«ENDFOR»
					«ELSE»
						«FOR part : entity.getBuildingParts»
							«IF part.type == "Base"»
								«CustomModel_FactoryHall::createFactoryHallBase(part.height)»
							«ELSEIF part.type == "Roof"»
								«CustomModel_FactoryHall::createFactoryHallRoof(part.height)»
							«ELSEIF part.type == "Floor"»
								«IF defineCMFactoryHall_floor»
									«defineCMFactoryHall_floor = false»
									«CustomModel_FactoryHall::defineFactoryHallFloor(part.height)»
								«ELSE»
									«CustomModel_FactoryHall::createFactoryHallFloor(part.height)»
								«ENDIF»	
							«ENDIF»						
						«ENDFOR»
					«ENDIF»	
				</Transform>
			</Group>
			
		«ELSEIF entity.type == "FAMIX.Formroutine"»
			 <Group DEF='«entity.id»'>
			     <Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'
			           		scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
			           		rotation='0 0.707107 0.707107 3.141593'>
					«IF defineCMFactoryBuilding»
						«defineCMFactoryBuilding = false»
						«FOR part : entity.getBuildingParts»
							«IF part.type == "Base"»
								«CustomModel_FactoryBuilding::defineFactoryBuildingBase(part.height)»
							«ELSEIF part.type == "Roof"»
								«CustomModel_FactoryBuilding::defineFactoryBuildingRoof(part.height)»
							«ELSEIF part.type == "Floor"»
								«IF defineCMFactoryBuilding_floor»
									«defineCMFactoryBuilding_floor = false»
									«CustomModel_FactoryBuilding::defineFactoryBuildingFloor(part.height)»
								«ELSE»
									«CustomModel_FactoryBuilding::createFactoryBuildingFloor(part.height)»
								«ENDIF»								
							«ENDIF»						
						«ENDFOR»
					«ELSE»
						«FOR part : entity.getBuildingParts»
							«IF part.type == "Base"»
								«CustomModel_FactoryBuilding::createFactoryBuildingBase(part.height)»
							«ELSEIF part.type == "Roof"»
								«CustomModel_FactoryBuilding::createFactoryBuildingRoof(part.height)»
							«ELSEIF part.type == "Floor"»
								«IF defineCMFactoryBuilding_floor»
									«defineCMFactoryBuilding_floor = false»
									«CustomModel_FactoryBuilding::defineFactoryBuildingFloor(part.height)»
								«ELSE»
									«CustomModel_FactoryBuilding::createFactoryBuildingFloor(part.height)»
								«ENDIF»	
							«ENDIF»						
						«ENDFOR»
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
	
	def toFloor(BuildingSegment floor) '''
		<Group DEF='«floor.id»'>
			<Transform translation='«floor.position.x +" "+ floor.position.y +" "+ floor.position.z»'>
				<Shape>
					«toAbapFloor(floor)»
					<Appearance>
						<Material diffuseColor='«floor.color»'></Material>
					</Appearance>
				</Shape>
			</Transform>
		</Group>
	'''
	
	def toAbapFloor(BuildingSegment floor) '''
		«IF floor.parentType == "FAMIX.ABAPStruc"»
			<Cone bottomRadius='«floor.width»' height='«floor.height»'></Cone>
		«ELSEIF floor.parentType == "FAMIX.TableType"»
			<Cone bottomRadius='«floor.width»' height='«floor.height»'></Cone>
		«ELSEIF floor.parentType == "FAMIX.Table"»
			<Cylinder height='«floor.height»' radius='«floor.width»'></Cylinder>
		«ELSE»
			<Box size='«floor.width +" "+ floor.height +" "+ floor.length»'></Box>
		«ENDIF»
	'''
	
	def toChimney(BuildingSegment chimney) '''
«««	    «IF chimney.parentType == "FAMIX.Report"»
		<Group DEF='«chimney.id»'>
«««			<Transform translation='«chimney.position.x +" "+ calcChimneyPosY(chimney) +" "+ chimney.position.z»'>
			<Transform translation='«chimney.position.x +" "+ chimney.position.y * 3 +" "+ chimney.position.z»'>
				<Shape>
					<Cylinder height='«chimney.height * 2»' radius='«chimney.width»'></Cylinder>
					<Appearance>
						<Material diffuseColor='«chimney.color»'></Material>
					</Appearance>
				</Shape>
			</Transform>
		</Group>
«««		«ELSEIF chimney.parentType == "FAMIX.Interface"»
«««		<Group DEF='«chimney.id»'>
«««		«««			<Transform translation='«chimney.position.x +" "+ calcChimneyPosY(chimney) +" "+ chimney.position.z»'>
«««					<Transform translation='«chimney.position.x +" "+ chimney.position.y +" "+ chimney.position.z»'>
«««					 <Appearance>
«««						<Shape>
«««							<Material DEF="MA_Material_001"
«««							          diffuseColor="0.800 0.800 0.800"
«««							          specularColor="0.401 0.401 0.401"
«««							          emissiveColor="0.000 0.000 0.000"
«««							          ambientIntensity="0.333"
«««							          shininess="0.098"
«««							          transparency="0.0"
«««							          />
«««						</Appearance>
«««						<IndexedFaceSet solid="true"
«««						                coordIndex="0 1 2 3 -1 4 5 6 7 -1 8 9 10 11 -1 12 13 14 15 -1 16 17 18 19 -1 20 21 22 23 -1 24 25 26 27 -1 28 29 30 31 -1 32 33 34 35 -1 36 37 38 39 -1 40 41 42 43 -1 44 45 46 47 -1 48 49 50 51 -1 52 53 54 55 -1 56 57 58 59 -1 60 61 62 63 -1 64 65 66 67 -1 68 69 70 71 -1 72 73 74 75 -1 76 77 78 79 -1 80 81 82 83 -1 84 85 86 87 -1 88 89 90 91 -1 92 93 94 95 -1 96 97 98 99 -1 100 101 102 103 -1 104 105 106 107 -1 108 109 110 111 -1 112 113 114 115 -1 116 117 118 119 -1 "
«««						                >
«««							<Coordinate DEF="coords_ME_report-roof"
«««							            point="-1.000000 -6.000000 0.000000 -1.000000 -6.000000 1.000000 -1.000000 -5.000000 1.000000 -1.000000 -5.000000 0.000000 -1.000000 -5.000000 0.000000 -1.000000 -5.000000 1.000000 -1.000000 -4.000000 1.000000 -1.000000 -4.000000 0.000000 -1.000000 -4.000000 0.000000 -1.000000 -4.000000 1.000000 -1.000000 -3.000000 1.000000 -1.000000 -3.000000 0.000000 2.000000 -6.000000 0.000000 2.000000 -5.000000 0.000000 2.000000 -5.000000 1.000000 2.000000 -6.000000 1.000000 2.000000 -5.000000 0.000000 2.000000 -4.000000 0.000000 2.000000 -4.000000 1.000000 2.000000 -5.000000 1.000000 2.000000 -4.000000 0.000000 2.000000 -3.000000 0.000000 2.000000 -3.000000 1.000000 2.000000 -4.000000 1.000000 -1.000000 -6.000000 0.000000 0.000000 -6.000000 0.000000 0.000000 -6.000000 1.000000 -1.000000 -6.000000 1.000000 0.000000 -6.000000 0.000000 1.000000 -6.000000 0.000000 1.000000 -6.000000 1.000000 0.000000 -6.000000 1.000000 1.000000 -6.000000 0.000000 2.000000 -6.000000 0.000000 2.000000 -6.000000 1.000000 1.000000 -6.000000 1.000000 -1.000000 -3.000000 0.000000 -1.000000 -3.000000 1.000000 0.000000 -3.000000 1.000000 0.000000 -3.000000 0.000000 0.000000 -3.000000 0.000000 0.000000 -3.000000 1.000000 1.000000 -3.000000 1.000000 1.000000 -3.000000 0.000000 1.000000 -3.000000 0.000000 1.000000 -3.000000 1.000000 2.000000 -3.000000 1.000000 2.000000 -3.000000 0.000000 -1.000000 -6.000000 0.000000 -1.000000 -5.000000 0.000000 0.000000 -5.000000 0.000000 0.000000 -6.000000 0.000000 0.000000 -6.000000 0.000000 0.000000 -5.000000 0.000000 1.000000 -5.000000 0.000000 1.000000 -6.000000 0.000000 1.000000 -6.000000 0.000000 1.000000 -5.000000 0.000000 2.000000 -5.000000 0.000000 2.000000 -6.000000 0.000000 -1.000000 -5.000000 0.000000 -1.000000 -4.000000 0.000000 0.000000 -4.000000 0.000000 0.000000 -5.000000 0.000000 0.000000 -5.000000 0.000000 0.000000 -4.000000 0.000000 1.000000 -4.000000 0.000000 1.000000 -5.000000 0.000000 1.000000 -5.000000 0.000000 1.000000 -4.000000 0.000000 2.000000 -4.000000 0.000000 2.000000 -5.000000 0.000000 -1.000000 -4.000000 0.000000 -1.000000 -3.000000 0.000000 0.000000 -3.000000 0.000000 0.000000 -4.000000 0.000000 0.000000 -4.000000 0.000000 0.000000 -3.000000 0.000000 1.000000 -3.000000 0.000000 1.000000 -4.000000 0.000000 1.000000 -4.000000 0.000000 1.000000 -3.000000 0.000000 2.000000 -3.000000 0.000000 2.000000 -4.000000 0.000000 -1.000000 -6.000000 1.000000 0.000000 -6.000000 1.000000 0.000000 -5.000000 1.000000 -1.000000 -5.000000 1.000000 0.000000 -6.000000 1.000000 1.000000 -6.000000 1.000000 1.000000 -5.000000 1.000000 0.000000 -5.000000 1.000000 1.000000 -6.000000 1.000000 2.000000 -6.000000 1.000000 2.000000 -5.000000 1.000000 1.000000 -5.000000 1.000000 -1.000000 -5.000000 1.000000 0.000000 -5.000000 1.000000 0.000000 -4.000000 1.000000 -1.000000 -4.000000 1.000000 0.000000 -5.000000 1.000000 1.000000 -5.000000 1.000000 1.000000 -4.000000 1.000000 0.000000 -4.000000 1.000000 1.000000 -5.000000 1.000000 2.000000 -5.000000 1.000000 2.000000 -4.000000 1.000000 1.000000 -4.000000 1.000000 -1.000000 -4.000000 1.000000 0.000000 -4.000000 1.000000 0.000000 -3.000000 1.000000 -1.000000 -3.000000 1.000000 0.000000 -4.000000 1.000000 1.000000 -4.000000 1.000000 1.000000 -3.000000 1.000000 0.000000 -3.000000 1.000000 1.000000 -4.000000 1.000000 2.000000 -4.000000 1.000000 2.000000 -3.000000 1.000000 1.000000 -3.000000 1.000000 "
«««							            />
«««						</IndexedFaceSet>
«««						</Shape>
«««					</Transform>
«««				</Group>
«««	   «ENDIF»
	'''
	
		
//	def calcChimneyPosY(BuildingSegment chimney)  '''
//		«IF chimney.parentType == "FAMIX.Report"»
//		
//		«ELSEIF chimney.parentType == "FAMIX.Interface"»
//		«ENDIF»
//		var posY = 2.2
//		
//		
//		return posY
//	 '''
	def calcChimneyPosY(BuildingSegment chimney) {
		if (chimney.parentType == "FAMIX.Report") {
			var posY = chimney.position.y * 3
		
		    return posY
		} else (chimney.parentType == "FAMIX.Interface") {
//			var posY = 2.2 
		} 
//		var posY = 2.2
//		
//		return posY
	}

}