package org.svis.generator.city.m2m.customModels

import org.svis.generator.city.CityUtils

class CustomModel_ReportAttribute {

	def static String defineReportAttributeShape()'''
		<Group DEF="ReportAttribute">
			««« Walls
			<Shape>
			   <Appearance>
					<Material DEF="MA_Material_001"
							  diffuseColor="0.800 0.800 0.800"
							  specularColor="0.401 0.401 0.401"
							  emissiveColor="0.000 0.000 0.000"
							  ambientIntensity="0.333"
							  shininess="0.098"
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
		</Group>
	'''

	def static createReportAttributeShape()'''
		<Group USE="ReportAttribute"/>
	'''
}