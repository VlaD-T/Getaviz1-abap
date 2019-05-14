package org.svis.generator.city.m2m.abapAdvancedModeSets

import org.svis.generator.city.m2m.customModels.*
import org.svis.xtext.city.Entity

class CustomModels implements AdvSet_Interface {
	
	override defineElements()'''
		«CustomModel_SimpleHouse::defineSimpleHouseShape»
		«CustomModel_TownHall::defineTownHallShape»
«««		«CustomModel_TownHall_VirtualDomain::defineTownHallVirtualDomainShape»
		«CustomModel_ContainerShip::defineContainerShipShape»
		«CustomModel_Boat::defineBoatShape»
		«CustomModel_ParkingSlot::defineParkingSlotShape»
		«CustomModel_Tube::defineTubeShape»
		«CustomModel_ApartmentBuilding::defineApartmentBuildingBase(0)»
		«CustomModel_ApartmentBuilding::defineApartmentBuildingFloor(0)»
		«CustomModel_ApartmentBuilding::defineApartmentBuildingRoof(0)»
		«CustomModel_SkyScraper::defineSkyScraperBase(0)»
		«CustomModel_SkyScraper::defineSkyScraperFloor(0)»
		«CustomModel_SkyScraper::defineSkyScraperRoof(0)»
		«CustomModel_RadioTower::defineRadioTowerBase(0)»
		«CustomModel_RadioTower::defineRadioTowerFloor(0)»
		«CustomModel_RadioTower::defineRadioTowerRoof(0)»
		«CustomModel_FactoryBuildingFumo::defineFactoryBuildingFumoBase(0)»
		«CustomModel_FactoryBuildingFumo::defineFactoryBuildingFumoFloor(0)»
		«CustomModel_FactoryBuildingFumo::defineFactoryBuildingFumoRoof(0)»
		«CustomModel_FactoryHall::defineFactoryHallBase(0)»
		«CustomModel_FactoryHall::defineFactoryHallFloor(0)»
		«CustomModel_FactoryHall::defineFactoryHallRoof(0)»
		«CustomModel_CarPark::defineCarParkBase(0)»
		«CustomModel_CarPark::defineCarParkFloor(0)»
		«CustomModel_CarPark::defineCarParkRoof(0)»
		«CustomModel_FactoryBuilding::defineFactoryBuildingBase(0)»
		«CustomModel_FactoryBuilding::defineFactoryBuildingFloor(0)»
		«CustomModel_FactoryBuilding::defineFactoryBuildingRoof(0)»
	'''

	override getElemFor_DataElement(Entity entity) '''
		«CustomModel_SimpleHouse::createSimpleHouseShape»
	'''

	override getElemFor_Domain(Entity entity) '''
		«CustomModel_TownHall::createTownHallShape»
	'''
	
	override getElemFor_VirtualDomain(Entity entity) '''
		«CustomModel_TownHall_VirtualDomain::defineTownHallVirtualDomainShape»
	'''
	
	override getElemFor_StrucElement(Entity entity) '''
		«FOR part : entity.getBuildingParts»
			«IF part.type == "Base"»
				«CustomModel_ApartmentBuilding::createApartmentBuildingBase(part.height)»
			«ELSEIF part.type == "Floor"»
				«CustomModel_ApartmentBuilding::createApartmentBuildingFloor(part.height)»
			«ELSEIF part.type == "Roof"»
				«CustomModel_ApartmentBuilding::createApartmentBuildingRoof(part.height)»
			«ENDIF»						
		«ENDFOR»	
	'''
	
	override getElemFor_ABAPStruc(Entity entity) '''
		«FOR part : entity.getBuildingParts»
			«IF part.type == "Base"»
				«CustomModel_ApartmentBuilding::createApartmentBuildingBase(part.height)»
			«ELSEIF part.type == "Floor"»
				«CustomModel_ApartmentBuilding::createApartmentBuildingFloor(part.height)»
			«ELSEIF part.type == "Roof"»
				«CustomModel_ApartmentBuilding::createApartmentBuildingRoof(part.height)»
			«ENDIF»						
		«ENDFOR»	
	'''
	
	override getElemFor_Table(Entity entity) '''
		«CustomModel_ContainerShip::createContainerShipShape»
	'''
	
	override getElemFor_Method(Entity entity) '''
		«FOR part : entity.getBuildingParts»
			«IF part.type == "Base"»
				«CustomModel_SkyScraper::createSkyScraperBase(part.height)»
			«ELSEIF part.type == "Floor"»
				«CustomModel_SkyScraper::createSkyScraperFloor(part.height)»
			«ELSEIF part.type == "Roof"»
				«CustomModel_SkyScraper::createSkyScraperRoof(part.height)»
			«ENDIF»						
		«ENDFOR»
	'''
	
	override getElemFor_Class(Entity entity) '''
		«FOR part : entity.getBuildingParts»
			«IF part.type == "Base"»
				«CustomModel_RadioTower::createRadioTowerBase(part.height)»
			«ELSEIF part.type == "Floor"»
				«CustomModel_RadioTower::createRadioTowerFloor(part.height)»
			«ELSEIF part.type == "Roof"»
				«CustomModel_RadioTower::createRadioTowerRoof(part.height)»
			«ENDIF»						
		«ENDFOR»
	'''
	
	override getElemFor_FunctionModule(Entity entity) '''
		«FOR part : entity.getBuildingParts»
			«IF part.type == "Base"»
				«CustomModel_FactoryBuildingFumo::createFactoryBuildingFumoBase(part.height)»
			«ELSEIF part.type == "Floor"»
				«CustomModel_FactoryBuildingFumo::createFactoryBuildingFumoFloor(part.height)»
			«ELSEIF part.type == "Roof"»
				«CustomModel_FactoryBuildingFumo::createFactoryBuildingFumoRoof(part.height)»
			«ENDIF»						
		«ENDFOR»
	'''
	
	override getElemFor_Report(Entity entity) '''
		«FOR part : entity.getBuildingParts»
			«IF part.type == "Base"»
				«CustomModel_FactoryHall::createFactoryHallBase(part.height)»
			«ELSEIF part.type == "Floor"»
				«CustomModel_FactoryHall::createFactoryHallFloor(part.height)»
			«ELSEIF part.type == "Roof"»
				«CustomModel_FactoryHall::createFactoryHallRoof(part.height)»
			«ENDIF»						
		«ENDFOR»
	'''
	
	override getElemFor_Formroutine(Entity entity) '''
		«FOR part : entity.getBuildingParts»
			«IF part.type == "Base"»
				«CustomModel_FactoryBuilding::createFactoryBuildingBase(part.height)»
			«ELSEIF part.type == "Floor"»
				«CustomModel_FactoryBuilding::createFactoryBuildingFloor(part.height)»
			«ELSEIF part.type == "Roof"»
				«CustomModel_FactoryBuilding::createFactoryBuildingRoof(part.height)»
			«ENDIF»						
		«ENDFOR»
	'''
	
	override getElemFor_TableType_ABAPStruc(Entity entity) '''
        «CustomModel_ParkingSlot::createParkingSlotShape»
	'''
	
	override getElemFor_TableType_Table(Entity entity) '''
	    «CustomModel_Boat::createBoatShape»	
	'''
	
	override getElemFor_Attribute_Class(Entity entity) '''
		«FOR part : entity.getBuildingParts»
			«IF part.type == "Base"»
				«CustomModel_CarPark::createCarParkBase(part.height)»
			«ELSEIF part.type == "Floor"»
				«CustomModel_CarPark::createCarParkFloor(part.height)»
			«ELSEIF part.type == "Roof"»
				«CustomModel_CarPark::createCarParkRoof(part.height)»
			«ENDIF»						
		«ENDFOR»	
	'''
	
	override getElemFor_Attribute_FunctionGroup(Entity entity) '''
        «CustomModel_Tube::createTubeShape»  
	'''
}