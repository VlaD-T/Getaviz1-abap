package org.svis.generator.city.m2t;

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
import org.svis.generator.SettingsConfiguration.FamixParser
import org.svis.generator.SettingsConfiguration.AbapCityRepresentation
import org.svis.generator.city.m2m.customModels.*

class City2X3D {

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

	def toX3DBody(Resource resource) {
		log.info("City2X3D has started.")
		val entities = EcoreUtil2::getAllContentsOfType(resource.contents.head, Entity)
		var rootEntity = CityLayout::rootRectangle
		if (config.parser == FamixParser::ABAP && config.abap_representation == AbapCityRepresentation::ADVANCED) {
			rootEntity = ABAPCityLayout::rootRectangle // CityLayout::rootRectangle
		}
		
		val Body = viewports(rootEntity) + entities.toX3DModel()
		log.info("City2X3D has finished.")
		return Body
	}

	def String settingsInfo() '''
		<SettingsInfo ClassElements='«config.classElementsMode»' SortModeCoarse='«config.classElementsSortModeCoarse»' SortModeFine='«config.classElementsSortModeFine»' SortModeFineReversed='«config.classElementsSortModeFineDirectionReversed»' Scheme='«config.scheme»' ShowBuildingBase='«config.showBuildingBase»'
		«IF config.buildingType == BuildingType.CITY_BRICKS»
			BrickLayout='«config.brickLayout»'
		«ELSEIF config.buildingType == BuildingType.CITY_PANELS»
			AttributesAsCylinders='«config.showAttributesAsCylinders»' PanelSeparatorMode='«config.panelSeparatorMode»'
		«ELSE»
		«ENDIF»
		/>
	'''

	def String viewports(Rectangle rootEntity) '''
		«var width = rootEntity.width»
		«var length = rootEntity.length»
		<Group DEF='Viewpoints'>
			<Viewpoint description='Initial' position='«-width*0.5 +" "+ ((width+length)/2)*0.25 +" "+ -length*0.5»' orientation='0 1 0 4' centerOfRotation='«width/2 +" 0 "+ length/2»'/>
			<Viewpoint description='Opposite Side' position='«width*1.5 +" "+ ((width+length)/2)*0.25 +" "+ length*1.5»' orientation='0 1 0 0.8' centerOfRotation='«width/2 +" 0 "+ length/2»'/>
			<Viewpoint description='Screenshot' position='«-width*0.5 +" "+ ((width+length)/2)*0.75 +" "+ -length*0.5»' orientation='0.1 0.95 0.25 3.8' centerOfRotation='«width/2 +" 0 "+ length/2»'/>
			<Viewpoint description='Screenshot Opposite Side' position='«width*1.5 +" "+ ((width+length)/2)*0.75 +" "+ length*1.5»' orientation='-0.5 0.85 0.2 0.8' centerOfRotation='«width/2 +" 0 "+ length/2»'/>
		</Group>
	'''	
	
	// transform logic
	def String toX3DModel(List<Entity> entities) '''
  		«FOR entity : entities»
			«IF entity.type == "FAMIX.Namespace"  || entity.type == "reportDistrict"
				|| entity.type == "classDistrict" || entity.type == "functionGroupDistrict" 
				|| entity.type == "tableDistrict" || entity.type == "dcDataDistrict"
				|| entity.type == "domainDistrict" || entity.type == "structureDistrict"»
				«toDistrict(entity)»
			«ENDIF»
			«IF entity.type == "FAMIX.Class" || entity.type == "FAMIX.Interface"|| entity.type == "FAMIX.DataElement" 
				|| entity.type == "FAMIX.Report" || entity.type == "FAMIX.FunctionGroup" 
				|| entity.type == "FAMIX.ABAPStruc"	|| entity.type == "FAMIX.StrucElement" 
				|| entity.type == "FAMIX.Table" 
				|| entity.type == "FAMIX.Domain" || entity.type == "FAMIX.TableType"
				|| entity.type == "FAMIX.Method" || entity.type == "FAMIX.Attribute" || entity.type == "typeNames" 
				|| entity.type == "FAMIX.FunctionModule" || entity.type == "FAMIX.Formroutine"»
				«IF config.buildingType == BuildingType.CITY_ORIGINAL || config.showBuildingBase»
					«toBuilding(entity)»
				«ENDIF»
				«IF config.buildingType === BuildingType.CITY_DYNAMIC»
					«FOR bs: (entity as District).entities»
						«toBuilding(bs)»
					«ENDFOR»
«««					«FOR bs: (entity as Building).data»
«««						«toBuilding(bs)»
«««					«ENDFOR»
				«ENDIF»
				«IF(config.buildingType == BuildingType::CITY_FLOOR)»
					«FOR floor: (entity as Building).methods»
						«toFloor(floor)»
					«ENDFOR»	
					«FOR chimney: (entity as Building).data»
						«toChimney(chimney)»
					«ENDFOR»
				«ENDIF»	
				«IF(config.buildingType == BuildingType::CITY_BRICKS || config.buildingType == BuildingType::CITY_PANELS)»
					«FOR bs: (entity as Building).methods»
						«toBuildingSegment(bs)»
					«ENDFOR»
					«FOR bs: (entity as Building).data»
						«toBuildingSegment(bs)»
					«ENDFOR»
				«ENDIF»
			«ENDIF»
		«ENDFOR»
	'''

	def String toDistrict(Entity entity) '''
		<Group DEF='«entity.id»'>
			<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'>
				«IF (config.parser == FamixParser::ABAP)»
					«toAbapDistrict(entity)»
				«ELSE»
					<Shape>
						<Box size='«entity.width +" "+ entity.height +" "+ entity.length»'></Box>
						<Appearance>
							<Material diffuseColor='«entity.color»' transparency='«entity.transparency»'></Material>
						</Appearance>
					</Shape>
				«ENDIF»
			</Transform>
		</Group>
	'''
	
	// Own logic for ABAP Districts
	def String toAbapDistrict(Entity entity) '''
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
	'''
	
	def String toBuilding(Entity entity)'''
		«IF config.abap_representation == AbapCityRepresentation::ADVANCED»
			«abapAdvancedBuildings(entity)»
		«ELSE»
			<Group DEF='«entity.id»'>
				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'>
					<Shape>
						«IF config.parser == FamixParser::ABAP»
							«abapBuildingShape(entity)»
						«ELSE»
							<Box size='«entity.width +" "+ entity.height +" "+ entity.length»'></Box>
						«ENDIF»
						<Appearance>
							<Material diffuseColor='«entity.color»' transparency='«entity.transparency»'></Material>
						</Appearance>
					</Shape>
				</Transform>
			</Group>
		«ENDIF»

	'''
	
	//Advanced ABAP buildings
	def String abapAdvancedBuildings(Entity entity)'''
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
«««		<Group DEF='«entity.id»'>
«««						<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'>
«««							<Shape>
«««								
«««								<Cylinder radius='«entity.width/2»' height='«entity.height*4»'></Cylinder>	
«««								<Appearance>
«««									<Material diffuseColor='«entity.color»' transparency='«entity.transparency»'></Material>
«««								</Appearance>
«««							</Shape>
«««						</Transform>
«««					</Group>
					
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
			
			
«««						<Group DEF='«entity.id»'>
«««							<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»' 
«««									   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
«««									   rotation='0.000000 0.707107 0.707107 3.141593'>
«««								«IF defineCMTableType»
«««									«CustomModel_TableType::defineTableTypeShape»
«««									«defineCMTableType = false»
«««								«ELSE»
«««									«CustomModel_TableType::createTableTypeShape»
«««								«ENDIF»					
«««							</Transform>
«««						</Group>
			   						   				
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

		«ELSEIF entity.type == "FAMIX.Attribute"»
«««			<Group DEF='«entity.id»'>
«««				<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'
«««						   scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale(entity.type))»'
«««						   rotation='0 0.707107 0.707107 3.141593'>
«««					«IF defineCMRadioTower»
«««						«defineCMRadioTower = false»
«««						«CustomModel_RadioTower::defineRadioTowerBase»
«««						«FOR n : 1..entity.height.intValue»
«««							«CustomModel_RadioTower::defineRadioTowerFloor(config.getAbapAttributeBaseHeight + (n - 1) * config.getAbapAttributeFloorHeight)»
«««						«ENDFOR»
«««						«CustomModel_RadioTower::defineRadioTowerRoof(config.getAbapAttributeBaseHeight + entity.height * config.getAbapAttributeFloorHeight)»
«««					«ELSE»
«««						«CustomModel_RadioTower::createRadioTowerBase»
«««						«FOR n : 1..entity.height.intValue»
«««							«CustomModel_RadioTower::createRadioTowerFloor(config.getAbapAttributeBaseHeight + (n - 1) * config.getAbapAttributeFloorHeight)»
«««						«ENDFOR»
«««						«CustomModel_RadioTower::createRadioTowerRoof(config.getAbapAttributeBaseHeight + entity.height * config.getAbapAttributeFloorHeight)»
«««					«ENDIF»
«««				</Transform>
«««			</Group>
			
«««			«ELSEIF entity.type == "FAMIX.Attribute"»
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

«««<Group DEF='«entity.id»'>
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

		«ELSEIF entity.type == "FAMIX.FunctionModule"»
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
	
	def String toBuildingSegment(BuildingSegment entity) '''
		«var x = entity.position.x»
		«var y = entity.position.y»
		«var z = entity.position.z»
		«var width = entity.width»
		«var height = entity.height»
		«var length = entity.length»
		<Group DEF='«entity.id»'>
			<Transform translation='«x +" "+ y +" "+ z»'>
				<Shape>
				«IF config.buildingType == BuildingType.CITY_PANELS
						&& entity.type == "FAMIX.Attribute"
						&& config.showAttributesAsCylinders»
					<Cylinder radius='«width/2»' height='«height»'></Cylinder>
				«ELSE»
					<Box size='«width +" "+ height +" "+ length»'></Box>
				«ENDIF»
					<Appearance>
						<Material diffuseColor='«entity.color»'></Material>
					</Appearance>
				</Shape>
			</Transform>
			«FOR separator : entity.separator»
			<Transform translation='«separator.position.x +" "+ separator.position.y +" "+ separator.position.z»'>
				<Shape>
				«IF separator instanceof PanelSeparatorCylinder»
					«val separatorC = separator»
					<Cylinder radius='«separatorC.radius»' height='«config.panelSeparatorHeight»'></Cylinder>
				«ELSE»
					«val separatorB = separator as PanelSeparatorBox»
					<Box size='«separatorB.width +" "+ config.panelSeparatorHeight + " "+ separatorB.length»'></Box>
				«ENDIF»
					<Appearance>
						<Material diffuseColor='«config.getCityColorAsPercentage("black")»'></Material>
					</Appearance>
				</Shape>
			</Transform>
			«ENDFOR»
		</Group>
	'''
	
	def toFloor(BuildingSegment floor) '''
		<Group DEF='«floor.id»'>
			<Transform translation='«floor.position.x +" "+ floor.position.y +" "+ floor.position.z»'>
				<Shape>
					«IF config.parser == FamixParser::ABAP»
						«toAbapFloor(floor)»
					«ELSE»
						<Box size='«floor.width +" "+ floor.height +" "+ floor.length»'></Box>
					«ENDIF»
					<Appearance>
						<Material diffuseColor='«floor.color»'></Material>
					</Appearance>
				</Shape>
			</Transform>
		</Group>
	'''
	
	// Own logic for ABAP floors (Methods, forms)
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
		<Group DEF='«chimney.id»'>
			<Transform translation='«chimney.position.x +" "+ chimney.position.y +" "+ chimney.position.z»'>
				<Shape>
					<Cylinder height='«chimney.height»' radius='«chimney.width»'></Cylinder>
					<Appearance>
						<Material diffuseColor='«chimney.color»'></Material>
					</Appearance>
				</Shape>
			</Transform>
		</Group>
	'''
	
}