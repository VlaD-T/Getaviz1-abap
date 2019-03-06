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
«««							<Material diffuseColor='«setDistrictColor(entity.type)»' transparency='«entity.transparency»'></Material>
						«ENDIF»
					</Appearance>
				</Shape>
			</Transform>
		</Group>
	'''
	
	def String setDistrictColor(String districtType) {
		if (districtType == "domainDistrict" || districtType == "structureDistrict") {
			return CityUtils.getRGBFromHEX("#92d164")
		} else if (districtType == "classDistrict") {
			return CityUtils.getRGBFromHEX("#d7cabc")
		} else {
			return CityUtils.getRGBFromHEX("#474444")
		}
	}
	
	//Advanced ABAP buildings
	def String toBuilding(Entity entity)'''
		<Group DEF='«entity.id»'>
			<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»' 
					   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'>
					   
			«IF entity.type == "FAMIX.DataElement"»
				«IF defineCMSimpleHouse»
					«CustomModel_SimpleHouse::defineSimpleHouseShape»
					«defineCMSimpleHouse = false»
				«ELSE»
					«CustomModel_SimpleHouse::createSimpleHouseShape»
				«ENDIF»					
	
			«ELSEIF entity.type == "FAMIX.Domain"»					
				«IF defineCMTownHall»
					«CustomModel_TownHall::defineTownHallShape»
					«defineCMTownHall = false»
				«ELSE»
					«CustomModel_TownHall::createTownHallShape»
				«ENDIF»					
						
			«ELSEIF entity.type == "FAMIX.Table"»
				«IF defineCMContainerShip»
					«CustomModel_ContainerShip::defineContainerShipShape»
					«defineCMContainerShip = false»
				«ELSE»
					«CustomModel_ContainerShip::createContainerShipShape»
				«ENDIF»					
			«ELSEIF entity.type == "FAMIX.StrucElement"»
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
									
			«ELSEIF entity.type == "FAMIX.TableType"»		
			  «IF entity.rowType == "FAMIX.ABAPStruc"»
			    «IF defineCMParkingSlot»
			        «CustomModel_ParkingSlot::defineParkingSlotShape»
			        «defineCMParkingSlot = false»
			    «ELSE»
			        «CustomModel_ParkingSlot::createParkingSlotShape»
			    «ENDIF»                 
			    
			  «ELSEIF entity.rowType == "FAMIX.Table"»
			    «IF defineCMBoat»
			  	    «CustomModel_Boat::defineBoatShape»
				    «defineCMBoat = false»
			    «ELSE»
				    «CustomModel_Boat::createBoatShape»
			    «ENDIF»					
			  «ENDIF»			
		    «ELSEIF entity.type == "FAMIX.Method"»
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
	
			«ELSEIF entity.type == "FAMIX.Class"»
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
			
			«ELSEIF entity.type == "FAMIX.Attribute"»   
				«IF entity.parentType == "FAMIX.FunctionGroup"»				
	                «IF defineCMTube»
	                    «CustomModel_Tube::defineTubeShape»
	                    «defineCMTube = false»
	                «ELSE»
	                    «CustomModel_Tube::createTubeShape»
	                «ENDIF»                 		
		
				«ELSEIF entity.parentType == "FAMIX.Class"»
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
	            «ENDIF»
	            
			«ELSEIF entity.type == "FAMIX.FunctionModule"»
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
	
			«ELSEIF entity.type == "FAMIX.Report"»
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
				
			«ELSEIF entity.type == "FAMIX.Formroutine"»
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
			«ENDIF»	
				
     	</Transform>
		</Group>
	'''
		
	// Return scale for building
	def String getAdvBuildingScale(double scale)'''
		«scale + " " + scale +  " " + scale»
	'''
	
	def toChimney(BuildingSegment chimney, Entity entity) '''
       «IF entity.parentType == "FAMIX.Report"»	      		
       	    <Group DEF='«chimney.id»'>
       		    <Transform translation='«chimney.position.x +" "+ chimney.position.y +" "+ chimney.position.z»'
       		       	       scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale("FAMIX.ReportAttribute"))»'
                           rotation='0.000000 0.707107 0.707107 3.141593'>
                    <Shape>
                    	<Appearance>
                    		<Material diffuseColor="«CityUtils.getRGBFromHEX("#39434b")»" 
							          transparency="0.0"
							          />
                    	</Appearance>
                    	<IndexedFaceSet solid="true"
                    					coordIndex="0 1 2 3 -1 4 5 6 7 -1 8 9 10 11 -1 12 13 14 15 -1 16 17 18 19 -1 20 21 22 23 -1 24 25 26 27 -1 28 29 30 31 -1 32 33 34 35 -1 36 37 38 39 -1 40 41 42 43 -1 44 45 46 47 -1 48 49 50 51 -1 52 53 54 55 -1 56 57 58 59 -1 60 61 62 63 -1 64 65 66 67 -1 68 69 70 71 -1 72 73 74 75 -1 76 77 78 79 -1 80 81 82 83 -1 84 85 86 87 -1 88 89 90 91 -1 92 93 94 95 -1 96 97 98 99 -1 100 101 102 103 -1 104 105 106 107 -1 108 109 110 111 -1 112 113 114 115 -1 116 117 118 119 -1 "
                    					>
                    		<Coordinate DEF="coords_ME_report-roof"
                    					point="-1.000000 -6.000000 0.000000 -1.000000 -6.000000 1.000000 -1.000000 -5.000000 1.000000 -1.000000 -5.000000 0.000000 -1.000000 -5.000000 0.000000 -1.000000 -5.000000 1.000000 -1.000000 -4.000000 1.000000 -1.000000 -4.000000 0.000000 -1.000000 -4.000000 0.000000 -1.000000 -4.000000 1.000000 -1.000000 -3.000000 1.000000 -1.000000 -3.000000 0.000000 2.000000 -6.000000 0.000000 2.000000 -5.000000 0.000000 2.000000 -5.000000 1.000000 2.000000 -6.000000 1.000000 2.000000 -5.000000 0.000000 2.000000 -4.000000 0.000000 2.000000 -4.000000 1.000000 2.000000 -5.000000 1.000000 2.000000 -4.000000 0.000000 2.000000 -3.000000 0.000000 2.000000 -3.000000 1.000000 2.000000 -4.000000 1.000000 -1.000000 -6.000000 0.000000 0.000000 -6.000000 0.000000 0.000000 -6.000000 1.000000 -1.000000 -6.000000 1.000000 0.000000 -6.000000 0.000000 1.000000 -6.000000 0.000000 1.000000 -6.000000 1.000000 0.000000 -6.000000 1.000000 1.000000 -6.000000 0.000000 2.000000 -6.000000 0.000000 2.000000 -6.000000 1.000000 1.000000 -6.000000 1.000000 -1.000000 -3.000000 0.000000 -1.000000 -3.000000 1.000000 0.000000 -3.000000 1.000000 0.000000 -3.000000 0.000000 0.000000 -3.000000 0.000000 0.000000 -3.000000 1.000000 1.000000 -3.000000 1.000000 1.000000 -3.000000 0.000000 1.000000 -3.000000 0.000000 1.000000 -3.000000 1.000000 2.000000 -3.000000 1.000000 2.000000 -3.000000 0.000000 -1.000000 -6.000000 0.000000 -1.000000 -5.000000 0.000000 0.000000 -5.000000 0.000000 0.000000 -6.000000 0.000000 0.000000 -6.000000 0.000000 0.000000 -5.000000 0.000000 1.000000 -5.000000 0.000000 1.000000 -6.000000 0.000000 1.000000 -6.000000 0.000000 1.000000 -5.000000 0.000000 2.000000 -5.000000 0.000000 2.000000 -6.000000 0.000000 -1.000000 -5.000000 0.000000 -1.000000 -4.000000 0.000000 0.000000 -4.000000 0.000000 0.000000 -5.000000 0.000000 0.000000 -5.000000 0.000000 0.000000 -4.000000 0.000000 1.000000 -4.000000 0.000000 1.000000 -5.000000 0.000000 1.000000 -5.000000 0.000000 1.000000 -4.000000 0.000000 2.000000 -4.000000 0.000000 2.000000 -5.000000 0.000000 -1.000000 -4.000000 0.000000 -1.000000 -3.000000 0.000000 0.000000 -3.000000 0.000000 0.000000 -4.000000 0.000000 0.000000 -4.000000 0.000000 0.000000 -3.000000 0.000000 1.000000 -3.000000 0.000000 1.000000 -4.000000 0.000000 1.000000 -4.000000 0.000000 1.000000 -3.000000 0.000000 2.000000 -3.000000 0.000000 2.000000 -4.000000 0.000000 -1.000000 -6.000000 1.000000 0.000000 -6.000000 1.000000 0.000000 -5.000000 1.000000 -1.000000 -5.000000 1.000000 0.000000 -6.000000 1.000000 1.000000 -6.000000 1.000000 1.000000 -5.000000 1.000000 0.000000 -5.000000 1.000000 1.000000 -6.000000 1.000000 2.000000 -6.000000 1.000000 2.000000 -5.000000 1.000000 1.000000 -5.000000 1.000000 -1.000000 -5.000000 1.000000 0.000000 -5.000000 1.000000 0.000000 -4.000000 1.000000 -1.000000 -4.000000 1.000000 0.000000 -5.000000 1.000000 1.000000 -5.000000 1.000000 1.000000 -4.000000 1.000000 0.000000 -4.000000 1.000000 1.000000 -5.000000 1.000000 2.000000 -5.000000 1.000000 2.000000 -4.000000 1.000000 1.000000 -4.000000 1.000000 -1.000000 -4.000000 1.000000 0.000000 -4.000000 1.000000 0.000000 -3.000000 1.000000 -1.000000 -3.000000 1.000000 0.000000 -4.000000 1.000000 1.000000 -4.000000 1.000000 1.000000 -3.000000 1.000000 0.000000 -3.000000 1.000000 1.000000 -4.000000 1.000000 2.000000 -4.000000 1.000000 2.000000 -3.000000 1.000000 1.000000 -3.000000 1.000000 "
                    					/>
                    	</IndexedFaceSet>
                   </Shape>
               </Transform>
            </Group>  
     «ELSEIF entity.parentType == "FAMIX.Interface"»			 	 
		<Group DEF='«chimney.id»'>
			<Transform translation='«chimney.position.x +" "+ chimney.position.y +" "+ chimney.position.z»'
                       scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale("FAMIX.InterfaceAttribute"))»'
                       rotation='0.000000 0.707107 0.707107 3.141593'>
                    <Shape>
                    	<Appearance>
                    		<Material diffuseColor="«CityUtils.getRGBFromHEX("#39434b")»" 
							          transparency="0.0"
							          />
                    	</Appearance>
                    	<IndexedFaceSet solid="true"
						                coordIndex="0 1 2 3 -1 4 5 6 7 -1 8 9 10 11 -1 12 13 14 15 -1 16 17 18 19 -1 20 21 22 23 -1 24 25 26 27 -1 28 29 30 31 -1 32 33 34 35 -1 36 37 38 39 -1 40 41 42 43 -1 44 45 46 47 -1 48 49 50 51 -1 52 53 54 55 -1 56 57 58 59 -1 60 61 62 63 -1 64 65 66 67 -1 68 69 70 71 -1 72 73 74 75 -1 76 77 78 79 -1 80 81 82 83 -1 84 85 86 87 -1 88 89 90 91 -1 92 93 94 95 -1 96 97 98 99 -1 100 101 102 103 -1 104 105 106 107 -1 108 109 110 111 -1 112 113 114 115 -1 116 117 118 119 -1 120 121 122 123 -1 124 125 126 127 -1 128 129 130 131 -1 132 133 134 135 -1 136 137 138 139 -1 140 141 142 143 -1 144 145 146 147 -1 148 149 150 151 -1 152 153 154 155 -1 156 157 158 159 -1 160 161 162 163 -1 164 165 166 167 -1 168 169 170 171 -1 172 173 174 175 -1 176 177 178 179 -1 180 181 182 183 -1 184 185 186 187 -1 188 189 190 191 -1 192 193 194 195 -1 196 197 198 199 -1 "
						                >
                    		<Coordinate DEF="coords_ME_roof-antenna"
							            point="-1.000000 0.000000 0.000000 -1.000000 0.000000 1.000000 -1.000000 1.000000 1.000000 -1.000000 1.000000 0.000000 -1.000000 -1.000000 0.000000 -1.000000 -1.000000 1.000000 -1.000000 0.000000 1.000000 -1.000000 0.000000 0.000000 -1.000000 1.000000 0.000000 -1.000000 1.000000 1.000000 -1.000000 2.000000 1.000000 -1.000000 2.000000 0.000000 0.000000 0.000000 1.000000 0.000000 0.000000 2.000000 0.000000 1.000000 2.000000 0.000000 1.000000 1.000000 0.000000 0.000000 2.000000 0.000000 0.000000 3.000000 0.000000 1.000000 3.000000 0.000000 1.000000 2.000000 0.000000 0.000000 3.000000 0.000000 0.000000 4.000000 0.000000 1.000000 4.000000 0.000000 1.000000 3.000000 0.000000 0.000000 4.000000 0.000000 0.000000 5.000000 0.000000 1.000000 5.000000 0.000000 1.000000 4.000000 0.000000 0.000000 5.000000 0.000000 0.000000 6.000000 0.000000 1.000000 6.000000 0.000000 1.000000 5.000000 2.000000 1.000000 0.000000 2.000000 2.000000 0.000000 2.000000 2.000000 1.000000 2.000000 1.000000 1.000000 2.000000 0.000000 0.000000 2.000000 1.000000 0.000000 2.000000 1.000000 1.000000 2.000000 0.000000 1.000000 2.000000 -1.000000 0.000000 2.000000 0.000000 0.000000 2.000000 0.000000 1.000000 2.000000 -1.000000 1.000000 1.000000 0.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 2.000000 1.000000 0.000000 2.000000 1.000000 0.000000 2.000000 1.000000 1.000000 2.000000 1.000000 1.000000 3.000000 1.000000 0.000000 3.000000 1.000000 0.000000 3.000000 1.000000 1.000000 3.000000 1.000000 1.000000 4.000000 1.000000 0.000000 4.000000 1.000000 0.000000 4.000000 1.000000 1.000000 4.000000 1.000000 1.000000 5.000000 1.000000 0.000000 5.000000 1.000000 0.000000 5.000000 1.000000 1.000000 5.000000 1.000000 1.000000 6.000000 1.000000 0.000000 6.000000 0.000000 -1.000000 0.000000 1.000000 -1.000000 0.000000 1.000000 -1.000000 1.000000 0.000000 -1.000000 1.000000 -1.000000 -1.000000 0.000000 0.000000 -1.000000 0.000000 0.000000 -1.000000 1.000000 -1.000000 -1.000000 1.000000 1.000000 -1.000000 0.000000 2.000000 -1.000000 0.000000 2.000000 -1.000000 1.000000 1.000000 -1.000000 1.000000 0.000000 0.000000 1.000000 1.000000 0.000000 1.000000 1.000000 0.000000 2.000000 0.000000 0.000000 2.000000 0.000000 0.000000 2.000000 1.000000 0.000000 2.000000 1.000000 0.000000 3.000000 0.000000 0.000000 3.000000 0.000000 0.000000 3.000000 1.000000 0.000000 3.000000 1.000000 0.000000 4.000000 0.000000 0.000000 4.000000 0.000000 0.000000 4.000000 1.000000 0.000000 4.000000 1.000000 0.000000 5.000000 0.000000 0.000000 5.000000 0.000000 0.000000 5.000000 1.000000 0.000000 5.000000 1.000000 0.000000 6.000000 0.000000 0.000000 6.000000 -1.000000 2.000000 0.000000 -1.000000 2.000000 1.000000 0.000000 2.000000 1.000000 0.000000 2.000000 0.000000 0.000000 2.000000 0.000000 0.000000 2.000000 1.000000 1.000000 2.000000 1.000000 1.000000 2.000000 0.000000 1.000000 2.000000 0.000000 1.000000 2.000000 1.000000 2.000000 2.000000 1.000000 2.000000 2.000000 0.000000 0.000000 1.000000 1.000000 0.000000 1.000000 2.000000 1.000000 1.000000 2.000000 1.000000 1.000000 1.000000 0.000000 1.000000 2.000000 0.000000 1.000000 3.000000 1.000000 1.000000 3.000000 1.000000 1.000000 2.000000 0.000000 1.000000 3.000000 0.000000 1.000000 4.000000 1.000000 1.000000 4.000000 1.000000 1.000000 3.000000 0.000000 1.000000 4.000000 0.000000 1.000000 5.000000 1.000000 1.000000 5.000000 1.000000 1.000000 4.000000 0.000000 1.000000 5.000000 0.000000 1.000000 6.000000 1.000000 1.000000 6.000000 1.000000 1.000000 5.000000 0.000000 -1.000000 0.000000 0.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 -1.000000 0.000000 0.000000 0.000000 0.000000 0.000000 1.000000 0.000000 1.000000 1.000000 0.000000 1.000000 0.000000 0.000000 -1.000000 0.000000 0.000000 -1.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 0.000000 0.000000 -1.000000 -1.000000 0.000000 -1.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 -1.000000 0.000000 -1.000000 1.000000 0.000000 -1.000000 2.000000 0.000000 0.000000 2.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 2.000000 0.000000 1.000000 2.000000 0.000000 1.000000 1.000000 0.000000 1.000000 1.000000 0.000000 1.000000 2.000000 0.000000 2.000000 2.000000 0.000000 2.000000 1.000000 0.000000 1.000000 0.000000 0.000000 1.000000 1.000000 0.000000 2.000000 1.000000 0.000000 2.000000 0.000000 0.000000 1.000000 -1.000000 0.000000 1.000000 0.000000 0.000000 2.000000 0.000000 0.000000 2.000000 -1.000000 0.000000 0.000000 -1.000000 1.000000 1.000000 -1.000000 1.000000 1.000000 0.000000 1.000000 0.000000 0.000000 1.000000 -1.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 1.000000 1.000000 -1.000000 1.000000 1.000000 -1.000000 -1.000000 1.000000 0.000000 -1.000000 1.000000 0.000000 0.000000 1.000000 -1.000000 0.000000 1.000000 -1.000000 1.000000 1.000000 0.000000 1.000000 1.000000 0.000000 2.000000 1.000000 -1.000000 2.000000 1.000000 0.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 2.000000 1.000000 0.000000 2.000000 1.000000 1.000000 1.000000 1.000000 2.000000 1.000000 1.000000 2.000000 2.000000 1.000000 1.000000 2.000000 1.000000 1.000000 0.000000 1.000000 2.000000 0.000000 1.000000 2.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 -1.000000 1.000000 2.000000 -1.000000 1.000000 2.000000 0.000000 1.000000 1.000000 0.000000 1.000000 0.000000 0.000000 6.000000 1.000000 0.000000 6.000000 1.000000 1.000000 6.000000 0.000000 1.000000 6.000000 "
							            />
                    	</IndexedFaceSet>
                    </Shape>                
                </Transform>
            </Group>   
                 
      «ELSEIF entity.parentType == "FAMIX.Table"»			 	 
        <Group DEF='«chimney.id»'>
  			<Transform translation='«chimney.position.x +" "+ chimney.position.y +" "+ chimney.position.z»'
                       scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale("FAMIX.TableElement"))»'
                       rotation='0.000000 0.707107 0.707107 3.141593'>
                    <Shape>
                      	<Appearance>
                      		<Material diffuseColor="«CityUtils.getRGBFromHEX("#39434b")»" 
  							          transparency="0.0"
  							          />
                      	</Appearance>
                      	<IndexedFaceSet solid="true"
						                coordIndex="0 1 2 3 -1 4 5 6 7 -1 8 9 10 11 -1 12 13 14 15 -1 16 17 18 19 -1 20 21 22 23 -1 24 25 26 27 -1 28 29 30 31 -1 32 33 34 35 -1 36 37 38 39 -1 40 41 42 43 -1 44 45 46 47 -1 48 49 50 51 -1 52 53 54 55 -1 56 57 58 59 -1 60 61 62 63 -1 64 65 66 67 -1 68 69 70 71 -1 72 73 74 75 -1 76 77 78 79 -1 80 81 82 83 -1 84 85 86 87 -1 88 89 90 91 -1 92 93 94 95 -1 96 97 98 99 -1 100 101 102 103 -1 104 105 106 107 -1 108 109 110 111 -1 112 113 114 115 -1 116 117 118 119 -1 120 121 122 123 -1 124 125 126 127 -1 128 129 130 131 -1 132 133 134 135 -1 136 137 138 139 -1 140 141 142 143 -1 144 145 146 147 -1 148 149 150 151 -1 152 153 154 155 -1 156 157 158 159 -1 160 161 162 163 -1 164 165 166 167 -1 168 169 170 171 -1 172 173 174 175 -1 176 177 178 179 -1 180 181 182 183 -1 184 185 186 187 -1 188 189 190 191 -1 192 193 194 195 -1 196 197 198 199 -1 200 201 202 203 -1 204 205 206 207 -1 208 209 210 211 -1 212 213 214 215 -1 216 217 218 219 -1 220 221 222 223 -1 224 225 226 227 -1 228 229 230 231 -1 232 233 234 235 -1 236 237 238 239 -1 240 241 242 243 -1 244 245 246 247 -1 248 249 250 251 -1 252 253 254 255 -1 256 257 258 259 -1 260 261 262 263 -1 264 265 266 267 -1 268 269 270 271 -1 272 273 274 275 -1 276 277 278 279 -1 280 281 282 283 -1 284 285 286 287 -1 288 289 290 291 -1 292 293 294 295 -1 296 297 298 299 -1 300 301 302 303 -1 304 305 306 307 -1 308 309 310 311 -1 312 313 314 315 -1 316 317 318 319 -1 320 321 322 323 -1 324 325 326 327 -1 328 329 330 331 -1 332 333 334 335 -1 336 337 338 339 -1 340 341 342 343 -1 344 345 346 347 -1 348 349 350 351 -1 352 353 354 355 -1 356 357 358 359 -1 360 361 362 363 -1 364 365 366 367 -1 368 369 370 371 -1 372 373 374 375 -1 376 377 378 379 -1 380 381 382 383 -1 384 385 386 387 -1 388 389 390 391 -1 392 393 394 395 -1 396 397 398 399 -1 400 401 402 403 -1 404 405 406 407 -1 "
						                >
							<Coordinate DEF="coords_ME_container"
							            point="-4.000000 1.000000 0.000000 -4.000000 1.000000 1.000000 -4.000000 2.000000 1.000000 -4.000000 2.000000 0.000000 -4.000000 2.000000 0.000000 -4.000000 2.000000 1.000000 -4.000000 3.000000 1.000000 -4.000000 3.000000 0.000000 -4.000000 3.000000 0.000000 -4.000000 3.000000 1.000000 -4.000000 4.000000 1.000000 -4.000000 4.000000 0.000000 -4.000000 1.000000 1.000000 -4.000000 1.000000 2.000000 -4.000000 2.000000 2.000000 -4.000000 2.000000 1.000000 -4.000000 2.000000 1.000000 -4.000000 2.000000 2.000000 -4.000000 3.000000 2.000000 -4.000000 3.000000 1.000000 -4.000000 3.000000 1.000000 -4.000000 3.000000 2.000000 -4.000000 4.000000 2.000000 -4.000000 4.000000 1.000000 -4.000000 1.000000 2.000000 -4.000000 1.000000 3.000000 -4.000000 2.000000 3.000000 -4.000000 2.000000 2.000000 -4.000000 2.000000 2.000000 -4.000000 2.000000 3.000000 -4.000000 3.000000 3.000000 -4.000000 3.000000 2.000000 -4.000000 3.000000 2.000000 -4.000000 3.000000 3.000000 -4.000000 4.000000 3.000000 -4.000000 4.000000 2.000000 3.000000 1.000000 0.000000 3.000000 2.000000 0.000000 3.000000 2.000000 1.000000 3.000000 1.000000 1.000000 3.000000 2.000000 0.000000 3.000000 3.000000 0.000000 3.000000 3.000000 1.000000 3.000000 2.000000 1.000000 3.000000 3.000000 0.000000 3.000000 4.000000 0.000000 3.000000 4.000000 1.000000 3.000000 3.000000 1.000000 3.000000 1.000000 1.000000 3.000000 2.000000 1.000000 3.000000 2.000000 2.000000 3.000000 1.000000 2.000000 3.000000 2.000000 1.000000 3.000000 3.000000 1.000000 3.000000 3.000000 2.000000 3.000000 2.000000 2.000000 3.000000 3.000000 1.000000 3.000000 4.000000 1.000000 3.000000 4.000000 2.000000 3.000000 3.000000 2.000000 3.000000 1.000000 2.000000 3.000000 2.000000 2.000000 3.000000 2.000000 3.000000 3.000000 1.000000 3.000000 3.000000 2.000000 2.000000 3.000000 3.000000 2.000000 3.000000 3.000000 3.000000 3.000000 2.000000 3.000000 3.000000 3.000000 2.000000 3.000000 4.000000 2.000000 3.000000 4.000000 3.000000 3.000000 3.000000 3.000000 -4.000000 1.000000 0.000000 -3.000000 1.000000 0.000000 -3.000000 1.000000 1.000000 -4.000000 1.000000 1.000000 -3.000000 1.000000 0.000000 -2.000000 1.000000 0.000000 -2.000000 1.000000 1.000000 -3.000000 1.000000 1.000000 -2.000000 1.000000 0.000000 -1.000000 1.000000 0.000000 -1.000000 1.000000 1.000000 -2.000000 1.000000 1.000000 -1.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 1.000000 -1.000000 1.000000 1.000000 0.000000 1.000000 0.000000 1.000000 1.000000 0.000000 1.000000 1.000000 1.000000 0.000000 1.000000 1.000000 1.000000 1.000000 0.000000 2.000000 1.000000 0.000000 2.000000 1.000000 1.000000 1.000000 1.000000 1.000000 2.000000 1.000000 0.000000 3.000000 1.000000 0.000000 3.000000 1.000000 1.000000 2.000000 1.000000 1.000000 -4.000000 1.000000 1.000000 -3.000000 1.000000 1.000000 -3.000000 1.000000 2.000000 -4.000000 1.000000 2.000000 -3.000000 1.000000 1.000000 -2.000000 1.000000 1.000000 -2.000000 1.000000 2.000000 -3.000000 1.000000 2.000000 -2.000000 1.000000 1.000000 -1.000000 1.000000 1.000000 -1.000000 1.000000 2.000000 -2.000000 1.000000 2.000000 -1.000000 1.000000 1.000000 0.000000 1.000000 1.000000 0.000000 1.000000 2.000000 -1.000000 1.000000 2.000000 0.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 2.000000 0.000000 1.000000 2.000000 1.000000 1.000000 1.000000 2.000000 1.000000 1.000000 2.000000 1.000000 2.000000 1.000000 1.000000 2.000000 2.000000 1.000000 1.000000 3.000000 1.000000 1.000000 3.000000 1.000000 2.000000 2.000000 1.000000 2.000000 -4.000000 1.000000 2.000000 -3.000000 1.000000 2.000000 -3.000000 1.000000 3.000000 -4.000000 1.000000 3.000000 -3.000000 1.000000 2.000000 -2.000000 1.000000 2.000000 -2.000000 1.000000 3.000000 -3.000000 1.000000 3.000000 -2.000000 1.000000 2.000000 -1.000000 1.000000 2.000000 -1.000000 1.000000 3.000000 -2.000000 1.000000 3.000000 -1.000000 1.000000 2.000000 0.000000 1.000000 2.000000 0.000000 1.000000 3.000000 -1.000000 1.000000 3.000000 0.000000 1.000000 2.000000 1.000000 1.000000 2.000000 1.000000 1.000000 3.000000 0.000000 1.000000 3.000000 1.000000 1.000000 2.000000 2.000000 1.000000 2.000000 2.000000 1.000000 3.000000 1.000000 1.000000 3.000000 2.000000 1.000000 2.000000 3.000000 1.000000 2.000000 3.000000 1.000000 3.000000 2.000000 1.000000 3.000000 -4.000000 4.000000 0.000000 -4.000000 4.000000 1.000000 -3.000000 4.000000 1.000000 -3.000000 4.000000 0.000000 -3.000000 4.000000 0.000000 -3.000000 4.000000 1.000000 -2.000000 4.000000 1.000000 -2.000000 4.000000 0.000000 -2.000000 4.000000 0.000000 -2.000000 4.000000 1.000000 -1.000000 4.000000 1.000000 -1.000000 4.000000 0.000000 -1.000000 4.000000 0.000000 -1.000000 4.000000 1.000000 0.000000 4.000000 1.000000 0.000000 4.000000 0.000000 0.000000 4.000000 0.000000 0.000000 4.000000 1.000000 1.000000 4.000000 1.000000 1.000000 4.000000 0.000000 1.000000 4.000000 0.000000 1.000000 4.000000 1.000000 2.000000 4.000000 1.000000 2.000000 4.000000 0.000000 2.000000 4.000000 0.000000 2.000000 4.000000 1.000000 3.000000 4.000000 1.000000 3.000000 4.000000 0.000000 -4.000000 4.000000 1.000000 -4.000000 4.000000 2.000000 -3.000000 4.000000 2.000000 -3.000000 4.000000 1.000000 -3.000000 4.000000 1.000000 -3.000000 4.000000 2.000000 -2.000000 4.000000 2.000000 -2.000000 4.000000 1.000000 -2.000000 4.000000 1.000000 -2.000000 4.000000 2.000000 -1.000000 4.000000 2.000000 -1.000000 4.000000 1.000000 -1.000000 4.000000 1.000000 -1.000000 4.000000 2.000000 0.000000 4.000000 2.000000 0.000000 4.000000 1.000000 0.000000 4.000000 1.000000 0.000000 4.000000 2.000000 1.000000 4.000000 2.000000 1.000000 4.000000 1.000000 1.000000 4.000000 1.000000 1.000000 4.000000 2.000000 2.000000 4.000000 2.000000 2.000000 4.000000 1.000000 2.000000 4.000000 1.000000 2.000000 4.000000 2.000000 3.000000 4.000000 2.000000 3.000000 4.000000 1.000000 -4.000000 4.000000 2.000000 -4.000000 4.000000 3.000000 -3.000000 4.000000 3.000000 -3.000000 4.000000 2.000000 -3.000000 4.000000 2.000000 -3.000000 4.000000 3.000000 -2.000000 4.000000 3.000000 -2.000000 4.000000 2.000000 -2.000000 4.000000 2.000000 -2.000000 4.000000 3.000000 -1.000000 4.000000 3.000000 -1.000000 4.000000 2.000000 -1.000000 4.000000 2.000000 -1.000000 4.000000 3.000000 0.000000 4.000000 3.000000 0.000000 4.000000 2.000000 0.000000 4.000000 2.000000 0.000000 4.000000 3.000000 1.000000 4.000000 3.000000 1.000000 4.000000 2.000000 1.000000 4.000000 2.000000 1.000000 4.000000 3.000000 2.000000 4.000000 3.000000 2.000000 4.000000 2.000000 2.000000 4.000000 2.000000 2.000000 4.000000 3.000000 3.000000 4.000000 3.000000 3.000000 4.000000 2.000000 -4.000000 1.000000 0.000000 -4.000000 2.000000 0.000000 -3.000000 2.000000 0.000000 -3.000000 1.000000 0.000000 -3.000000 1.000000 0.000000 -3.000000 2.000000 0.000000 -2.000000 2.000000 0.000000 -2.000000 1.000000 0.000000 -2.000000 1.000000 0.000000 -2.000000 2.000000 0.000000 -1.000000 2.000000 0.000000 -1.000000 1.000000 0.000000 -1.000000 1.000000 0.000000 -1.000000 2.000000 0.000000 0.000000 2.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 2.000000 0.000000 1.000000 2.000000 0.000000 1.000000 1.000000 0.000000 1.000000 1.000000 0.000000 1.000000 2.000000 0.000000 2.000000 2.000000 0.000000 2.000000 1.000000 0.000000 2.000000 1.000000 0.000000 2.000000 2.000000 0.000000 3.000000 2.000000 0.000000 3.000000 1.000000 0.000000 -4.000000 2.000000 0.000000 -4.000000 3.000000 0.000000 -3.000000 3.000000 0.000000 -3.000000 2.000000 0.000000 -3.000000 2.000000 0.000000 -3.000000 3.000000 0.000000 -2.000000 3.000000 0.000000 -2.000000 2.000000 0.000000 -2.000000 2.000000 0.000000 -2.000000 3.000000 0.000000 -1.000000 3.000000 0.000000 -1.000000 2.000000 0.000000 -1.000000 2.000000 0.000000 -1.000000 3.000000 0.000000 0.000000 3.000000 0.000000 0.000000 2.000000 0.000000 0.000000 2.000000 0.000000 0.000000 3.000000 0.000000 1.000000 3.000000 0.000000 1.000000 2.000000 0.000000 1.000000 2.000000 0.000000 1.000000 3.000000 0.000000 2.000000 3.000000 0.000000 2.000000 2.000000 0.000000 2.000000 2.000000 0.000000 2.000000 3.000000 0.000000 3.000000 3.000000 0.000000 3.000000 2.000000 0.000000 -4.000000 3.000000 0.000000 -4.000000 4.000000 0.000000 -3.000000 4.000000 0.000000 -3.000000 3.000000 0.000000 -3.000000 3.000000 0.000000 -3.000000 4.000000 0.000000 -2.000000 4.000000 0.000000 -2.000000 3.000000 0.000000 -2.000000 3.000000 0.000000 -2.000000 4.000000 0.000000 -1.000000 4.000000 0.000000 -1.000000 3.000000 0.000000 -1.000000 3.000000 0.000000 -1.000000 4.000000 0.000000 0.000000 4.000000 0.000000 0.000000 3.000000 0.000000 0.000000 3.000000 0.000000 0.000000 4.000000 0.000000 1.000000 4.000000 0.000000 1.000000 3.000000 0.000000 1.000000 3.000000 0.000000 1.000000 4.000000 0.000000 2.000000 4.000000 0.000000 2.000000 3.000000 0.000000 2.000000 3.000000 0.000000 2.000000 4.000000 0.000000 3.000000 4.000000 0.000000 3.000000 3.000000 0.000000 -4.000000 1.000000 3.000000 -3.000000 1.000000 3.000000 -3.000000 2.000000 3.000000 -4.000000 2.000000 3.000000 -3.000000 1.000000 3.000000 -2.000000 1.000000 3.000000 -2.000000 2.000000 3.000000 -3.000000 2.000000 3.000000 -2.000000 1.000000 3.000000 -1.000000 1.000000 3.000000 -1.000000 2.000000 3.000000 -2.000000 2.000000 3.000000 -1.000000 1.000000 3.000000 0.000000 1.000000 3.000000 0.000000 2.000000 3.000000 -1.000000 2.000000 3.000000 0.000000 1.000000 3.000000 1.000000 1.000000 3.000000 1.000000 2.000000 3.000000 0.000000 2.000000 3.000000 1.000000 1.000000 3.000000 2.000000 1.000000 3.000000 2.000000 2.000000 3.000000 1.000000 2.000000 3.000000 2.000000 1.000000 3.000000 3.000000 1.000000 3.000000 3.000000 2.000000 3.000000 2.000000 2.000000 3.000000 -4.000000 2.000000 3.000000 -3.000000 2.000000 3.000000 -3.000000 3.000000 3.000000 -4.000000 3.000000 3.000000 -3.000000 2.000000 3.000000 -2.000000 2.000000 3.000000 -2.000000 3.000000 3.000000 -3.000000 3.000000 3.000000 -2.000000 2.000000 3.000000 -1.000000 2.000000 3.000000 -1.000000 3.000000 3.000000 -2.000000 3.000000 3.000000 -1.000000 2.000000 3.000000 0.000000 2.000000 3.000000 0.000000 3.000000 3.000000 -1.000000 3.000000 3.000000 0.000000 2.000000 3.000000 1.000000 2.000000 3.000000 1.000000 3.000000 3.000000 0.000000 3.000000 3.000000 1.000000 2.000000 3.000000 2.000000 2.000000 3.000000 2.000000 3.000000 3.000000 1.000000 3.000000 3.000000 2.000000 2.000000 3.000000 3.000000 2.000000 3.000000 3.000000 3.000000 3.000000 2.000000 3.000000 3.000000 -4.000000 3.000000 3.000000 -3.000000 3.000000 3.000000 -3.000000 4.000000 3.000000 -4.000000 4.000000 3.000000 -3.000000 3.000000 3.000000 -2.000000 3.000000 3.000000 -2.000000 4.000000 3.000000 -3.000000 4.000000 3.000000 -2.000000 3.000000 3.000000 -1.000000 3.000000 3.000000 -1.000000 4.000000 3.000000 -2.000000 4.000000 3.000000 -1.000000 3.000000 3.000000 0.000000 3.000000 3.000000 0.000000 4.000000 3.000000 -1.000000 4.000000 3.000000 0.000000 3.000000 3.000000 1.000000 3.000000 3.000000 1.000000 4.000000 3.000000 0.000000 4.000000 3.000000 1.000000 3.000000 3.000000 2.000000 3.000000 3.000000 2.000000 4.000000 3.000000 1.000000 4.000000 3.000000 2.000000 3.000000 3.000000 3.000000 3.000000 3.000000 3.000000 4.000000 3.000000 2.000000 4.000000 3.000000 "
							            />
                      	</IndexedFaceSet>
                     </Shape>                
                  </Transform>
              </Group>                     
	«ENDIF»
'''	

}