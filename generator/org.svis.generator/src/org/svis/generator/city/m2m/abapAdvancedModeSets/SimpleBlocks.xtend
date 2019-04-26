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
		<Transform translation='«0 +" "+ (config.getSimpleBlocksHeigth(entity.type) / 2) +" "+ 0»'>
			<Shape>
				<Cylinder radius='«entity.width/2»' height='«config.getSimpleBlocksHeigth(entity.type)»'></Cylinder>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''

	override getElemFor_Domain(Entity entity) '''
		<Transform translation='«0 +" "+ (config.getSimpleBlocksHeigth(entity.type) / 2) +" "+ 0»'>
			<Shape>
				<Cylinder radius='«entity.width/2»' height='«config.getSimpleBlocksHeigth(entity.type)»'></Cylinder>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_VirtualDomain(Entity entity) '''
		<Transform translation='«0 +" "+ (config.getSimpleBlocksHeigth(entity.type) / 2) +" "+ 0»'>
			<Shape>
				<Cylinder radius='«entity.width/2»' height='«config.getSimpleBlocksHeigth("FAMIX.VirtualDomain")»'></Cylinder>
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
		<Transform translation='«0 +" "+ (config.getSimpleBlocksHeigth(entity.type) / 2) +" "+ 0»'>
			<Shape>
				<Box size='«entity.width +" "+ config.getSimpleBlocksHeigth(entity.type) +" "+ entity.length»'></Box>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_Method(Entity entity) '''
		<Transform translation='«0 +" "+ (getHeight(entity.type, entity.buildingParts.length) / 2) +" "+ 0»'>
			<Shape>
				<Box size='«entity.width / 2 +" "+ getHeight(entity.type, entity.buildingParts.length) +" "+ entity.length / 2»'></Box>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_Class(Entity entity) '''
		<Transform translation='«0 +" "+ (getHeight(entity.type, entity.buildingParts.length) / 2) +" "+ 0»'>
			<Shape>
				<Box size='«entity.width +" "+ getHeight(entity.type, entity.buildingParts.length) +" "+ entity.length»'></Box>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_FunctionModule(Entity entity) '''
		<Transform translation='«0 +" "+ (getHeight(entity.type, entity.buildingParts.length) / 2) +" "+ 0»'>
			<Shape>
				<Box size='«(entity.width * 0.9) +" "+ getHeight(entity.type, entity.buildingParts.length) +" "+ (entity.length * 0.6)»'></Box>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_Report(Entity entity) '''
		<Transform translation='«0 +" "+ (getHeight(entity.type, entity.buildingParts.length) / 2) +" "+ 0»'>
			<Shape>
				<Box size='«entity.width +" "+ getHeight(entity.type, entity.buildingParts.length) +" "+ entity.length»'></Box>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_Formroutine(Entity entity) '''
		<Transform translation='«0 +" "+ (getHeight(entity.type, entity.buildingParts.length) / 2) +" "+ 0»'>
			<Shape>
				<Box size='«entity.width +" "+ getHeight(entity.type, entity.buildingParts.length) +" "+ (entity.length * 0.9)»'></Box>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_TableType_ABAPStruc(Entity entity) '''
		<Transform translation='«0 +" "+ (config.getSimpleBlocksHeigth("TT_Struc") / 2) +" "+ 0»'>
			<Shape>
				<Cone bottomRadius='«entity.width / 4»' height='«config.getSimpleBlocksHeigth("TT_Struc")»' ></Cone>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_TableType_Table(Entity entity) '''
		<Transform translation='«0 +" "+ (config.getSimpleBlocksHeigth("TT_Table") / 2) +" "+ 0»'>
			<Shape>
				<Cone bottomRadius='«entity.width / 4»' height='«config.getSimpleBlocksHeigth("TT_Table")»' ></Cone>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_Attribute_Class(Entity entity) '''
		<Transform translation='«0 +" "+ (getHeight(entity.type, entity.buildingParts.length) / 2) +" "+ 0»'>
			<Shape>
				<Cylinder radius='«entity.width / 6»' height='«getHeight(entity.type, entity.buildingParts.length)»' ></Cylinder>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>	
	'''
	
	override getElemFor_Attribute_FunctionGroup(Entity entity) '''
		<Transform translation='«0 +" "+ (config.getSimpleBlocksHeigth("FAMIX.Attribute_FunctionGroup") / 2) +" "+ 0»'>
			<Shape>
				<Cylinder radius='«entity.width / 6»' height='«config.getSimpleBlocksHeigth("FAMIX.Attribute_FunctionGroup")»' ></Cylinder>
				<Appearance>
					<Material diffuseColor='«getColor(entity.type)»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
	
	override getElemFor_Attribute_Report(Entity entity) '''
		<Transform translation='«0 +" "+ (config.getSimpleBlocksHeigth("FAMIX.Attribute_Report") / 2) +" "+ 0»'>
			<Shape>
				<Cylinder radius='«entity.width / 6»' height='«config.getSimpleBlocksHeigth("FAMIX.Attribute_Report")»' ></Cylinder>
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