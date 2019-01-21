package org.svis.generator.city.m2m;

import org.eclipse.emf.common.util.EList;
import org.svis.generator.SettingsConfiguration;
import org.svis.xtext.city.Entity;
import org.svis.xtext.city.Root;

public class CityHeightLayout {
	
	private static SettingsConfiguration config = SettingsConfiguration.getInstance();
	
	public static void cityHeightLayout(Root root) {
		adjustHeight(root.getDocument().getEntities(), 0);
	}
	
	public static void adjustHeight(EList<Entity> children, double parentY) {
		for (Entity e : children) {
			double y = e.getPosition().getY();
			if (e.getType().equals("FAMIX.Namespace") || e.getType().equals("reportDistrict") || e.getType().equals("classDistrict")
					|| e.getType().equals("functionGroupDistrict") || e.getType().equals("tableDistrict") || e.getType().equals("interfaceDistrict")
					|| e.getType().equals("dcDataDistrict") || e.getType().equals("domainDistrict") || e.getType().equals("structureDistrict") 
					/*|| e.getType().equals("FAMIX.FunctionModule")*/|| e.getType().equals("FAMIX.StrucElement")
					|| e.getType().equals("FAMIX.Report") || e.getType().equals("FAMIX.Formroutine")
					|| e.getType().equals("FAMIX.DataElement")|| e.getType().equals("FAMIX.Table")
					|| e.getType().equals("FAMIX.TableType")|| e.getType().equals("FAMIX.ABAPStruc")
          || e.getType().equals("FAMIX.Domain") || e.getType().equals("FAMIX.Class")
          || e.getType().equals("FAMIX.Method")
          
				y = e.getHeight() / 2;
			}
			
			e.getPosition().setY(y + parentY + config.getBuildingVerticalMargin());		
			
			if (e.getType().equals("FAMIX.Namespace") || e.getType().equals("reportDistrict") || e.getType().equals("classDistrict")
					|| e.getType().equals("functionGroupDistrict") || e.getType().equals("tableDistrict") || e.getType().equals("interfaceDistrict") 
					|| e.getType().equals("dcDataDistrict") || e.getType().equals("domainDistrict")|| e.getType().equals("structureDistrict")){
				double newUpperLeftY = e.getPosition().getY() - e.getHeight() / 2;
				adjustHeight(e.getEntities(), newUpperLeftY);
			}
		}
		
		
	}
}
