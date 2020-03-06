package org.svis.generator.city.m2m.abapAdvancedModeSets

import org.svis.generator.city.m2m.abapAdvancedModeSets.AdvSet_Interface
import org.svis.xtext.city.Entity
import org.svis.generator.SettingsConfiguration
import org.svis.generator.city.m2m.RGBColor

class SimpleBlocks implements AdvSet_Interface {
	val config = SettingsConfiguration.instance
	def String getColor(String type) {
		if (config.getAbapBuildingColor(type) !== null) {
			return new RGBColor(config.getAbapBuildingColor(type)).asPercentage
		} else if (config.getAbapBuildingSegmentColor(type) !== null) {
			return new RGBColor(config.getAbapBuildingSegmentColor(type)).asPercentage
		} else {
			return new RGBColor(config.getColor("#3e3e1e")).asPercentage
		}
	}	
	
	override defineElements()'''

	'''

	override getElemFor_DataElement(Entity entity) '''
		<Transform translation='«0 +" "+ (config.getSimpleBlocksHeight(entity.type) / 2) +" "+ 0»'>
			<Shape>
				<Cylinder radius='«entity.width/2»' height='«config.getSimpleBlocksHeight(entity.type)»'></Cylinder>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''

	override getElemFor_Domain(Entity entity) '''
		<Transform translation='«0 +" "+ (config.getSimpleBlocksHeight(entity.type) / 2) +" "+ 0»'>
			<Shape>
				<Cylinder radius='«entity.width/2»' height='«config.getSimpleBlocksHeight(entity.type)»'></Cylinder>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_VirtualDomain(Entity entity) '''
		<Transform translation='«0 +" "+ (config.getSimpleBlocksHeight(entity.type) / 2) +" "+ 0»'>
			<Shape>
				<Cylinder radius='«entity.width/2»' height='«config.getSimpleBlocksHeight("FAMIX.VirtualDomain")»'></Cylinder>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_ABAPStruc(Entity entity) '''
		<Transform translation='«0 +" "+ (getHeight(entity.type, entity.buildingParts.length) / 2) +" "+ 0»'>
			<Shape>
				<Cone bottomRadius='«entity.width / 3»' height='«getHeight(entity.type, entity.buildingParts.length)»' ></Cone>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_StrucElement(Entity entity) '''
		<Transform translation='«0 +" "+ (getHeight(entity.type, entity.buildingParts.length) / 2) +" "+ 0»'>
			<Shape>
				<Cone bottomRadius='«entity.width / 3»' height='«getHeight(entity.type, entity.buildingParts.length)»' ></Cone>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>	
	'''
	
	override getElemFor_Table(Entity entity) '''
		<Transform translation='«0 +" "+ (config.getSimpleBlocksHeight(entity.type) / 2) +" "+ 0»'>
			<Shape>
				<Box size='«entity.width +" "+ config.getSimpleBlocksHeight(entity.type) +" "+ entity.length»'></Box>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_Method(Entity entity) '''
		<Transform translation='«0 + " " + entity.height * config.getScoHeightScaleOfSimpleBlocks / 2 + " " + 0»'>
			<Shape>
				<Box size='«entity.width / 2 + " " + entity.height * config.getScoHeightScaleOfSimpleBlocks + " " + entity.length / 2»'></Box>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	// Why not getElemFor_Interface() ??? 
	override getElemFor_Class(Entity entity) '''
		<Transform translation='«0 +" "+ (getHeight(entity.type, entity.buildingParts.length) / 2) +" "+ 0»'>
			<Shape>
				<Box size='«entity.width +" "+ getHeight(entity.type, entity.buildingParts.length) +" "+ entity.length»'></Box>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
		
		<Transform translation='«0 +" "+ (getHeight(entity.type, entity.buildingParts.length)) +" "+ 0»'>
			<Shape>
				<Box size='«getInterfaceRoofSize(entity.dataCounter) +" "+ 1 +" "+ getInterfaceRoofSize(entity.dataCounter)»'></Box>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	def getInterfaceRoofSize(double dataCounter) {
		var margin = 3
		if (dataCounter <= 4 ) {
			return margin + (config.getAdvBuildungAttributeHeight("FAMIX.Class") * 4)
		}
		return dataCounter + margin * 2
	}
	
	override getElemFor_FunctionModule(Entity entity) '''
		<Transform translation='«0 + " " + entity.height * config.getScoHeightScaleOfSimpleBlocks / 2 + " " + 0»'>
			<Shape>
				<Box size='«entity.width + " " + entity.height * config.getScoHeightScaleOfSimpleBlocks + " " + (entity.length * 0.5)»'></Box>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_Report(Entity entity) '''
		<Transform translation='«0 + " " + entity.height * config.getScoHeightScaleOfSimpleBlocks / 2 + " " + 0»'>
			<Shape>
				<Box size='«entity.width + " " + entity.height * config.getScoHeightScaleOfSimpleBlocks + " " + entity.length»'></Box>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_Formroutine(Entity entity) '''
		<Transform translation='«0 + " " + entity.height * config.getScoHeightScaleOfSimpleBlocks / 2 + " " + 0»'>
			<Shape>
				<Box size='«entity.width + " " + entity.height * config.getScoHeightScaleOfSimpleBlocks + " " + (entity.length * 0.9)»'></Box>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_TableType_ABAPStruc(Entity entity) '''
		<Transform translation='«0 +" "+ (config.getSimpleBlocksHeight("TT_Struc") / 2) +" "+ 0»'>
			<Shape>
				<Cone bottomRadius='«entity.width / 4»' height='«config.getSimpleBlocksHeight("TT_Struc")»'></Cone>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_TableType_Table(Entity entity) '''
		<Transform translation='«0 +" "+ (config.getSimpleBlocksHeight("TT_Table") / 2) +" "+ 0»'>
			<Shape>
				<Cone bottomRadius='«entity.width / 4»' height='«config.getSimpleBlocksHeight("TT_Table")»'></Cone>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
//	TODO eigener Konfig-Parameter für Tabellentypen
	override getElemFor_TableType(Entity entity) '''
		<Transform translation='«0 +" "+ (config.getSimpleBlocksHeight("TT_Struc") / 2) +" "+ 0»'>
			<Shape>
				<Cone bottomRadius='«entity.width / 4»' height='«config.getSimpleBlocksHeight("TT_Struc")»'></Cone>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_Attribute_Class(Entity entity) '''
		<Transform translation='«0 +" "+ entity.height * config.getScoHeightScaleOfSimpleBlocks / 2 +" "+ 0»'>
			<Shape>
				<Cylinder radius='«entity.width / 6»' height='«entity.height * config.getScoHeightScaleOfSimpleBlocks»'></Cylinder>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_Attribute_FunctionGroup(Entity entity) '''
		<Transform translation='«0 +" "+ (config.getSimpleBlocksHeight("FAMIX.Attribute_FunctionGroup") / 2) +" "+ 0»'>
			<Shape>
				<Cylinder radius='«entity.width / 6»' height='«config.getSimpleBlocksHeight("FAMIX.Attribute_FunctionGroup")»'></Cylinder>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_Attribute_Report(Entity entity) '''
		<Transform translation='«0 +" "+ (config.getSimpleBlocksHeight("FAMIX.Attribute_Report") / 2) +" "+ 0»'>
			<Shape>
				<Cylinder radius='«entity.width / 6»' height='«config.getSimpleBlocksHeight("FAMIX.Attribute_Report")»'></Cylinder>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	def double getHeight(String type, int partsCounter) {
		var baseHeight = config.getAdvBuildingBaseHeight(type)
		var roofHeight = config.getAdvBuildingRoofHeight(type)
		var floorHeight = partsCounter * config.getAdvBuildingFloorHeight(type)
		return baseHeight + roofHeight + floorHeight	
	}
}