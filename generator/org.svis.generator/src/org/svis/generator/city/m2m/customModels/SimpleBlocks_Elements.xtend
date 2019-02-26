package org.svis.generator.city.m2m.customModels

import org.svis.xtext.city.Entity

class SimpleBlocks_Elements {
	def static String createCylinder(Entity entity, double adjustRadius, double translationHeight, double elementHeight, String color) '''
		<Transform translation='0 0 «translationHeight»'>
			<Shape>
				<Cylinder radius='«entity.width / adjustRadius»' height='«elementHeight»'></Cylinder>
				<Appearance>
					<Material diffuseColor='«color»' transparency='«entity.transparency»'></Material>
				</Appearance>
			</Shape>
		</Transform>
	'''
}