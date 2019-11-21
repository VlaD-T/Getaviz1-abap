package org.svis.generator.city.m2t

import java.util.List
import java.lang.reflect.*
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
import org.svis.generator.city.m2m.abapAdvancedModeSets.AdvSet_Interface

class City2X3D_abap_adv {
			
	val log = LogFactory::getLog(getClass)
	val config = SettingsConfiguration.instance
	val advSetName = config.getAbapAdvCity_set.toString
	val advSetClass = try {
		Class.forName(advSetName)
	} catch (ClassNotFoundException e) {
		log.info("advSetName - Class not found")
		null
	}		
	
	var AdvSet_Interface advSetClass_Instance = advSetClass.newInstance() as AdvSet_Interface	
	
	def set(List<Entity> entities) {
		if (advSetClass === null) {
			log.info("Custom Set Class - not found")
			return null
		}		
		val x3d = try {
			entities.toX3DModel()	
		} catch (NoSuchMethodException e) {
			log.info("Check Method Parameters")
			null
		}
		return x3d	
	}
	
	// transform logic
	def String toX3DModel(List<Entity> entities) '''	
		<Group DEF='defineModels'>
			<Transform translation='0 -100 0'
					   scale='0 0 0'>
				«advSetClass_Instance.defineElements()»
			</Transform>
		</Group>
			
  		«FOR entity : entities»
			«IF entity.type == "FAMIX.Namespace"  || entity.type == "reportDistrict"
				|| entity.type == "classDistrict" || entity.type == "functionGroupDistrict" 
				|| entity.type == "tableDistrict" || entity.type == "dcDataDistrict" || entity.type == "interfaceDistrict"
				|| entity.type == "domainDistrict" || entity.type == "structureDistrict" || entity.type == "virtualDomainDistrict"»
				«toDistrict(entity)»
			«ENDIF»
			«IF entity.type == "FAMIX.Class" || entity.type == "FAMIX.Interface"|| entity.type == "FAMIX.DataElement" 
				|| entity.type == "FAMIX.Report" || entity.type == "FAMIX.FunctionGroup" 
				|| entity.type == "FAMIX.ABAPStruc"	|| entity.type == "FAMIX.StrucElement" 
				|| entity.type == "FAMIX.Table" || entity.type == "FAMIX.TableElement" || entity.type == "FAMIX.Class" 
				|| entity.type == "FAMIX.Domain" || entity.type == "FAMIX.VirtualDomain" || entity.type == "FAMIX.TableType"
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
						«ENDIF»
					</Appearance>
				</Shape>
			</Transform>
		</Group>
	'''
	
	//Advanced ABAP buildings
	def String toBuilding(Entity entity)'''
		<Group DEF='«entity.id»'>
			<Transform translation='«entity.position.x +" "+ entity.position.y +" "+ entity.position.z»'
					   scale='«getAdvBuildingScale(entity)»'>
			«IF entity.type == "FAMIX.DataElement"»
				«advSetClass_Instance.getElemFor_DataElement(entity)»
			«ELSEIF entity.type == "FAMIX.Domain"»
				«advSetClass_Instance.getElemFor_Domain(entity)»
«««			«ELSEIF entity.type == "FAMIX.VirtualDomain"»
«««				«advSetClass_Instance.getElemFor_VirtualDomain(entity)»
			«ELSEIF entity.type == "FAMIX.ABAPStruc"»
				«advSetClass_Instance.getElemFor_ABAPStruc(entity)»
			«ELSEIF entity.type == "FAMIX.StrucElement"»
				«advSetClass_Instance.getElemFor_StrucElement(entity)»
			«ELSEIF entity.type == "FAMIX.Table"»
				«advSetClass_Instance.getElemFor_Table(entity)»
			«ELSEIF entity.type == "FAMIX.Method"»
				«advSetClass_Instance.getElemFor_Method(entity)»
			«ELSEIF entity.type == "FAMIX.Class"»
				«advSetClass_Instance.getElemFor_Class(entity)»
			«ELSEIF entity.type == "FAMIX.FunctionModule"»
				«advSetClass_Instance.getElemFor_FunctionModule(entity)»
			«ELSEIF entity.type == "FAMIX.Report"»
				«advSetClass_Instance.getElemFor_Report(entity)»
			«ELSEIF entity.type == "FAMIX.Formroutine"»
				«advSetClass_Instance.getElemFor_Formroutine(entity)»
			«ELSEIF entity.type == "FAMIX.TableType"»
				«IF entity.rowType == "FAMIX.ABAPStruc"»
					«advSetClass_Instance.getElemFor_TableType_ABAPStruc(entity)»
				«ELSEIF entity.rowType == "FAMIX.Table"»
					«advSetClass_Instance.getElemFor_TableType_Table(entity)»
				«ELSE»
					«advSetClass_Instance.getElemFor_TableType(entity)»
				«ENDIF»
			«ELSEIF entity.type == "FAMIX.Attribute"» 
				«IF entity.parentType == "FAMIX.FunctionGroup"»	
					«advSetClass_Instance.getElemFor_Attribute_FunctionGroup(entity)»
				«ELSEIF entity.parentType == "FAMIX.Class"»
					«advSetClass_Instance.getElemFor_Attribute_Class(entity)»
				«ELSEIF entity.parentType == "FAMIX.Report"»
					«advSetClass_Instance.getElemFor_Attribute_Report(entity)»
				«ENDIF»
			«ENDIF»
			</Transform>
		</Group>
	'''
	
	def toChimney(BuildingSegment chimney, Entity entity) '''
		«IF entity.parentType == "FAMIX.Interface"»			 	 
«««			<Group DEF='«chimney.id»'>
«««				<Transform translation='«chimney.position.x +" "+ chimney.position.y +" "+ chimney.position.z»'
«««	                       scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale("FAMIX.InterfaceAttribute"))»'
«««	                       rotation='0.000000 0.707107 0.707107 3.141593'>
«««	                <Shape>
«««	                    	<Appearance>
«««	                    		<Material diffuseColor="«CityUtils.getRGBFromHEX("#39434b")»" 
«««								          transparency="0.0"
«««								          />
«««	                    	</Appearance>
«««	                    	<IndexedFaceSet solid="true"
«««							                coordIndex="0 1 2 3 -1 4 5 6 7 -1 8 9 10 11 -1 12 13 14 15 -1 16 17 18 19 -1 20 21 22 23 -1 24 25 26 27 -1 28 29 30 31 -1 32 33 34 35 -1 36 37 38 39 -1 40 41 42 43 -1 44 45 46 47 -1 48 49 50 51 -1 52 53 54 55 -1 56 57 58 59 -1 60 61 62 63 -1 64 65 66 67 -1 68 69 70 71 -1 72 73 74 75 -1 76 77 78 79 -1 80 81 82 83 -1 84 85 86 87 -1 88 89 90 91 -1 92 93 94 95 -1 96 97 98 99 -1 100 101 102 103 -1 104 105 106 107 -1 108 109 110 111 -1 112 113 114 115 -1 116 117 118 119 -1 120 121 122 123 -1 124 125 126 127 -1 128 129 130 131 -1 132 133 134 135 -1 136 137 138 139 -1 140 141 142 143 -1 144 145 146 147 -1 148 149 150 151 -1 152 153 154 155 -1 156 157 158 159 -1 160 161 162 163 -1 164 165 166 167 -1 168 169 170 171 -1 172 173 174 175 -1 176 177 178 179 -1 180 181 182 183 -1 184 185 186 187 -1 188 189 190 191 -1 192 193 194 195 -1 196 197 198 199 -1 "
«««							                >
«««	                    		<Coordinate DEF="coords_ME_roof-antenna"
«««								            point="-1.000000 0.000000 0.000000 -1.000000 0.000000 1.000000 -1.000000 1.000000 1.000000 -1.000000 1.000000 0.000000 -1.000000 -1.000000 0.000000 -1.000000 -1.000000 1.000000 -1.000000 0.000000 1.000000 -1.000000 0.000000 0.000000 -1.000000 1.000000 0.000000 -1.000000 1.000000 1.000000 -1.000000 2.000000 1.000000 -1.000000 2.000000 0.000000 0.000000 0.000000 1.000000 0.000000 0.000000 2.000000 0.000000 1.000000 2.000000 0.000000 1.000000 1.000000 0.000000 0.000000 2.000000 0.000000 0.000000 3.000000 0.000000 1.000000 3.000000 0.000000 1.000000 2.000000 0.000000 0.000000 3.000000 0.000000 0.000000 4.000000 0.000000 1.000000 4.000000 0.000000 1.000000 3.000000 0.000000 0.000000 4.000000 0.000000 0.000000 5.000000 0.000000 1.000000 5.000000 0.000000 1.000000 4.000000 0.000000 0.000000 5.000000 0.000000 0.000000 6.000000 0.000000 1.000000 6.000000 0.000000 1.000000 5.000000 2.000000 1.000000 0.000000 2.000000 2.000000 0.000000 2.000000 2.000000 1.000000 2.000000 1.000000 1.000000 2.000000 0.000000 0.000000 2.000000 1.000000 0.000000 2.000000 1.000000 1.000000 2.000000 0.000000 1.000000 2.000000 -1.000000 0.000000 2.000000 0.000000 0.000000 2.000000 0.000000 1.000000 2.000000 -1.000000 1.000000 1.000000 0.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 2.000000 1.000000 0.000000 2.000000 1.000000 0.000000 2.000000 1.000000 1.000000 2.000000 1.000000 1.000000 3.000000 1.000000 0.000000 3.000000 1.000000 0.000000 3.000000 1.000000 1.000000 3.000000 1.000000 1.000000 4.000000 1.000000 0.000000 4.000000 1.000000 0.000000 4.000000 1.000000 1.000000 4.000000 1.000000 1.000000 5.000000 1.000000 0.000000 5.000000 1.000000 0.000000 5.000000 1.000000 1.000000 5.000000 1.000000 1.000000 6.000000 1.000000 0.000000 6.000000 0.000000 -1.000000 0.000000 1.000000 -1.000000 0.000000 1.000000 -1.000000 1.000000 0.000000 -1.000000 1.000000 -1.000000 -1.000000 0.000000 0.000000 -1.000000 0.000000 0.000000 -1.000000 1.000000 -1.000000 -1.000000 1.000000 1.000000 -1.000000 0.000000 2.000000 -1.000000 0.000000 2.000000 -1.000000 1.000000 1.000000 -1.000000 1.000000 0.000000 0.000000 1.000000 1.000000 0.000000 1.000000 1.000000 0.000000 2.000000 0.000000 0.000000 2.000000 0.000000 0.000000 2.000000 1.000000 0.000000 2.000000 1.000000 0.000000 3.000000 0.000000 0.000000 3.000000 0.000000 0.000000 3.000000 1.000000 0.000000 3.000000 1.000000 0.000000 4.000000 0.000000 0.000000 4.000000 0.000000 0.000000 4.000000 1.000000 0.000000 4.000000 1.000000 0.000000 5.000000 0.000000 0.000000 5.000000 0.000000 0.000000 5.000000 1.000000 0.000000 5.000000 1.000000 0.000000 6.000000 0.000000 0.000000 6.000000 -1.000000 2.000000 0.000000 -1.000000 2.000000 1.000000 0.000000 2.000000 1.000000 0.000000 2.000000 0.000000 0.000000 2.000000 0.000000 0.000000 2.000000 1.000000 1.000000 2.000000 1.000000 1.000000 2.000000 0.000000 1.000000 2.000000 0.000000 1.000000 2.000000 1.000000 2.000000 2.000000 1.000000 2.000000 2.000000 0.000000 0.000000 1.000000 1.000000 0.000000 1.000000 2.000000 1.000000 1.000000 2.000000 1.000000 1.000000 1.000000 0.000000 1.000000 2.000000 0.000000 1.000000 3.000000 1.000000 1.000000 3.000000 1.000000 1.000000 2.000000 0.000000 1.000000 3.000000 0.000000 1.000000 4.000000 1.000000 1.000000 4.000000 1.000000 1.000000 3.000000 0.000000 1.000000 4.000000 0.000000 1.000000 5.000000 1.000000 1.000000 5.000000 1.000000 1.000000 4.000000 0.000000 1.000000 5.000000 0.000000 1.000000 6.000000 1.000000 1.000000 6.000000 1.000000 1.000000 5.000000 0.000000 -1.000000 0.000000 0.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 -1.000000 0.000000 0.000000 0.000000 0.000000 0.000000 1.000000 0.000000 1.000000 1.000000 0.000000 1.000000 0.000000 0.000000 -1.000000 0.000000 0.000000 -1.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 0.000000 0.000000 -1.000000 -1.000000 0.000000 -1.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 -1.000000 0.000000 -1.000000 1.000000 0.000000 -1.000000 2.000000 0.000000 0.000000 2.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 2.000000 0.000000 1.000000 2.000000 0.000000 1.000000 1.000000 0.000000 1.000000 1.000000 0.000000 1.000000 2.000000 0.000000 2.000000 2.000000 0.000000 2.000000 1.000000 0.000000 1.000000 0.000000 0.000000 1.000000 1.000000 0.000000 2.000000 1.000000 0.000000 2.000000 0.000000 0.000000 1.000000 -1.000000 0.000000 1.000000 0.000000 0.000000 2.000000 0.000000 0.000000 2.000000 -1.000000 0.000000 0.000000 -1.000000 1.000000 1.000000 -1.000000 1.000000 1.000000 0.000000 1.000000 0.000000 0.000000 1.000000 -1.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 1.000000 1.000000 -1.000000 1.000000 1.000000 -1.000000 -1.000000 1.000000 0.000000 -1.000000 1.000000 0.000000 0.000000 1.000000 -1.000000 0.000000 1.000000 -1.000000 1.000000 1.000000 0.000000 1.000000 1.000000 0.000000 2.000000 1.000000 -1.000000 2.000000 1.000000 0.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 2.000000 1.000000 0.000000 2.000000 1.000000 1.000000 1.000000 1.000000 2.000000 1.000000 1.000000 2.000000 2.000000 1.000000 1.000000 2.000000 1.000000 1.000000 0.000000 1.000000 2.000000 0.000000 1.000000 2.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 -1.000000 1.000000 2.000000 -1.000000 1.000000 2.000000 0.000000 1.000000 1.000000 0.000000 1.000000 0.000000 0.000000 6.000000 1.000000 0.000000 6.000000 1.000000 1.000000 6.000000 0.000000 1.000000 6.000000 "
«««								            />
«««	                    	</IndexedFaceSet>
«««	               </Shape>                
«««	            </Transform>
«««	         </Group>		            
		«ELSEIF entity.type == "FAMIX.Table"»
			<Group DEF='«chimney.id»'>
				<Transform translation='«chimney.position.x +" "+ chimney.position.y +" "+ chimney.position.z»'
					       scale='«getAdvBuildingScale(config.getAbapAdvBuildingScale("FAMIX.TableElement"))»'>
				     <Shape>
						<Box size='6 4 3'></Box>
						<Appearance>
							<Material diffuseColor="«CityUtils.getRGBFromHEX("#95fff3")»" transparency="0.0"/>
						</Appearance>
					</Shape>
				</Transform>
			</Group>
		«ENDIF»
	'''	

	// Return scale for building. Scale - for changing size
	def String getAdvBuildingScale(double scale)'''
		«scale + " " + scale +  " " + scale»
	'''
	
	def String getAdvBuildingScale(Entity entity)'''
		«IF entity.type == "FAMIX.Class"»
			«entity.width * ( config.getAbapAdvBuildingDefSize("FAMIX.InterfaceAttribute") + 1) / config.getAbapAdvBuildingDefSize(entity.type) + " " + config.getAbapAdvBuildingScale(entity.type) +  " " + entity.width * ( config.getAbapAdvBuildingDefSize("FAMIX.InterfaceAttribute") + 1) / config.getAbapAdvBuildingDefSize(entity.type)»
«««		«ELSEIF entity.type == "FAMIX.Report"»
«««			«entity.width * ( config.getAbapAdvBuildingDefSize("FAMIX.ReportAttribute") + 1) / config.getAbapAdvBuildingDefSize(entity.type) + " " + config.getAbapAdvBuildingScale(entity.type) +  " " + entity.width * ( config.getAbapAdvBuildingDefSize("FAMIX.ReportAttribute") + 1) / config.getAbapAdvBuildingDefSize(entity.type)»
		«ELSE»
			«config.getAbapAdvBuildingScale(entity.type) + " " + config.getAbapAdvBuildingScale(entity.type) +  " " + config.getAbapAdvBuildingScale(entity.type)»
		«ENDIF»
	'''
}