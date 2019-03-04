package org.svis.generator.city.m2m.abapAdvancedModeSets

import org.svis.generator.city.m2m.abapAdvancedModeSets.SetsClassMethods
import org.svis.generator.city.m2m.customModels.*
import org.svis.xtext.city.Entity

class CustomModels extends SetsClassMethods {
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
	
//	override getElemFor_DataElement(Entity entity) '''
//		«IF defineCMSimpleHouse»
//			«CustomModel_SimpleHouse::defineSimpleHouseShape»
//			«defineCMSimpleHouse = false»
//		«ELSE»
//			«CustomModel_SimpleHouse::createSimpleHouseShape»
//		«ENDIF»	
//	'''

	override getElemFor_DataElement(Entity entity) {
		if (defineCMSimpleHouse) {
			defineCMSimpleHouse = false
			CustomModel_SimpleHouse.defineSimpleHouseShape().toString			
		} else {
			CustomModel_SimpleHouse.createSimpleHouseShape().toString
		}
	}
	
	override getElemFor_Domain(Entity entity) '''
		«IF defineCMTownHall»
			«CustomModel_TownHall::defineTownHallShape»
			«defineCMTownHall = false»
		«ELSE»
			«CustomModel_TownHall::createTownHallShape»
		«ENDIF»	
	'''
	
	override getElemFor_StrucElement(Entity entity) '''
		«IF defineCMApartmentBuilding»
			«(defineCMApartmentBuilding = false)»
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
	'''
	
	override getElemFor_Table(Entity entity) '''
		«IF defineCMContainerShip»
			«CustomModel_ContainerShip::defineContainerShipShape»
			«defineCMContainerShip = false»
		«ELSE»
			«CustomModel_ContainerShip::createContainerShipShape»
		«ENDIF»	
	'''
	
	override getElemFor_Method(Entity entity) '''
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
	'''
	
	override getElemFor_Class(Entity entity) '''
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
	'''
	
	override getElemFor_FunctionModule(Entity entity) '''
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
	'''
	
	override getElemFor_Report(Entity entity) '''
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
	'''
	
	override getElemFor_Formroutine(Entity entity) '''
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
	'''
	
	override getElemFor_TableType_ABAPStruc(Entity entity) '''
		«IF defineCMParkingSlot»
	        «CustomModel_ParkingSlot::defineParkingSlotShape»
	        «defineCMParkingSlot = false»
	    «ELSE»
	        «CustomModel_ParkingSlot::createParkingSlotShape»
	    «ENDIF»   
	'''
	
	override getElemFor_TableType_Table(Entity entity) '''
		«IF defineCMBoat»
	  	    «CustomModel_Boat::defineBoatShape»
		    «defineCMBoat = false»
	    «ELSE»
		    «CustomModel_Boat::createBoatShape»
	    «ENDIF»		
	'''
	
	override getElemFor_Attribute_Class(Entity entity) '''
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
	'''
	
	override getElemFor_Attribute_FunctionGroup(Entity entity) '''
		«IF defineCMTube»
	        «CustomModel_Tube::defineTubeShape»
	        «defineCMTube = false»
	    «ELSE»
	        «CustomModel_Tube::createTubeShape»
	    «ENDIF»   
	'''
}