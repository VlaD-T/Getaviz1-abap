package org.svis.generator.city.m2m.abapAdvancedModeSets

import org.svis.xtext.city.Entity

interface AdvSet_Interface {
	def String defineElements() ''''''	
	def String getElemFor_DataElement(Entity entity) ''''''
	def String getElemFor_Domain(Entity entity) ''''''
	def String getElemFor_StrucElement(Entity entity) ''''''
	def String getElemFor_Table(Entity entity) ''''''
	def String getElemFor_Method(Entity entity) ''''''
	def String getElemFor_Class(Entity entity) ''''''
	def String getElemFor_FunctionModule(Entity entity) ''''''
	def String getElemFor_Report(Entity entity) ''''''
	def String getElemFor_Formroutine(Entity entity) ''''''
	def String getElemFor_TableType_ABAPStruc(Entity entity) ''''''
	def String getElemFor_TableType_Table(Entity entity) ''''''
	def String getElemFor_Attribute_Class(Entity entity) ''''''
	def String getElemFor_Attribute_FunctionGroup(Entity entity) ''''''
}