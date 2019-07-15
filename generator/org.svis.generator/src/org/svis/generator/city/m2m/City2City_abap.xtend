package org.svis.generator.city.m2m

import org.apache.commons.logging.LogFactory
import org.eclipse.xtext.EcoreUtil2
import org.svis.xtext.city.Building
import org.svis.xtext.city.BuildingSegment
import org.svis.xtext.city.District
import org.svis.xtext.city.Root
import org.svis.xtext.city.impl.CityFactoryImpl
import org.svis.generator.SettingsConfiguration
import org.svis.generator.SettingsConfiguration.Original.BuildingMetric
import org.svis.generator.SettingsConfiguration.AbapCityRepresentation
//import org.svis.generator.SettingsConfiguration.AbapAdvCitySet
import org.svis.generator.SettingsConfiguration.AbapNotInOriginFilter
import java.lang.Math

class City2City_abap {
	val cityFactory = new CityFactoryImpl()
	var RGBColor[] PCKG_colors
	var RGBColor[] NOS_colors
	val log = LogFactory::getLog(class)
	val config = SettingsConfiguration.instance

	def run(Root cityRoot) {
		val districts = EcoreUtil2::getAllContentsOfType(cityRoot, District)
		val buildings = EcoreUtil2::getAllContentsOfType(cityRoot, Building)

		if (!districts.empty) {
			val PCKG_maxLevel = districts.sortBy[-level].head.level
			PCKG_colors = createColorGradiant(new RGBColor(config.packageColorStart),
				new RGBColor(config.packageColorEnd), PCKG_maxLevel)

			if (config.originalBuildingMetric == BuildingMetric::NOS) {
				val NOS_max = buildings.sortBy[-numberOfStatements].head.numberOfStatements
				NOS_colors = createColorGradiant(new RGBColor(config.classColorStart),
					new RGBColor(config.classColorEnd), NOS_max + 1)
			}

			districts.forEach[setDistrictAttributes]
			buildings.forEach[setBuildingAttributes]

			if (config.abap_representation == AbapCityRepresentation::ADVANCED) {
				ABAPCityLayout::cityLayout(cityRoot)
				CityHeightLayout::cityHeightLayout(cityRoot)
				buildings.forEach[calculateAdvChimneys]
			} else {
				CityLayout::cityLayout(cityRoot)
				buildings.forEach[calculateFloors]
				buildings.forEach[calculateChimneys]
 			}
		}

		return cityRoot
	}

	def private RGBColor[] createColorGradiant(RGBColor start, RGBColor end, int maxLevel) {
		var steps = maxLevel - 1
		if (maxLevel == 1) {
			steps++
		}
		val r_step = (end.r - start.r) / steps
		val g_step = (end.g - start.g) / steps
		val b_step = (end.b - start.b) / steps

		val colorRange = newArrayOfSize(maxLevel)
		for (i : 0 ..< maxLevel) {
			val newR = start.r + i * r_step
			val newG = start.g + i * g_step
			val newB = start.b + i * b_step
			colorRange.set(i, new RGBColor(newR, newG, newB))
		}
		return colorRange
	}

	def private void setDistrictAttributes(District d) {
		d.height = config.heightMin
		d.textureURL = config.getAbapDistrictTexture(d.type)
		
		// for not origin packages
		if (d.notInOrigin == "true") {
			switch (config.abapNotInOrigin_filter) {
				case AbapNotInOriginFilter::TRANSPARENT: d.transparency = config.getNotInOriginTransparentValue()
				case AbapNotInOriginFilter::COLORED: d.color = new RGBColor(config.getAbapDistrictColor("notInOrigin")).
					asPercentage
				case AbapNotInOriginFilter::DEFAULT: d.color = PCKG_colors.get(0).asPercentage
			}

			// Set color for custom districts
			if (config.getAbapDistrictColor(d.type) !== null) {
				d.color = new RGBColor(config.getAbapDistrictColor(d.type)).asPercentage
			}

		// for origin packages	
		// do nothing if color is already set  
		} else if (d.color !== null){
			return
			
		} else {
			// Set color, if defined
			if (config.getAbapDistrictColor(d.type) !== null) {
				d.color = new RGBColor(config.getAbapDistrictColor(d.type)).asPercentage
			} else {
				d.color = PCKG_colors.get(d.level - 1).asPercentage
			}
		}
	}

	def void setBuildingAttributes(Building b) {

		if (b.dataCounter < 2) { // pko 2016
			b.width = 2 // TODO in settings datei aufnehmen
			b.length = 2
		} else {
			b.width = Math.ceil(b.dataCounter / 4.0) + 1 // pko 2016
			b.length = Math.ceil(b.dataCounter / 4.0) + 1 // pko 2016
		}
		
		if (b.methodCounter == 0) {
			b.height = config.heightMin
		} else {
			b.height = b.methodCounter
		}

		if (config.abap_representation == AbapCityRepresentation::ADVANCED) {
			// We use custom models in advanced mode. Adjust sizes: 
			if (b.type == "FAMIX.DataElement") {
				b.width = getAdvBuildingWidth(b.type, 1.0)
				b.length = getAdvBuildingLength(b.type, 1.0)
				b.height = getScaledHeightofSco(b.dataCounter)
			
			} else if (b.type == "FAMIX.Domain") {
				b.width = getAdvBuildingWidth(b.type, 1.0)
				b.length = getAdvBuildingLength(b.type, 1.0)
				b.height = getScaledHeightofSco(b.dataCounter)
				
			} else if (b.type == "FAMIX.VirtualDomain") {
				b.width = getAdvBuildingWidth(b.type, 1.0)
				b.length = getAdvBuildingLength(b.type, 1.0)
				b.height = getScaledHeightofSco(b.dataCounter)

			} else if (b.type == "FAMIX.StrucElement") {
				b.width = getAdvBuildingWidth(b.type, 1.0)
				b.length = getAdvBuildingLength(b.type, 1.0)
				if (getScaledHeightofSco(b.dataCounter) == 1.0) {
					b.height = 2.0 // 2 - to show at least one floor
				} else {
					b.height = getScaledHeightofSco(b.dataCounter)
				}
				b.buildingParts.add(createAdvBuildingBase(b.type))								
				for (var i = 1; i <= b.height - 1; i++) {
					b.buildingParts.add(createAdvBuildingFloor(b.type, i))
				}
				b.buildingParts.add(createAdvBuildingRoof(b.type, b.height))

				} else if (b.type == "FAMIX.ABAPStruc") {
				b.width = getAdvBuildingWidth(b.type, 1.0)
				b.length = getAdvBuildingLength(b.type, 1.0)
				if (getScaledHeightofSco(b.dataCounter) == 1.0) {
					b.height = 2.0 // 2 - to show at least one floor
				} else {
					b.height = getScaledHeightofSco(b.dataCounter)
				}
				b.buildingParts.add(createAdvBuildingBase(b.type))								
				for (var i = 1; i <= b.height - 1; i++) {
					b.buildingParts.add(createAdvBuildingFloor(b.type, i))
				}
				b.buildingParts.add(createAdvBuildingRoof(b.type, b.height))


			} else if (b.type == "FAMIX.TableType") {
				b.width = getAdvBuildingWidth(b.type, 1.0)
				b.length = getAdvBuildingLength(b.type, 1.0)
				b.height = getScaledHeightofSco(b.dataCounter)

			} else if(b.type == "FAMIX.Table"){
				b.width = 4 * (config.getAbapAdvBuildingDefSize(b.type) * config.getAbapAdvBuildingScale(b.type)) 
				b.length = 2 * (config.getAbapAdvBuildingDefSize(b.type) * config.getAbapAdvBuildingScale(b.type))
				b.height = getScaledHeightofSco(b.dataCounter)

			} else if (b.type == "FAMIX.Attribute") { // Attributes for Classes districts. 
				b.width = getAdvBuildingWidth(b.type, 1.5)
				b.length = getAdvBuildingLength(b.type, 1.0)				
				b.height = getScaledHeightofSco(b.dataCounter) // b.dataCounter * multiplicator, to make building higher
				b.buildingParts.add(createAdvBuildingBase(b.type))								
				for (var i = 1; i <= b.height - 1; i++) {
					b.buildingParts.add(createAdvBuildingFloor(b.type, i))
				}
				b.buildingParts.add(createAdvBuildingRoof(b.type, b.height))

			} else if (b.type == "FAMIX.Method") {
				b.width = getAdvBuildingWidth(b.type, 1.5)
				b.length = getAdvBuildingLength(b.type, 1.0)
				b.height = getScaledHeightofSco(b.methodCounter)				
				b.buildingParts.add(createAdvBuildingBase(b.type))								
				for (var i = 1; i <= b.height - 1; i++) {
					b.buildingParts.add(createAdvBuildingFloor(b.type, i))
				}
				b.buildingParts.add(createAdvBuildingRoof(b.type, b.height))
				
			} else if (b.type == "FAMIX.Class") { // Interface. Classes are displayed as districts
			   /* var attributeCount = b.dataCounter
			    var attributeSize = config.getAdvBuildungAttributeWidth(b.type)*/
			    			    
			    b.width = b.width //* config.getAbapAdvBuildingDefSize(b.type) * config.getAbapAdvBuildingScale(b.type)			    
				//b.width = getAdjustedBuildingSize(b, 0)//getAdvBuildingWidth(b.type, 1.0)
				b.length = b.width 	
				
				/*if (b.width * 4 < attributeCount * attributeSize)	{
					b.width = adjustBuildingForAttributes() 
					b.length = adjustBuildingForAttributes()
				}	*/
				
				b.height = getScaledHeightofSco(b.methodCounter)
				b.buildingParts.add(createAdvBuildingBase(b.type))								
				for (var i = 1; i <= b.height - 1; i++) {
					b.buildingParts.add(createAdvBuildingFloor(b.type, i))
				}
				var roof = createAdvBuildingRoof(b.type, b.height)
				b.buildingParts.add(roof)
				b.height = roof.height


			} else if (b.type == "FAMIX.FunctionModule") {
				b.width = getAdvBuildingWidth(b.type, 1.0)
				b.length = getAdvBuildingLength(b.type, 1.0)
				b.height = getScaledHeightofSco(b.methodCounter)
				b.buildingParts.add(createAdvBuildingBase(b.type))								
				for (var i = 1; i <= b.height - 1; i++) {
					b.buildingParts.add(createAdvBuildingFloor(b.type, i))
				}
				b.buildingParts.add(createAdvBuildingRoof(b.type, b.height))
				
			} else if (b.type == "FAMIX.Report") {
			    
				b.width = getAdvBuildingWidth(b.type, 1.0) // b.width
				b.length = getAdvBuildingLength(b.type, 1.0)  // b.width
				b.height = getScaledHeightofSco(b.methodCounter)				
				b.buildingParts.add(createAdvBuildingBase(b.type))								
				for (var i = 1; i <= b.height - 1; i++) {
					b.buildingParts.add(createAdvBuildingFloor(b.type, i))
				}
				var roof = createAdvBuildingRoof(b.type, b.height)
				b.buildingParts.add(roof)
				b.height = roof.height	


			} else if (b.type == "FAMIX.Formroutine") {
				b.width = getAdvBuildingWidth(b.type, 1.0)
				b.length = getAdvBuildingLength(b.type, 1.0)
				b.height = getScaledHeightofSco(b.methodCounter)				
				b.buildingParts.add(createAdvBuildingBase(b.type))								
				for (var i = 1; i <= b.height - 1; i++) {
					b.buildingParts.add(createAdvBuildingFloor(b.type, i))
				}
				b.buildingParts.add(createAdvBuildingRoof(b.type, b.height))				
			}

		// Use custom colors from settings -> go to x3d file.
		// It's set there, because we do not use floor or chimneys
		// End of AbapCityRepresentation::ADVANCED		
		} else { // AbapCityRepresentation::SIMPLE
			// Edit height and width
			if (b.type == "FAMIX.ABAPStruc" || b.type == "FAMIX.TableType") {
				b.width = 1.75

				b.height = b.methodCounter * config.strucElemHeight
				if (config.strucElemHeight <= 1 || b.methodCounter == 0) {
					b.height = b.height + 1
				}

			} else if (b.type == "FAMIX.DataElement") {
				b.height = 1
				b.width = 1.25
			}

			// If not in origin, set new min height
			if (b.notInOrigin == "true") {
				if ((b.type == "FAMIX.Class" || b.type == "FAMIX.Interface" || b.type == "FAMIX.Report" ||
					b.type == "FAMIX.FunctionGroup") && b.height < config.getNotInOriginSCBuildingHeight()) {
					b.height = config.getNotInOriginSCBuildingHeight()
				}
			}

			// Use custom colors from settings
			if (config.getAbapBuildingColor(b.type) !== null) {
				b.color = new RGBColor(config.getAbapBuildingColor(b.type)).asPercentage;
			}

			// Edit transparency 	
			if (config.abapNotInOrigin_filter == AbapNotInOriginFilter::TRANSPARENT && b.notInOrigin == "true") {
				b.transparency = config.getNotInOriginTransparentValue()
			}
		} // End of AbapCityRepresentation::SIMPLE		
	}
	
	def double getAdjustedBuildingSize(Building b, double width){
	    if (b.dataCounter == 0) {
	    	return getAdvBuildingWidth(b.type, 1.0)
	    }
		
		
		var attributeWidth = config.getAdvBuildungAttributeWidth("FAMIX.Class") * config.getAbapAdvBuildingScale("FAMIX.InterfaceAttribute")
		var singleAttributeArea = attributeWidth * attributeWidth
		var attributesArea = b.dataCounter * singleAttributeArea
		var buildingWidth = getAdvBuildingWidth(b.type, 1.0) + width
		var buildingArea = buildingWidth * buildingWidth
		
		if (buildingArea < attributesArea) {
			var adjustWidth = Math.abs(attributesArea - buildingArea)
			getAdjustedBuildingSize(b, adjustWidth)
		} else {
			return buildingWidth
		}
	}
	
	// pko 2016
	def void calculateFloors(Building b) {

		val cityFactory = new CityFactoryImpl

		val bHeight = b.height
		val bWidth = b.width
		val bLength = b.length

		val bPosX = b.position.x
		val bPosY = b.position.y
		val bPosZ = b.position.z

		val floors = b.methods
		val floorNumber = floors.length

		var floorCounter = 0

		for (floor : floors) {
			floorCounter++

			// Set standard values
			floor.height = bHeight / ( floorNumber + 2 ) * 0.80
			floor.width = bWidth + 0.2
			floor.length = bLength + 0.2
			floor.color = 20 / 255.0 + " " + 133 / 255.0 + " " + 204 / 255.0
			floor.position = cityFactory.createPosition
			floor.position.y = (bPosY - ( bHeight / 2) ) + bHeight / ( floorNumber + 2 ) * floorCounter

			// Type is used to define shape in x3d
			floor.parentType = b.type

			var newBHeight = bHeight + config.strucElemHeight
			var newYPos = (bPosY - ( newBHeight / 2) ) + newBHeight / ( floorNumber + 2 ) * floorCounter

			// Make changes for specific types 
			if (b.type == "FAMIX.ABAPStruc") {
				floor.height = config.strucElemHeight
				floor.position.y = newYPos + 0.5

			} else if (b.type == "FAMIX.TableType") {
				floor.height = config.strucElemHeight
				floor.position.y = newYPos + 0.5

			} else if (b.type == "FAMIX.Table") {
				floor.height = 0.4
				floor.width = bWidth * 0.55
			}

			// Use color for building segments, if it's set
			if (config.getAbapBuildingSegmentColor(b.type) !== null) {
				floor.color = new RGBColor(config.getAbapBuildingSegmentColor(b.type)).asPercentage;
			}

			// Edit floor height for source-code buildings in "not in origin" districts
			if (b.notInOrigin == "true") {
				if (b.type == "FAMIX.Class" || b.type == "FAMIX.Interface" || b.type == "FAMIX.Report" ||
					b.type == "FAMIX.FunctionGroup") {

					floor.height = 0.4
				}
			}

			floor.position.x = bPosX
			floor.position.z = bPosZ
		}
	}

	// pko 2016
	def void calculateChimneys(Building b) {
		
		val cityFactory = new CityFactoryImpl
		val bWidth = b.width
		val bPosX = b.position.x
		val bPosZ = b.position.z
		val chimneys = b.data
		var courner1 = newArrayList()
		var courner2 = newArrayList()
		var courner3 = newArrayList()
		var courner4 = newArrayList()

		var chimneyCounter = 0

		for (chimney : chimneys) {
			
			chimney.parent = b
	
			if(config.showAttributesBelowBuildings){
				chimney.height = config.attributesBelowBuildingsHeight - 0.5
			} else {
				chimney.height = config.attributesHeight
			}
			chimney.width = 0.5
			chimney.length = 0.5

			chimney.color = 255 / 255.0 + " " + 252 / 255.0 + " " + 25 / 255.0
			chimney.position = cityFactory.createPosition

			if (chimneyCounter % 4 == 0) {
				courner1.add(chimney)
			}
			if (chimneyCounter % 4 == 1) {
				courner2.add(chimney)
			}
			if (chimneyCounter % 4 == 2) {
				courner3.add(chimney)
			}
			if (chimneyCounter % 4 == 3) {
				courner4.add(chimney)
			}
			chimneyCounter++
		}

		chimneyCounter = 0
		for (chimney : courner1) {
			chimney.position.x = (bPosX - ( bWidth / 2) ) + 0.5 + (1 * chimneyCounter)
			chimney.position.y = getYforChimney(b, chimney)
			chimney.position.z = (bPosZ - ( bWidth / 2) ) + 0.5
			chimneyCounter++
		}

		chimneyCounter = 0
		for (chimney : courner2) {
			chimney.position.x = (bPosX + ( bWidth / 2) ) - 0.5
			chimney.position.y = getYforChimney(b, chimney)
			chimney.position.z = (bPosZ - ( bWidth / 2) ) + 0.5 + (1 * chimneyCounter)
			chimneyCounter++
		}

		chimneyCounter = 0
		for (chimney : courner3) {
			chimney.position.x = (bPosX + ( bWidth / 2) ) - 0.5 - (1 * chimneyCounter)
			chimney.position.y = getYforChimney(b, chimney)
			chimney.position.z = (bPosZ + ( bWidth / 2) ) - 0.5
			chimneyCounter++
		}

		chimneyCounter = 0
		for (chimney : courner4) {
			chimney.position.x = (bPosX - ( bWidth / 2) ) + 0.5
			chimney.position.y = getYforChimney(b, chimney)
			chimney.position.z = (bPosZ + ( bWidth / 2) ) - 0.5 - (1 * chimneyCounter)
			chimneyCounter++
		}
	}
	def void calculateAdvChimneys(Building b){
		//advanced chimneys currently only work for reports, tables & interfaces		
		if (b.type != "FAMIX.Report" && b.type != "FAMIX.Class" && b.type != "FAMIX.Table"){
			return
		}
		
		if (b.data == 0){
			return
		}
		
		if (b.type == "FAMIX.Table"){
			createAdvChimneysTable(b)
		} else {
			//calculateChimneys(b)			
			createAdvChimneys(b)
		}
	}
		
		
	def void createAdvChimneys(Building b) {
		val cityFactory = new CityFactoryImpl
//		var bWidth   = b.width // 2 -> attributeWidth * 3 (4)
        //var bWidth   = config.getAdvBuildungAttributeWidth(b.type)
        var bWidth   = b.width //* config.getAbapAdvBuildingDefSize("FAMIX.Class")
		var bPosX    = b.position.x  
		var bPosZ    = b.position.z 				
		val chimneys = b.data
		var courner1 = newArrayList()
		var courner2 = newArrayList()
		var courner3 = newArrayList()
		var courner4 = newArrayList()

		var chimneyCounter = 0

//        if (b.type == "FAMIX.Class"){
////        	bWidth = b.width - 4
//////        	bWidth = b.width - config.getAdvBuildungAttributeWidth(b.type) 
//        	bWidth = config.getAdvBuildungAttributeWidth(b.type) * 4.4
//////        	bWidth = getAdvBuildingWidth(b.type, 1.0) - 2
//        	bPosX  = b.position.x + 0.75
//            bPosZ  = b.position.z + 0.25
//        } else if (b.type == "FAMIX.Report"){
////          	bWidth = b.width - 10
//          	bWidth = b.width - config.getAdvBuildungAttributeWidth(b.type) 
////          	bWidth = config.getAdvBuildungAttributeWidth(b.type) * 4.4
////          	bPosX  = b.position.x + 1.5
////          	bPosZ  = b.position.z + 5.5
//
//	        bPosX  = b.position.x + 1
//          	bPosZ  = b.position.z + 2
//        }
        

        	if (b.type == "FAMIX.Class"){ 
        		//scale 1
//        		b.type = "FAMIX.InterfaceAttribute"
	        	bWidth = b.width * ( config.getAbapAdvBuildingDefSize("FAMIX.InterfaceAttribute") + 1);
	        	
	        	//bPosX = b.position.x + 1
	        	
	        	//config.getAbapAdvBuildingScale("FAMIX.InterfaceAttribute")
	        	
	        	//scale 0.25
//	        	bWidth = config.getAdvBuildungAttributeWidth(b.type) * 4.4
	        	bPosX  = b.position.x + 1
//	            bPosZ  = b.position.z + 0.25
for (chimney : chimneys) {
			
			chimney.parent = b
						
			chimney.height = config.attributesHeight
			
			
			chimney.width = config.getAdvBuildungAttributeWidth(b.type)
			chimney.length = config.getAdvBuildungAttributeWidth(b.type)

			chimney.color = 255 / 255.0 + " " + 252 / 255.0 + " " + 25 / 255.0
			chimney.position = cityFactory.createPosition 

			if (chimneyCounter % 4 == 0) {
				courner1.add(chimney)
			}
			if (chimneyCounter % 4 == 1) {
				courner2.add(chimney)
			}
			if (chimneyCounter % 4 == 2) {
				courner3.add(chimney)
			}
			if (chimneyCounter % 4 == 3) {
				courner4.add(chimney)
			}
			chimneyCounter++
		}

		chimneyCounter = 0
		for (chimney : courner1) {
//			if (b.type == "FAMIX.Class"){
				chimney.position.x = (bPosX - ( bWidth / 2) ) + 0.5 + (config.getAbapAdvBuildingDefSize("FAMIX.InterfaceAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.InterfaceAttribute"))
//			} else if(b.type == "FAMIX.Report"){
//				chimney.position.x = (bPosX - ( bWidth / 2) ) + 0.5 + (config.getAbapAdvBuildingDefSize("FAMIX.ReportAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.ReportAttribute"))
//			}
			chimney.position.y = getAdvYforChimney(b)
			chimney.position.z = (bPosZ - ( bWidth / 2) ) + 0.5
			chimneyCounter++
		}

		chimneyCounter = 0
		for (chimney : courner2) {
			chimney.position.x = (bPosX + ( bWidth / 2) ) - 0.5
			chimney.position.y = getAdvYforChimney(b)
//			if (b.type == "FAMIX.Class"){
			chimney.position.z = (bPosZ - ( bWidth / 2) ) + 0.5 + (config.getAbapAdvBuildingDefSize("FAMIX.InterfaceAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.InterfaceAttribute"))
//			} else if(b.type == "FAMIX.Report"){
//				chimney.position.z = (bPosZ - ( bWidth / 2) ) + 0.5 + (config.getAbapAdvBuildingDefSize("FAMIX.ReportAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.ReportAttribute"))			
//			}
			chimneyCounter++
		}

		chimneyCounter = 0
		for (chimney : courner3) {
//			if(b.type == "FAMIX.Class"){
			chimney.position.x = (bPosX + ( bWidth / 2) ) - 0.5 - (config.getAbapAdvBuildingDefSize("FAMIX.InterfaceAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.InterfaceAttribute"))
//			} else if(b.type == "FAMIX.Report"){
//			chimney.position.x = (bPosX + ( bWidth / 2) ) - 0.5 - (config.getAbapAdvBuildingDefSize("FAMIX.ReportAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.ReportAttribute"))				
//			}	
			chimney.position.y = getAdvYforChimney(b)
			chimney.position.z = (bPosZ + ( bWidth / 2) ) - 0.5
			chimneyCounter++
		}

		chimneyCounter = 0
		for (chimney : courner4) {
			chimney.position.x = (bPosX - ( bWidth / 2) ) + 0.5
			chimney.position.y = getAdvYforChimney(b)
//			if(b.type == "FAMIX.Class"){
			chimney.position.z = (bPosZ + ( bWidth / 2) ) - 0.5 - (config.getAbapAdvBuildingDefSize("FAMIX.InterfaceAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.InterfaceAttribute"))
//			} else if(b.type == "FAMIX.Report"){
//				chimney.position.z = (bPosZ + ( bWidth / 2) ) - 0.5 - (config.getAbapAdvBuildingDefSize("FAMIX.ReportAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.ReportAttribute"))	
//			}
			
			
			chimneyCounter++
		}		
       	    } else if (b.type == "FAMIX.Report"){
//       	    	b.type = ("FAMIX.ReportAttribut")
	          	bWidth = b.width *( config.getAbapAdvBuildingDefSize("FAMIX.ReportAttribute") + 1); 
//		        bPosX  = b.position.x + 1
//	          	bPosZ  = b.position.z + 1.5
for (chimney : chimneys) {
			
			chimney.parent = b
						
			chimney.height = config.attributesHeight
			
			
			chimney.width = config.getAdvBuildungAttributeWidth(b.type)
			chimney.length = config.getAdvBuildungAttributeWidth(b.type)

			chimney.color = 255 / 255.0 + " " + 252 / 255.0 + " " + 25 / 255.0
			chimney.position = cityFactory.createPosition 

			if (chimneyCounter % 4 == 0) {
				courner1.add(chimney)
			}
			if (chimneyCounter % 4 == 1) {
				courner2.add(chimney)
			}
			if (chimneyCounter % 4 == 2) {
				courner3.add(chimney)
			}
			if (chimneyCounter % 4 == 3) {
				courner4.add(chimney)
			}
			chimneyCounter++
		}

		chimneyCounter = 0
		for (chimney : courner1) {
//		
				chimney.position.x = (bPosX - ( bWidth / 2) ) + 0.5 + (config.getAbapAdvBuildingDefSize("FAMIX.ReportAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.ReportAttribute"))
//			
			chimney.position.y = getAdvYforChimney(b)
			chimney.position.z = (bPosZ - ( bWidth / 2) ) + 0.5
			chimneyCounter++
		}

		chimneyCounter = 0
		for (chimney : courner2) {
			chimney.position.x = (bPosX + ( bWidth / 2) ) - 0.5
			chimney.position.y = getAdvYforChimney(b)
//			
				chimney.position.z = (bPosZ - ( bWidth / 2) ) + 0.5 + (config.getAbapAdvBuildingDefSize("FAMIX.ReportAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.ReportAttribute"))			
//			
			chimneyCounter++
		}

		chimneyCounter = 0
		for (chimney : courner3) {
//			
			chimney.position.x = (bPosX + ( bWidth / 2) ) - 0.5 - (config.getAbapAdvBuildingDefSize("FAMIX.ReportAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.ReportAttribute"))				
//				
			chimney.position.y = getAdvYforChimney(b)
			chimney.position.z = (bPosZ + ( bWidth / 2) ) - 0.5
			chimneyCounter++
		}

		chimneyCounter = 0
		for (chimney : courner4) {
			chimney.position.x = (bPosX - ( bWidth / 2) ) + 0.5
			chimney.position.y = getAdvYforChimney(b)
//			
				chimney.position.z = (bPosZ + ( bWidth / 2) ) - 0.5 - (config.getAbapAdvBuildingDefSize("FAMIX.ReportAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.ReportAttribute"))	
//			
			
			
			chimneyCounter++
		}		
//            } else if (b.type == "FAMIX.Table"){
//            	bWidth = config.getAdvBuildungAttributeWidth(b.type) * 3
//            	bPosX  = b.position.x //- 7.5
//	          	bPosZ  = b.position.z - 6 
            }
        

//		for (chimney : chimneys) {
//			
//			chimney.parent = b
//						
//			chimney.height = config.attributesHeight
//			
//			
//			chimney.width = config.getAdvBuildungAttributeWidth(b.type)
//			chimney.length = config.getAdvBuildungAttributeWidth(b.type)
//
//			chimney.color = 255 / 255.0 + " " + 252 / 255.0 + " " + 25 / 255.0
//			chimney.position = cityFactory.createPosition 
//
//			if (chimneyCounter % 4 == 0) {
//				courner1.add(chimney)
//			}
//			if (chimneyCounter % 4 == 1) {
//				courner2.add(chimney)
//			}
//			if (chimneyCounter % 4 == 2) {
//				courner3.add(chimney)
//			}
//			if (chimneyCounter % 4 == 3) {
//				courner4.add(chimney)
//			}
//			chimneyCounter++
//		}
//
//		chimneyCounter = 0
//		for (chimney : courner1) {
////			if (b.type == "FAMIX.Class"){
//				chimney.position.x = (bPosX - ( bWidth / 2) ) + 0.5 + (config.getAbapAdvBuildingDefSize("FAMIX.InterfaceAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.InterfaceAttribute"))
////			} else if(b.type == "FAMIX.Report"){
////				chimney.position.x = (bPosX - ( bWidth / 2) ) + 0.5 + (config.getAbapAdvBuildingDefSize("FAMIX.ReportAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.ReportAttribute"))
////			}
//			chimney.position.y = getAdvYforChimney(b)
//			chimney.position.z = (bPosZ - ( bWidth / 2) ) + 0.5
//			chimneyCounter++
//		}
//
//		chimneyCounter = 0
//		for (chimney : courner2) {
//			chimney.position.x = (bPosX + ( bWidth / 2) ) - 0.5
//			chimney.position.y = getAdvYforChimney(b)
////			if (b.type == "FAMIX.Class"){
//			chimney.position.z = (bPosZ - ( bWidth / 2) ) + 0.5 + (config.getAbapAdvBuildingDefSize("FAMIX.InterfaceAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.InterfaceAttribute"))
////			} else if(b.type == "FAMIX.Report"){
////				chimney.position.z = (bPosZ - ( bWidth / 2) ) + 0.5 + (config.getAbapAdvBuildingDefSize("FAMIX.ReportAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.ReportAttribute"))			
////			}
//			chimneyCounter++
//		}
//
//		chimneyCounter = 0
//		for (chimney : courner3) {
////			if(b.type == "FAMIX.Class"){
//			chimney.position.x = (bPosX + ( bWidth / 2) ) - 0.5 - (config.getAbapAdvBuildingDefSize("FAMIX.InterfaceAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.InterfaceAttribute"))
////			} else if(b.type == "FAMIX.Report"){
////			chimney.position.x = (bPosX + ( bWidth / 2) ) - 0.5 - (config.getAbapAdvBuildingDefSize("FAMIX.ReportAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.ReportAttribute"))				
////			}	
//			chimney.position.y = getAdvYforChimney(b)
//			chimney.position.z = (bPosZ + ( bWidth / 2) ) - 0.5
//			chimneyCounter++
//		}
//
//		chimneyCounter = 0
//		for (chimney : courner4) {
//			chimney.position.x = (bPosX - ( bWidth / 2) ) + 0.5
//			chimney.position.y = getAdvYforChimney(b)
////			if(b.type == "FAMIX.Class"){
//			chimney.position.z = (bPosZ + ( bWidth / 2) ) - 0.5 - (config.getAbapAdvBuildingDefSize("FAMIX.InterfaceAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.InterfaceAttribute"))
////			} else if(b.type == "FAMIX.Report"){
////				chimney.position.z = (bPosZ + ( bWidth / 2) ) - 0.5 - (config.getAbapAdvBuildingDefSize("FAMIX.ReportAttribute") * chimneyCounter * config.getAbapAdvBuildingScale("FAMIX.ReportAttribute"))	
////			}
//			
//			
//			chimneyCounter++
//		}		
	}

     def void createAdvChimneysTable(Building b) {		
		val cityFactory = new CityFactoryImpl
		val chimneys = b.data
		var chimneyCounter = 0
		var Sx = 0
		var Sy = 0
		var Sz = 0		

		for (chimney : chimneys) {
			
			chimney.parent = b
	
			chimney.height = config.attributesHeight

			chimney.width = 0.5
			chimney.length = 0.5

			chimney.color = 255 / 255.0 + " " + 252 / 255.0 + " " + 25 / 255.0
			chimney.position = cityFactory.createPosition
            
            //distance between two boxes 
			var dl = 1.5
			var dh = 0.6
			var dw = 1
			
			chimney.position.x = (b.position.x - config.getTableFieldsStartX()) + (Sx * (config.getTableFieldsWidth() * dl))
			chimney.position.y = (b.position.y + config.getTableFieldsStartY()) + (Sy * (config.getTableFieldsHeight() * dh))
			chimney.position.z = (b.position.z - config.getTableFieldsStartZ()) + (Sz * (config.getTableFieldsLength() * dw))
		
//			println(Sz + " " + Sx  + " " + Sy )

			if ( Sz == 1) {
				if( Sx == 4){
					Sy++
					Sx = 0 
				} else {
					Sx++	
				}	
			}	
			
			if (Sz == 1) { 
				Sz = 0
			} else { 
				Sz = 1
			}
			
			chimneyCounter++;
		}
	}

	// Display chimneys at top/bottom (depends on settings)
	def double getYforChimney(Building b, BuildingSegment chimney) {
		if (config.showAttributesBelowBuildings) {
			return (b.position.y - ( b.height / 2) ) - (chimney.height / 2 + 0.25)
		} else {
			return (b.position.y + ( b.height / 2) ) + 0.5 // Original
		}
	}
	
	def double getAdvYforChimney(Building b){
		var baseHeight = config.getAdvBuildingBaseHeight(b.type)
		var floorHeight = config.getAdvBuildingFloorHeight(b.type)
		var roofHeight = config.getAdvBuildingRoofHeight(b.type)
		var attributeHeight = config.getAdvBuildungAttributeHeight(b.type)
		
//		var elementHeight = config.getAbapSimpleBlock_element_height(b.type)

		
//		if (config.abapAdvCity_set == AbapAdvCitySet::CustomModels) {
        		return (b.position.y + baseHeight + (b.methodCounter * floorHeight) + roofHeight) - attributeHeight        	
//        } else if(config.abapAdvCity_set == AbapAdvCitySet::SimpleBlocks) {
//        	return (b.position.y + b.methodCounter * elementHeight) + 0.25
//        }
		
	}	

	def double getScaledHeightofSco(double unscaledHeight) {
		switch (config.height_Scaling) {
			case INTERVAL: {
				if (unscaledHeight < config.getAbapScoMinHeight) 
					return config.getAbapScoMinHeight
				else if (unscaledHeight > config.getAbapScoMaxHeight)
					return config.getAbapScoMaxHeight
				else
					return unscaledHeight
			}
			case LOGARITHMIC: {
				if (unscaledHeight < 1)
					return 1.0
				return Math.floor(Math.log(unscaledHeight) / Math.log(config.getAbapLogarithmBase) + 1) //muss so sein, weil sonst höhe = log(NOS = 1) = 0 wird
			}
			case NOSCALING: {
				return unscaledHeight
			}
			default: {
				return unscaledHeight
			}
		}
	}
	
	def double getAdvBuildingWidth(String type, double adjustSize) {
		return config.getAbapAdvBuildingDefSize(type) * config.getAbapAdvBuildingScale(type) * adjustSize
	}
	
	def double getAdvBuildingLength(String type, double adjustSize) {
		return config.getAbapAdvBuildingDefSize(type) * config.getAbapAdvBuildingScale(type) * adjustSize
	}
	
	def Building createAdvBuildingBase(String type) {
		var base = cityFactory.createBuilding
		base.height = 0
		base.type = "Base"		
		return base
	}
	
	def Building createAdvBuildingFloor(String type, int level) {
		var floor = cityFactory.createBuilding
		floor.height = config.getAdvBuildingBaseHeight(type) + (level - 1) * config.getAdvBuildingFloorHeight(type)
		floor.type = "Floor"	
		return floor
	}
	
	def Building createAdvBuildingRoof(String type, double bHeight) {
		var roof = cityFactory.createBuilding
		roof.height = config.getAdvBuildingBaseHeight(type) + (bHeight - 1) * config.getAdvBuildingFloorHeight(type)
		roof.type = "Roof"		
		return roof
	}
	
	def Building createAdvBuildingChimney(BuildingSegment bs) {
		var chimney = cityFactory.createBuilding
		chimney.type = "Chimney"
		chimney.name = bs.value
		return chimney
	}
	
}
