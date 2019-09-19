package org.svis.generator.city.m2m;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.eclipse.emf.common.util.EList;
import org.eclipse.osgi.container.Module.Settings;
import org.svis.generator.SettingsConfiguration;
import org.svis.generator.SettingsConfiguration.BuildingType;
import org.svis.generator.SettingsConfiguration.DistrictLayoutVersion;
import org.svis.generator.SettingsConfiguration.FamixParser;
import org.svis.xtext.city.Building;
import org.svis.xtext.city.CityFactory;
import org.svis.xtext.city.Document;
import org.svis.xtext.city.Entity;
import org.svis.xtext.city.Position;
import org.svis.xtext.city.Root;
import org.svis.xtext.city.impl.CityFactoryImpl;

public class ABAPCityLayout {
	private static boolean DEBUG = false;
	private static boolean DEBUG_Part1 = false;
	private static boolean DEBUG_Part2 = false;
	private static String info = "[INFOstream] ";
	private static CityFactory cityFactory = new CityFactoryImpl();
	public static Rectangle rootRectangle;
	private static SettingsConfiguration config = SettingsConfiguration.getInstance();


	/**
	 * @param root
	 *             <p>
	 *             this method starts the layout-process
	 *             </p>
	 */
	public static void cityLayout(Root root) {
		if (DEBUG) {
			System.out.println(info + "cityLayout(root)-arrival.");
		}

		// receives List of ALL CITYelements in the form of the root element
		if (config.getAbapNotInOrigin_layout() == SettingsConfiguration.NotInOriginLayout.DEFAULT)
			arrangeChildrenDefault(root.getDocument());
		else if (config.getAbapNotInOrigin_layout() == SettingsConfiguration.NotInOriginLayout.CIRCULAR)
			arrangeChildrenCircular(root.getDocument());
		
		adjustPositions(root.getDocument().getEntities(), 0, 0);

		if (DEBUG) {
			System.out.println(info + "cityLayout(root)-exit.");
		}
	}

	/* functions for Document */
	private static void arrangeChildrenDefault(Document document) {
		// get maxArea (worst case) for root of KDTree
		Rectangle docRectangle = calculateMaxArea(document);
		CityKDTree ptree = new CityKDTree(docRectangle);
		Rectangle covrec = new Rectangle();
		List<Rectangle> elements = sortChildrenAsRectangles(document.getEntities());

		// algorithm
		for (Rectangle el : elements) {
			List<CityKDTreeNode> pnodes = ptree.getFittingNodes(el);
			Map<CityKDTreeNode, Double> preservers = new LinkedHashMap<CityKDTreeNode, Double>(); // LinkedHashMap
																									// necessary, so
																									// elements are
																									// ordered by
																									// inserting-order
			Map<CityKDTreeNode, Double> expanders = new LinkedHashMap<CityKDTreeNode, Double>();
			CityKDTreeNode targetNode = new CityKDTreeNode();
			CityKDTreeNode fitNode = new CityKDTreeNode();

			// check all empty leaves: either they extend COVREC (->expanders) or it doesn't
			// change (->preservers)
			for (CityKDTreeNode pnode : pnodes) {
				sortEmptyLeaf(pnode, el, covrec, preservers, expanders);
			}

			// choose best-fitting pnode
			if (preservers.isEmpty() != true) {
				targetNode = bestFitIsPreserver(preservers.entrySet());
			} else {
				targetNode = bestFitIsExpander(expanders.entrySet());
			}

			// modify targetNode if necessary
			if (targetNode.getRectangle().getWidth() == el.getWidth()
					&& targetNode.getRectangle().getLength() == el.getLength()) { // this if could probably be skipped,
																					// trimmingNode() always returns
																					// fittingNode
				fitNode = targetNode;
			} else {
				fitNode = trimmingNode(targetNode, el);
			}

			// set fitNode as occupied
			fitNode.setOccupied(true);

			// give Entity it's Position
			setNewPosition(el, fitNode);

			// if fitNode expands covrec, update covrec
			if (fitNode.getRectangle().getBottomRightX() > covrec.getBottomRightX()
					|| fitNode.getRectangle().getBottomRightY() > covrec.getBottomRightY()) {
				updateCovrec(fitNode, covrec);
			}
		}

		rootRectangle = covrec; // used to adjust viewpoint in x3d
	}

	private static void arrangeChildrenCircular(Document document) {
		// get maxArea (worst case) for root of KDTree
		Rectangle docRectangle = calculateMaxArea(document);
		CityKDTree ptree = new CityKDTree(docRectangle);
		Rectangle covrec = new Rectangle();
		List<Rectangle> elements = sortChildrenAsRectangles(document.getEntities());
		
		List<Rectangle> originSet = new ArrayList<Rectangle>();
		List<Rectangle> customCode = new ArrayList<Rectangle>();
		List<Rectangle> standardCode = new ArrayList<Rectangle>();
		
		// order the rectangles to the fit sets
		for (Rectangle element : elements) {
			if (element.getEntityLink().getNotInOrigin() == null && element.getEntityLink().getIsStandard() == null)
				originSet.add(element);
			else if (element.getEntityLink().getNotInOrigin().equals("true") && element.getEntityLink().getIsStandard() == null)
				customCode.add(element);
			else if (element.getEntityLink().getNotInOrigin().equals("true") && element.getEntityLink().getIsStandard().equals("true"))
				standardCode.add(element);
		}

		// Light Map algorithm for the origin set
		for (Rectangle el : originSet) {
			List<CityKDTreeNode> pnodes = ptree.getFittingNodes(el);
			Map<CityKDTreeNode, Double> preservers = new LinkedHashMap<CityKDTreeNode, Double>(); // LinkedHashMap
																									// necessary, so
																									// elements are
																									// ordered by
																									// inserting-order
			Map<CityKDTreeNode, Double> expanders = new LinkedHashMap<CityKDTreeNode, Double>();
			CityKDTreeNode targetNode = new CityKDTreeNode();
			CityKDTreeNode fitNode = new CityKDTreeNode();

			// check all empty leaves: either they extend COVREC (->expanders) or it doesn't
			// change (->preservers)
			for (CityKDTreeNode pnode : pnodes) {
				sortEmptyLeaf(pnode, el, covrec, preservers, expanders);
			}

			// choose best-fitting pnode
			if (preservers.isEmpty() != true) {
				targetNode = bestFitIsPreserver(preservers.entrySet());
			} else {
				targetNode = bestFitIsExpander(expanders.entrySet());
			}

			// modify targetNode if necessary
			if (targetNode.getRectangle().getWidth() == el.getWidth()
					&& targetNode.getRectangle().getLength() == el.getLength()) { // this if could probably be skipped,
																					// trimmingNode() always returns
																					// fittingNode
				fitNode = targetNode;
			} else {
				fitNode = trimmingNode(targetNode, el);
			}

			// set fitNode as occupied
			fitNode.setOccupied(true);

			// give Entity it's Position
			setNewPosition(el, fitNode);

			// if fitNode expands covrec, update covrec
			if (fitNode.getRectangle().getBottomRightX() > covrec.getBottomRightX()
					|| fitNode.getRectangle().getBottomRightY() > covrec.getBottomRightY()) {
				updateCovrec(fitNode, covrec);
			}
		}
		
		arrangeDistrictsCircular(customCode, covrec);
		arrangeDistrictsCircular(standardCode, covrec);		
		
		rootRectangle = covrec; // used to adjust viewpoint in x3d
	}
	
	private static void arrangeDistrictsCircular(List<Rectangle> elements, Rectangle covrec) {
		
		double covrecRadius = covrec.getPerimeterRadius() + config.getBuildingHorizontalGap();
		
		if (elements.size() == 0)
			return;
		else {			
			Rectangle biggestRec = elements.get(0);
			
			// radius of the biggest district
			double maxOuterRadius = biggestRec.getPerimeterRadius();
			
			double minRadius = maxOuterRadius
									+ covrecRadius
									+ config.getBuildingHorizontalGap();
			
			double maxRadius = 0;
			
			// upper estimation of the radius, only for sets with several elements
			if (elements.size() > 1)		
				maxRadius = maxOuterRadius / Math.sin(Math.PI / elements.size()) 
									+ config.getBuildingHorizontalGap();
		
			double radius = Math.max(minRadius, maxRadius);
			
			Position initialPos = cityFactory.createPosition();
			initialPos.setX(covrec.getCenterX() + radius);
			initialPos.setZ(covrec.getCenterY());
			
			biggestRec.getEntityLink().setPosition(initialPos);
			
			if (elements.size() > 1) {
				SettingsConfiguration.NotInOriginLayoutVersion version = config.getAbapNotInOrigin_layout_version();
				
				for (int i = 1; i < elements.size(); ++i) {
					
					Rectangle previousRec = elements.get(i - 1);
					Rectangle currentRec = elements.get(i);

					double previousRadius = previousRec.getPerimeterRadius();
							//+ config.getBuildingHorizontalGap();
					
					double currentRadius = currentRec.getPerimeterRadius();
							//+ config.getBuildingHorizontalGap();
					
					double rotationAngle = 0;
					
					switch(version) {
						case MINIMAL_DISTANCE:
//							rotationAngle = Math.acos(1 - (Math.pow(previousRadius + currentRadius, 2) / (2 * Math.pow(radius, 2))));
							rotationAngle = 2 * Math.asin((previousRadius + currentRadius) / (2 * radius));
							break;
						case CONSTANT_DISTANCE:
							rotationAngle = 2 * Math.asin(maxOuterRadius / radius);
							break;
						case FULL_CIRCLE:
							rotationAngle = 2 * Math.PI / elements.size();
							break;					
						default:
//							rotationAngle = Math.acos(1 - (Math.pow(previousRadius + currentRadius, 2) / (2 * Math.pow(radius, 2))));
							rotationAngle = 2 * Math.asin((previousRadius + currentRadius) / (2 * radius));
							break;					
					}

					Position newPos = cityFactory.createPosition();
					
					double newX = (previousRec.getEntityLink().getPosition().getX() - covrec.getCenterX()) * Math.cos(rotationAngle)
							- (previousRec.getEntityLink().getPosition().getZ() - covrec.getCenterY()) * Math.sin(rotationAngle)
							+ covrec.getCenterX();
					
					newPos.setX(newX);
					
					double newZ = (previousRec.getEntityLink().getPosition().getX() - covrec.getCenterX()) * Math.sin(rotationAngle)
							+ (previousRec.getEntityLink().getPosition().getZ() - covrec.getCenterY()) * Math.cos(rotationAngle)
							+ covrec.getCenterY();

					newPos.setZ(newZ);

					currentRec.getEntityLink().setPosition(newPos);
				}
			}
			
			double newCovrecWidth = 2 * radius + (biggestRec.getWidth() > biggestRec.getLength() ? biggestRec.getWidth() : biggestRec.getLength());			
			covrec.changeRectangle(covrec.getCenterX(), covrec.getCenterY(), newCovrecWidth, newCovrecWidth, 0);
			
		}		
	}
	
	private static Rectangle calculateMaxArea(Document document) {
		if (DEBUG) {
			System.out.println("\t\t" + info + "calculateMaxArea(document)-arrival.");
		}
		EList<Entity> children = document.getEntities();
		double sum_width = 0;
		double sum_length = 0;

		for (Entity child : children) {
			if (config.getBuildingType() == BuildingType.CITY_DYNAMIC) {
				if (child.getType().equals("FAMIX.Namespace") || child.getType().equals("FAMIX.Class")) {
					if (DEBUG) {
						System.out.println("\t\t\t" + info + "layOut(" + child.getFqn() + ")-call, recursive.");
					}
					arrangeChildren(child);
				}
			} else {
				if (child.getType().equals("FAMIX.Namespace")) {
					if (DEBUG) {
						System.out.println("\t\t\t" + info + "layOut(" + child.getFqn() + ")-call, recursive.");
					}

					if (config.getDistrictLayout_Version() == DistrictLayoutVersion.OLD) {
						arrangeChildren(child);
					} else if (config.getDistrictLayout_Version() == DistrictLayoutVersion.NEW) {
						arrangeChildrenOfNamespace(child);
					}
				} else if (child.getType().equals("reportDistrict")	|| child.getType().equals("classDistrict") 
						|| child.getType().equals("functionGroupDistrict") || child.getType().equals("tableDistrict") 
						|| child.getType().equals("dcDataDistrict") || child.getType().equals("domainDistrict") 
						|| child.getType().equals("interfaceDistrict")	|| child.getType().equals("structureDistrict")
						|| child.getType().equals("virtualDomainDistrict") ) {
					if (DEBUG) {
						System.out.println("\t\t\t" + info + "layOut(" + child.getFqn() + ")-call, recursive.");
					}
					
					arrangeChildren(child);
				}
			}
			sum_width += child.getWidth() + config.getBuildingHorizontalGap();
			sum_length += child.getLength() + config.getBuildingHorizontalGap();
			if (DEBUG_Part1) {
				System.out.println("\t\t\t" + info + "Child " + child.getFqn() + " [modVALUES]: width="
						+ child.getWidth() + " length=" + child.getLength() + "|=> sum_width=" + sum_width
						+ " sum_length=" + sum_length);
			}
		}

		if (DEBUG) {
			System.out.println("\t\t" + info + "calculateMaxArea(document)-exit.");
		}
		return new Rectangle(0, 0, sum_width, sum_length, 1);
	}

	/* functions for Entity */
	private static void arrangeChildren(Entity entity) {
		if (DEBUG) {
			System.out.println("\t" + info + "layOut(" + entity.getFqn() + ")-arrival.");
		}
		// get maxArea (worst case) for root of KDTree
		if (DEBUG) {
			System.out.println("\t\t" + info + "calculateMaxArea(" + entity.getFqn() + ")-call.");
		}
		Rectangle entityRec = calculateMaxArea(entity);
		CityKDTree ptree = new CityKDTree(entityRec);
		if (DEBUG_Part1) {
			System.out.println(
					"\t\t" + info + "KDTree [checkVALUES]: root[(" + ptree.getRoot().getRectangle().getUpperLeftX()
							+ "|" + ptree.getRoot().getRectangle().getUpperLeftY() + "), ("
							+ ptree.getRoot().getRectangle().getBottomRightX() + "|"
							+ ptree.getRoot().getRectangle().getBottomRightY() + ")]");
		}
		Rectangle covrec = new Rectangle();
		if (DEBUG_Part1) {
			System.out.println(
					"\t\t" + info + "CovRec [checkVALUES]: [(" + covrec.getUpperLeftX() + "|" + covrec.getUpperLeftY()
							+ "), (" + covrec.getBottomRightX() + "|" + covrec.getBottomRightY() + ")]");
		}

		List<Rectangle> elements = new ArrayList<Rectangle>();

		elements = sortChildrenAsRectangles(entity.getEntities());

		// start algorithm
		for (Rectangle el : elements) {
			if (DEBUG_Part2) {
				System.out.println("\n\t\t" + info + "Entity " + el.getEntityLink().getFqn() + " starts algorithm.");
			}
			List<CityKDTreeNode> pnodes = ptree.getFittingNodes(el);
			if (DEBUG_Part2) {
				System.out.println("\n\t\t" + info + "show all fittingNodes!");
				int node_number = 0;
				for (CityKDTreeNode n : pnodes) {
					node_number++;
					System.out.println("\t\t" + info + "Node #" + node_number);
					System.out.println("\t\t" + info + "Node Rec[(" + n.getRectangle().getUpperLeftX() + "|"
							+ n.getRectangle().getUpperLeftY() + "), (" + n.getRectangle().getBottomRightX() + "|"
							+ n.getRectangle().getBottomRightY() + ")]");
				}
			}
			Map<CityKDTreeNode, Double> preservers = new LinkedHashMap<CityKDTreeNode, Double>(); // LinkedHashMap
																									// necessary, so
																									// elements are
																									// ordered by
																									// inserting-order
			Map<CityKDTreeNode, Double> expanders = new LinkedHashMap<CityKDTreeNode, Double>();
			CityKDTreeNode targetNode = new CityKDTreeNode();
			CityKDTreeNode fitNode = new CityKDTreeNode();

			// check all empty leaves: either they extend COVREC (->expanders) or it doesn't
			// change (->preservers)
			if (DEBUG_Part2) {
				System.out.println("\n\t\t" + info + "check all empty leaves!");
			}
			for (CityKDTreeNode pnode : pnodes) {
				sortEmptyLeaf(pnode, el, covrec, preservers, expanders);
			}

			// choose best-fitting pnode
			if (preservers.isEmpty() != true) {
				targetNode = bestFitIsPreserver(preservers.entrySet());
			} else {
				targetNode = bestFitIsExpander(expanders.entrySet());
			}

			// modify targetNode if necessary
			if (targetNode.getRectangle().getWidth() == el.getWidth()
					&& targetNode.getRectangle().getLength() == el.getLength()) { // this if could be skipped,
																					// trimmingNode() always returns
																					// fittingNode
				fitNode = targetNode;
				if (DEBUG_Part2) {
					System.out.println("\n\t\t" + info + "targetNode fits.");
				}
			} else {
				if (DEBUG_Part2) {
					System.out.println("\n\t\t" + info + "targetNode needs trimming.");
				}
				fitNode = trimmingNode(targetNode, el);
			}

			// set fitNode as occupied
			fitNode.setOccupied(true);

			// give Entity it's Position
			setNewPosition(el, fitNode);

			// if fitNode expands covrec, update covrec
			if (fitNode.getRectangle().getBottomRightX() > covrec.getBottomRightX()
					|| fitNode.getRectangle().getBottomRightY() > covrec.getBottomRightY()) {
				updateCovrec(fitNode, covrec);
			}
		}

		entity.setWidth(covrec.getBottomRightX()
				+ (config.getBuildingHorizontalMargin() - config.getBuildingHorizontalGap() / 2) * 2);
		entity.setLength(covrec.getBottomRightY()
				+ (config.getBuildingHorizontalMargin() - config.getBuildingHorizontalGap() / 2) * 2);
		if (DEBUG) {
			System.out.println("\t\t" + info + "Entity " + entity.getFqn() + " [checkVALUES]: width="
					+ entity.getWidth() + " length=" + entity.getLength());
		}
		if (DEBUG) {
			System.out.println("\t" + info + "layOut(" + entity.getFqn() + ")-exit.");
		}
	}

	private static Rectangle calculateMaxArea(Entity entity) {
		if (DEBUG) {
			System.out.println("\t\t" + info + "calculateMaxArea(" + entity.getFqn() + ")-arrival.");
		}
		EList<Entity> children = entity.getEntities();
		double sum_width = 0;
		double sum_length = 0;

		for (Entity child : children) {
			if (config.getBuildingType() == BuildingType.CITY_DYNAMIC) {
				if (child.getType().equals("FAMIX.Namespace") || child.getType().equals("FAMIX.Class")) {
					if (DEBUG) {
						System.out.println("\t\t\t" + info + "layOut(" + child.getFqn() + ")-call, recursive.");
					}
					arrangeChildren(child);
				}
			} else {
				if (child.getType().equals("FAMIX.Namespace") || child.getType().equals("tableDistrict") /*|| child.getType().equals("interfaceDistrict")*/
					|| child.getType().equals("dcDataDistrict")) {					
					if (DEBUG) {
						System.out.println("\t\t\t" + info + "layOut(" + child.getFqn() + ")-call, recursive.");
					}
					arrangeChildren(child);
				} else if (child.getType().equals("classDistrict")) {
					arrangeClassDistrict(child);
//				} else if (child.getType().equals("tableDistrict")) {
//					arrangeTableDistrict(child);	
				} else if (child.getType().equals("functionGroupDistrict")) {
					arrangeFunctionGroupDistrict(child);
				} else if (child.getType().equals("reportDistrict")) {
					arrangeReportDistrict(child);
				} else if (child.getType().equals("domainDistrict")) {
					arrangeDomainDistrict(child);
				} else if (child.getType().equals("virtualDomainDistrict")) {
				    arrangeVirtualDomainDistrict(child);
				} else if (child.getType().equals("structureDistrict")) {
					arrangeStructureDistrict(child);
				} else if (child.getType().equals("interfaceDistrict")) {
				    arrangeInterfaceDistrict(child);
				}
			}
			sum_width += child.getWidth() + config.getBuildingHorizontalGap();
			sum_length += child.getLength() + config.getBuildingHorizontalGap();
			if (DEBUG_Part1) {
				System.out.println("\t\t\t" + info + "Child " + child.getFqn() + " [modVALUES]: width="
						+ child.getWidth() + " length=" + child.getLength() + "|=> sum_width=" + sum_width
						+ " sum_length=" + sum_length);
			}
		}

		if (DEBUG_Part1) {
			System.out.println("\t\t\t" + info + "Entity " + entity.getFqn() + " [newVALUES]: width="
					+ entity.getWidth() + " length=" + entity.getLength());
		}
		if (DEBUG) {
			System.out.println("\t\t" + info + "calculateMaxArea(" + entity.getFqn() + ")-exit.");
		}
		return new Rectangle(0, 0, sum_width, sum_length, 1);
	}
	

	private static void arrangeChildrenOfNamespace(Entity entity) {

		// Berechnung des größtmöglichen Rechtecks
		Rectangle entityRec = calculateMaxArea(entity);

		CityKDTree ptree = new CityKDTree(entityRec);

		Rectangle covrec = new Rectangle();		

		List<Rectangle> classes = new ArrayList<Rectangle>();
		List<Rectangle> functionGroups = new ArrayList<Rectangle>();
		List<Rectangle> reports = new ArrayList<Rectangle>();
		List<Rectangle> structures = new ArrayList<Rectangle>();
		List<Rectangle> dataElements = new ArrayList<Rectangle>();
		List<Rectangle> tables = new ArrayList<Rectangle>();

		// copy all child-elements into a List<Rectangle> (for easier sort) with links
		// to former entities
		for (Entity e : entity.getEntities()) {
			Rectangle rectangle = new Rectangle(0, 0, e.getWidth() + config.getBuildingHorizontalGap(),
					e.getLength() + config.getBuildingHorizontalGap(), 1);
			rectangle.setEntityLink(e);
			switch (e.getType()) {
			case "classDistrict":
				classes.add(rectangle);
				break;
			case "interfaceDistrict":
				classes.add(rectangle);
				break;
			case "functionGroupDistrict":
				functionGroups.add(rectangle);
				break;
			case "reportDistrict":
				reports.add(rectangle);
				break;
			case "structureDistrict":
				structures.add(rectangle);
				break;
			case "domainDistrict":
				dataElements.add(rectangle);
				break;
			case "virtualDomainDistrict":
				dataElements.add(rectangle);
				break;
			case "tableDistrict":
				tables.add(rectangle);
				break;
			}
		}
		
		Rectangle classRec = doAlgorithm(classes, ptree, covrec);		
		
		functionGroups.add(0, classRec);		
		ptree = new CityKDTree(entityRec);		
		Rectangle fuGrRec = doAlgorithm(functionGroups, ptree, covrec);
		
		reports.add(0, fuGrRec);		
		ptree = new CityKDTree(entityRec);		
		Rectangle repRec = doAlgorithm(reports, ptree, covrec);
		
		structures.add(0, repRec);		
		ptree = new CityKDTree(entityRec);
		Rectangle strucRec = doAlgorithm(structures, ptree, covrec);
		
		dataElements.add(0, strucRec);		
		ptree = new CityKDTree(entityRec);
		Rectangle dataElemRec = doAlgorithm(dataElements, ptree, covrec);	
		
		tables.add(0, dataElemRec);		
		ptree = new CityKDTree(entityRec);
		doAlgorithm(tables, ptree, covrec);		
		
		entity.setWidth(covrec.getBottomRightX()
				+ (config.getBuildingHorizontalMargin() - config.getBuildingHorizontalGap() / 2) * 2);
		entity.setLength(covrec.getBottomRightY()
				+ (config.getBuildingHorizontalMargin() - config.getBuildingHorizontalGap() / 2) * 2);
	}

	/* functions for algorithm */
	private static List<Rectangle> sortChildrenAsRectangles(EList<Entity> entities) {
		List<Rectangle> elements = new ArrayList<Rectangle>();
		// copy all child-elements into a List<Rectangle> (for easier sort) with links
		// to former entities
		for (Entity e : entities) {
			Rectangle rectangle = new Rectangle(0, 0, e.getWidth() + config.getBuildingHorizontalGap(),
					e.getLength() + config.getBuildingHorizontalGap(), 1);
			rectangle.setEntityLink(e);
			elements.add(rectangle);
			if (DEBUG_Part1) {
				System.out.println("\t\t" + info + " " + e.getFqn() + " [checkVALUES]: [(" + rectangle.getUpperLeftX()
						+ "|" + rectangle.getUpperLeftY() + "), (" + rectangle.getBottomRightX() + "|"
						+ rectangle.getBottomRightY() + ")]");
			}
			if (DEBUG_Part1) {
				System.out.println("\t\t" + info + "[checkEntity]: rectangle.getEntityLink() == e ->"
						+ (rectangle.getEntityLink() == e));
			}
		}

		// sort elements by size in descending order
		Collections.sort(elements);
		if (DEBUG_Part1) {
			System.out.println("\n\t\t" + info + "[checkSort1]: order elements");
			for (Rectangle r : elements) {
				System.out.println("\t\t" + info + " " + r.getEntityLink().getFqn() + "[checkValues]: area="
						+ r.getArea() + " width=" + r.getWidth() + " length=" + r.getLength());
			}
		}
		Collections.reverse(elements);
		if (DEBUG_Part2) {
			System.out.println("\n\t\t" + info + "[checkSort2]: descending order");
			for (Rectangle r : elements) {
				System.out.println("\t\t" + info + " " + r.getEntityLink().getFqn() + "[checkValues]: area="
						+ r.getArea() + " width=" + r.getWidth() + " length=" + r.getLength());
			}
		}
		return elements;
	}

	private static Rectangle doAlgorithm(List<Rectangle> elements, CityKDTree ptree, Rectangle covrec) {
		for (Rectangle el : elements) {
			if (el.getEntityLink() != null)
				if (DEBUG_Part2) {
					System.out.println("\n\t\t" + info + "Entity " + el.getEntityLink().getFqn() + " starts algorithm!!!!!!!!!!!!!!!!!!!!!!!!!!");
				}
			
			List<CityKDTreeNode> pnodes = ptree.getFittingNodes(el);
			if (DEBUG_Part2) {
				System.out.println("\n\t\t" + info + "show all fittingNodes!");
				int node_number = 0;
				for (CityKDTreeNode n : pnodes) {
					node_number++;
					System.out.println("\t\t" + info + "Node #" + node_number);
					System.out.println("\t\t" + info + "Node Rec[(" + n.getRectangle().getUpperLeftX() + "|"
							+ n.getRectangle().getUpperLeftY() + "), (" + n.getRectangle().getBottomRightX() + "|"
							+ n.getRectangle().getBottomRightY() + ")]");
				}
			}
			Map<CityKDTreeNode, Double> preservers = new LinkedHashMap<CityKDTreeNode, Double>(); // LinkedHashMap
																									// necessary, so
																									// elements are
																									// ordered by
																									// inserting-order
			Map<CityKDTreeNode, Double> expanders = new LinkedHashMap<CityKDTreeNode, Double>();
			CityKDTreeNode targetNode = new CityKDTreeNode();
			CityKDTreeNode fitNode = new CityKDTreeNode();

			// check all empty leaves: either they extend COVREC (->expanders) or it doesn't
			// change (->preservers)
			if (DEBUG_Part2) {
				System.out.println("\n\t\t" + info + "check all empty leaves!");
			}
			for (CityKDTreeNode pnode : pnodes) {
				sortEmptyLeaf(pnode, el, covrec, preservers, expanders);
			}

			// choose best-fitting pnode
			if (preservers.isEmpty() != true) {
				targetNode = bestFitIsPreserver(preservers.entrySet());
			} else {
				targetNode = bestFitIsExpander(expanders.entrySet());
			}

			// modify targetNode if necessary
			if (targetNode.getRectangle().getWidth() == el.getWidth()
					&& targetNode.getRectangle().getLength() == el.getLength()) { // this if could be skipped,
																					// trimmingNode() always returns
																					// fittingNode
				fitNode = targetNode;
				if (DEBUG_Part2) {
					System.out.println("\n\t\t" + info + "targetNode fits.");
				}
			} else {
				if (DEBUG_Part2) {
					System.out.println("\n\t\t" + info + "targetNode needs trimming.");
				}
				fitNode = trimmingNode(targetNode, el);
			}

			// set fitNode as occupied
			fitNode.setOccupied(true);

			// give Entity it's Position
			setNewPosition(el, fitNode);

			// if fitNode expands covrec, update covrec
			if (fitNode.getRectangle().getBottomRightX() > covrec.getBottomRightX()
					|| fitNode.getRectangle().getBottomRightY() > covrec.getBottomRightY()) {
				updateCovrec(fitNode, covrec);
			}
		}

		return covrec;
	}

	private static void sortEmptyLeaf(CityKDTreeNode pnode, Rectangle el, Rectangle covrec,
			Map<CityKDTreeNode, Double> preservers, Map<CityKDTreeNode, Double> expanders) {
		// either element fits in current bounds (->preservers) or it doesn't
		// (->expanders)
		double nodeUpperLeftX = pnode.getRectangle().getUpperLeftX();
		double nodeUpperLeftY = pnode.getRectangle().getUpperLeftY();
		double nodeNewBottomRightX = nodeUpperLeftX + el.getWidth(); // expected BottomRightCorner, if el was insert
																		// into pnode
		double nodeNewBottomRightY = nodeUpperLeftY + el.getLength(); // this new corner-point is compared with covrec

		if (nodeNewBottomRightX <= covrec.getBottomRightX() && nodeNewBottomRightY <= covrec.getBottomRightY()) {
			double waste = pnode.getRectangle().getArea() - el.getArea();
			preservers.put(pnode, waste);
			if (DEBUG_Part2) {
				System.out.println("\t\t" + info + "Node is preserver. waste=" + waste);
			}
		} else {
			double ratio = ((nodeNewBottomRightX > covrec.getBottomRightX() ? nodeNewBottomRightX
					: covrec.getBottomRightX())
					/ (nodeNewBottomRightY > covrec.getBottomRightY() ? nodeNewBottomRightY
							: covrec.getBottomRightY()));
			expanders.put(pnode, ratio);
			if (DEBUG_Part2) {
				System.out.println(
						"\t\t" + info + "Node is expander. ratio=" + ratio + " distance=" + Math.abs(ratio - 1));
			}
		}
	}

	private static CityKDTreeNode bestFitIsPreserver(Set<Entry<CityKDTreeNode, Double>> entrySet) {
		// determines which entry in Set has the lowest value of all
		double lowestValue = -1;
		CityKDTreeNode targetNode = new CityKDTreeNode();
		for (Map.Entry<CityKDTreeNode, Double> entry : entrySet) {
			if (entry.getValue() < lowestValue || lowestValue == -1) {
				lowestValue = entry.getValue();
				targetNode = entry.getKey();
			}
		}
		if (DEBUG_Part2) {
			System.out.println("\t\t" + info + "chosen Node is preserver: " + lowestValue);
			System.out.println("\t\t" + info + "Node Rec[(" + targetNode.getRectangle().getUpperLeftX() + "|"
					+ targetNode.getRectangle().getUpperLeftY() + "), (" + targetNode.getRectangle().getBottomRightX()
					+ "|" + targetNode.getRectangle().getBottomRightY() + ")]");
		}
		return targetNode;
	}

	private static CityKDTreeNode bestFitIsExpander(Set<Entry<CityKDTreeNode, Double>> entrySet) {
		double closestTo = 1;
		double lowestDistance = -1;
		CityKDTreeNode targetNode = new CityKDTreeNode();
		for (Map.Entry<CityKDTreeNode, Double> entry : entrySet) {
			double distance = Math.abs(entry.getValue() - closestTo);
			if (distance < lowestDistance || lowestDistance == -1) {
				lowestDistance = distance;
				targetNode = entry.getKey();
			}
		}
		if (DEBUG_Part2) {
			System.out.println("\t\t" + info + "chosen Node is expander: " + lowestDistance);
			System.out.println("\t\t" + info + "Node Rec[(" + targetNode.getRectangle().getUpperLeftX() + "|"
					+ targetNode.getRectangle().getUpperLeftY() + "), (" + targetNode.getRectangle().getBottomRightX()
					+ "|" + targetNode.getRectangle().getBottomRightY() + ")]");
		}
		return targetNode;
	}

	private static CityKDTreeNode trimmingNode(CityKDTreeNode node, Rectangle r) {
		if (DEBUG) {
			System.out.println("\t\t" + info + "trimmingNode()-arrival.");
		}
		double nodeUpperLeftX = node.getRectangle().getUpperLeftX();
		double nodeUpperLeftY = node.getRectangle().getUpperLeftY();
		double nodeBottomRightX = node.getRectangle().getBottomRightX();
		double nodeBottomRightY = node.getRectangle().getBottomRightY();

		// first split: horizontal cut, if necessary
		// Round to 3 digits to prevent infinity loop, because e.g. 12.34000000007 is
		// declared equal to 12.34
		if (Math.round(node.getRectangle().getLength() * 1000d) != Math.round(r.getLength() * 1000d)) {
			// new child-nodes
			node.setLeftChild(new CityKDTreeNode(
					new Rectangle(nodeUpperLeftX, nodeUpperLeftY, nodeBottomRightX, (nodeUpperLeftY + r.getLength()))));
			node.setRightChild(new CityKDTreeNode(new Rectangle(nodeUpperLeftX, (nodeUpperLeftY + r.getLength()),
					nodeBottomRightX, nodeBottomRightY)));
			// set node as occupied (only leaves can contain elements)
			node.setOccupied(true);

			if (DEBUG_Part2) {
				System.out.println("\t\t\t" + info + "horizontal");
				System.out.println("\t\t\t" + info + "targetNode Rec[(" + nodeUpperLeftX + "|" + nodeUpperLeftY + "), ("
						+ nodeBottomRightX + "|" + nodeBottomRightY + ")]");
				System.out.println(
						"\t\t\t" + info + "LeftChild Rec[(" + node.getLeftChild().getRectangle().getUpperLeftX() + "|"
								+ node.getLeftChild().getRectangle().getUpperLeftY() + "), ("
								+ node.getLeftChild().getRectangle().getBottomRightX() + "|"
								+ node.getLeftChild().getRectangle().getBottomRightY() + ")]");
				System.out.println(
						"\t\t\t" + info + "RightChild Rec[(" + node.getRightChild().getRectangle().getUpperLeftX() + "|"
								+ node.getRightChild().getRectangle().getUpperLeftY() + "), ("
								+ node.getRightChild().getRectangle().getBottomRightX() + "|"
								+ node.getRightChild().getRectangle().getBottomRightY() + ")]");
			}

			return trimmingNode(node.getLeftChild(), r);
			// second split: vertical cut, if necessary
			// Round to 3 digits, because e.g. 12.34000000007 is declared equal to 12.34
		} else if (Math.round(node.getRectangle().getWidth() * 1000d) != Math.round(r.getWidth() * 1000d)) {
			// new child-nodes
			node.setLeftChild(new CityKDTreeNode(
					new Rectangle(nodeUpperLeftX, nodeUpperLeftY, (nodeUpperLeftX + r.getWidth()), nodeBottomRightY)));
			node.setRightChild(new CityKDTreeNode(new Rectangle((nodeUpperLeftX + r.getWidth()), nodeUpperLeftY,
					nodeBottomRightX, nodeBottomRightY)));
			// set node as occupied (only leaves can contain elements)
			node.setOccupied(true);

			if (DEBUG_Part2) {
				System.out.println("\t\t\t" + info + "vertical");
				System.out.println("\t\t\t" + info + "targetNode Rec[(" + nodeUpperLeftX + "|" + nodeUpperLeftY + "), ("
						+ nodeBottomRightX + "|" + nodeBottomRightY + ")]");
				System.out.println(
						"\t\t\t" + info + "LeftChild Rec[(" + node.getLeftChild().getRectangle().getUpperLeftX() + "|"
								+ node.getLeftChild().getRectangle().getUpperLeftY() + "), ("
								+ node.getLeftChild().getRectangle().getBottomRightX() + "|"
								+ node.getLeftChild().getRectangle().getBottomRightY() + ")]");
				System.out
						.println("\t\t\t" + info + "LeftChild center(" + node.getLeftChild().getRectangle().getCenterX()
								+ "|" + node.getLeftChild().getRectangle().getCenterY() + ")");
				System.out.println(
						"\t\t\t" + info + "RightChild Rec[(" + node.getRightChild().getRectangle().getUpperLeftX() + "|"
								+ node.getRightChild().getRectangle().getUpperLeftY() + "), ("
								+ node.getRightChild().getRectangle().getBottomRightX() + "|"
								+ node.getRightChild().getRectangle().getBottomRightY() + ")]");
			}
			if (DEBUG) {
				System.out.println("\t\t" + info + "trimmingNode()-exit.");
			}
			return node.getLeftChild();
		} else {
			if (DEBUG) {
				System.out.println("\t\t" + info + "trimmingNode()-exit.");
			}
			return node;
		}
	}

	private static void setNewPosition(Rectangle el, CityKDTreeNode fitNode) {

		Position newPos = cityFactory.createPosition();
		// mapping 2D rectangle on 3D building
		newPos.setX(fitNode.getRectangle().getCenterX() - config.getBuildingHorizontalGap() / 2); // width
		newPos.setZ(fitNode.getRectangle().getCenterY() - config.getBuildingHorizontalGap() / 2); // length

		if (el.getEntityLink() != null) {
			el.getEntityLink().setPosition(newPos);

			if (DEBUG) {
				System.out.println("\n\t\t" + info + "Entity " + el.getEntityLink().getFqn() + " [checkVALUES]: ("
						+ el.getEntityLink().getPosition().getX() + "|" + el.getEntityLink().getPosition().getY() + "|"
						+ el.getEntityLink().getPosition().getZ() + ")\n");
			}
		}
	}

	private static void updateCovrec(CityKDTreeNode fitNode, Rectangle covrec) {
		double newX = (fitNode.getRectangle().getBottomRightX() > covrec.getBottomRightX()
				? fitNode.getRectangle().getBottomRightX()
				: covrec.getBottomRightX());
		double newY = (fitNode.getRectangle().getBottomRightY() > covrec.getBottomRightY()
				? fitNode.getRectangle().getBottomRightY()
				: covrec.getBottomRightY());
		covrec.changeRectangle(0, 0, newX, newY);
		if (DEBUG) {
			System.out.println(
					"\t\t" + info + "CovRec [checkVALUES]: [(" + covrec.getUpperLeftX() + "|" + covrec.getUpperLeftY()
							+ "), (" + covrec.getBottomRightX() + "|" + covrec.getBottomRightY() + ")]");
		}
	}

	private static void adjustPositions(EList<Entity> children, double parentX, double parentZ) {
		for (Entity e : children) {
			if (e.getPosition() == null) {
				// just for debugging
				Position newPos = cityFactory.createPosition();
				newPos.setX(-500);
				newPos.setY(-500);
				newPos.setZ(-500);
				e.setPosition(newPos);
			}

			double centerX = e.getPosition().getX();
			double centerZ = e.getPosition().getZ();
			e.getPosition().setX(centerX + parentX + config.getBuildingHorizontalMargin()/*-BLDG_horizontalGap/2*/);
			e.getPosition().setZ(centerZ + parentZ + config.getBuildingHorizontalMargin()/*-BLDG_horizontalGap/2*/);

			if (e.getType().equals("FAMIX.Namespace") || e.getType().equals("reportDistrict")
					|| e.getType().equals("classDistrict") || e.getType().equals("functionGroupDistrict")
					|| e.getType().equals("tableDistrict") || e.getType().equals("dcDataDistrict") 
					|| e.getType().equals("domainDistrict") || e.getType().equals("virtualDomainDistrict")
					|| e.getType().equals("structureDistrict") || e.getType().equals("interfaceDistrict")){
				double newUpperLeftX = e.getPosition().getX() - e.getWidth() / 2;
				double newUpperLeftZ = e.getPosition().getZ() - e.getLength() / 2;
				adjustPositions(e.getEntities(), newUpperLeftX, newUpperLeftZ);
			}
		}
	} // End of adjustPositions

	
	/*** NEW LAYOUT PROCESSING FOR SCO ***/
	
	private static void arrangeClassDistrict(Entity classDistrict) {
		// setting district size
		// maybe adding the margin?
		Double squareSize = Math.ceil(Math.sqrt(classDistrict.getEntities().size()));
		/*TODO 
		 * For calculating the size of the class district, subtract the amount of subclass districts
		 */
		double size = squareSize
				* (config.getAbapAdvBuildingDefSize("FAMIX.Method") * config.getAbapAdvBuildingScale("FAMIX.Method")
						+ config.getBuildingHorizontalGap());
		classDistrict.setWidth(size + 2 * config.getBuildingHorizontalMargin()); // or size + config.getBuildingHorizontalMargin() + config.getBuildingHorizontalGap() ??
		classDistrict.setLength(size + 2 * config.getBuildingHorizontalMargin());
		Rectangle classDistrictSquare = new Rectangle(0, 0, size, size);

		EList<Entity> members = classDistrict.getEntities();

		List<Rectangle> privateMembers = new ArrayList<Rectangle>();
		List<Rectangle> publicMembers = new ArrayList<Rectangle>();
		List<Rectangle> districtMembers = new ArrayList<Rectangle>();

		double unitSize = config.getAbapAdvBuildingDefSize("FAMIX.Method") * config.getAbapAdvBuildingScale("FAMIX.Method") + config.getBuildingHorizontalGap();

		// ordering the members as rectangles by visibility
		for (Entity member : members) {
			if (member.getType() == "classDistrict") {
				arrangeClassDistrict(member);			
				Rectangle square = new Rectangle(0, 0, member.getLength() , member.getWidth());
				square.setEntityLink(member);			
				
				districtMembers.add(square);
			} else {
				Rectangle square = new Rectangle(0, 0, unitSize, unitSize);
				square.setEntityLink(member);

				switch (member.getVisibility()) {
				case "PRIVATE":
					privateMembers.add(square);
					break;
				case "PROTECTED":
					privateMembers.add(square);
					break;
				case "PUBLIC":
					publicMembers.add(square);
					break;
				default:
					publicMembers.add(square);
					break;
				}
		    }	      
		}
		// start algorithm
		List<String> position = getPositionList(squareSize);

		// moving the entities to the right place
		moveElementsToPosition(privateMembers, position, classDistrictSquare, unitSize, squareSize, false);
		moveElementsToPosition(publicMembers, position, classDistrictSquare, unitSize, squareSize, true);
		arrangeLocalClassDistricts(classDistrict, classDistrictSquare, districtMembers);
	}
	
//	private static void arrangeTableDistrict (Entity tableDistrict) {
//		Double squareSize = tableeDistrict.getEntities().get(0).getWidth();
//		double size = squareSize * (config.getAbapAdvBuildingDefSize("FAMIX.Table") * config.getAbapAdvBuildingScale("FAMIX.Table")
//					  + config.getBuildingHorizontalGap());
//		
//		tableDistrict.setWidth(size + 2 * config.getBuildingHorizontalMargin()); // or size + config.getBuildingHorizontalMargin() + config.getBuildingHorizontalGap() ??
//		tableDistrict.setLength(size + 2 * config.getBuildingHorizontalMargin());
//		EList<Entity> members = tableDistrict.getEntities();
//		
//		List<Rectangle> tables = new ArrayList<Rectangle>();
//		
//		double unitSize = squareSize;//config.getAbapAdvBuildingDefSize("FAMIX.Table") * config.getAbapAdvBuildingScale("FAMIX.Table") + config.getBuildingHorizontalGap();
//		
//		// ordering the members as rectangles by visibility
//		for (Entity member : members) {
//			Rectangle square = new Rectangle(0, 0, unitSize, unitSize);
//			square.setEntityLink(member);
//
//			switch (member.getType()) {
//			case "FAMIX.Table":
//				tables.add(square);
//				break;
//			default:
//				tables.add(square);
//				break;
//			}
//		}
//
//        Position centerPos = cityFactory.createPosition();
//		
//		centerPos.setX(size / 2.0);
//		centerPos.setZ(size / 2.0);
//		
//		if(!tables.isEmpty()) {
//			tables.get(0).getEntityLink().setPosition(centerPos);
//		}
//	}
	
	
	private static void arrangeInterfaceDistrict(Entity interfaceDistrict) {
		
		if (interfaceDistrict.getEntities().isEmpty() == true) {
			return;
		}
		
		Double squareSize = interfaceDistrict.getEntities().get(0).getWidth();
		double size = squareSize * ( (config.getAbapAdvBuildingDefSize("FAMIX.InterfaceAttribute") + 1) * config.getAbapAdvBuildingScale("FAMIX.Class")
					  + config.getBuildingHorizontalGap());
		
		interfaceDistrict.setWidth(size + 2 * config.getBuildingHorizontalMargin()); // or size + config.getBuildingHorizontalMargin() + config.getBuildingHorizontalGap() ??
		interfaceDistrict.setLength(size + 2 * config.getBuildingHorizontalMargin());
		EList<Entity> members = interfaceDistrict.getEntities();
		
		List<Rectangle> classes = new ArrayList<Rectangle>();
		
		double unitSize = squareSize;//config.getAbapAdvBuildingDefSize("FAMIX.Class") * config.getAbapAdvBuildingScale("FAMIX.Class") + config.getBuildingHorizontalGap();
		
		// ordering the members as rectangles by visibility
		for (Entity member : members) {
			Rectangle square = new Rectangle(0, 0, unitSize, unitSize);
			square.setEntityLink(member);

			switch (member.getType()) {
			case "FAMIX.Class":
				classes.add(square);
				break;
			default:
				classes.add(square);
				break;
			}
		}

        Position centerPos = cityFactory.createPosition();
		
		centerPos.setX(size / 2.0);
		centerPos.setZ(size / 2.0);
		
		if(!classes.isEmpty()) {
			classes.get(0).getEntityLink().setPosition(centerPos);
		}
	}

	private static void arrangeFunctionGroupDistrict(Entity functionGroupDistrict) {
		Double squareSize = Math.ceil(Math.sqrt(functionGroupDistrict.getEntities().size()));
		/*TODO 
		 * For calculating the size of the class district, subtract the amount of subclass districts
		 */
		double size = squareSize * (config.getAbapAdvBuildingDefSize("FAMIX.FunctionModule")
				* config.getAbapAdvBuildingScale("FAMIX.FunctionModule") + config.getBuildingHorizontalGap());
		functionGroupDistrict.setWidth(size + 2 * config.getBuildingHorizontalMargin()); // or size + config.getBuildingHorizontalMargin() + config.getBuildingHorizontalGap() ??
		functionGroupDistrict.setLength(size + 2 * config.getBuildingHorizontalMargin());
		Rectangle functionGroupDistrictSquare = new Rectangle(0, 0, size, size);

		EList<Entity> members = functionGroupDistrict.getEntities();

		List<Rectangle> privateMembers = new ArrayList<Rectangle>();
		List<Rectangle> publicMembers = new ArrayList<Rectangle>();
		List<Rectangle> districtMembers = new ArrayList<Rectangle>();

		double unitSize = config.getAbapAdvBuildingDefSize("FAMIX.FunctionModule")
				* config.getAbapAdvBuildingScale("FAMIX.FunctionModule") + config.getBuildingHorizontalGap();

		// ordering the members as rectangles by visibility
		for (Entity member : members) {
			Rectangle square = new Rectangle(0, 0, unitSize, unitSize);
			square.setEntityLink(member);

			switch (member.getType()) {
			case "FAMIX.Attribute":
				privateMembers.add(square);
				break;
			case "FAMIX.FunctionModule":
				publicMembers.add(square);
				break;
			case "classDistrict":
				arrangeClassDistrict(member);
				square = new Rectangle(0, 0, member.getLength() , member.getWidth());
				square.setEntityLink(member);
								
				districtMembers.add(square);
				break;
			default:
				publicMembers.add(square);
				break;
			}
		}

		// start algorithm
		List<String> position = getPositionList(squareSize);

		// moving the entities to the right place
		moveElementsToPosition(privateMembers, position, functionGroupDistrictSquare, unitSize, squareSize, false);
		moveElementsToPosition(publicMembers, position, functionGroupDistrictSquare, unitSize, squareSize, true);
		arrangeLocalClassDistricts(functionGroupDistrict, functionGroupDistrictSquare, districtMembers);
	}

	private static void arrangeReportDistrict(Entity reportDistrict) {
		Double squareSize = Math.ceil(Math.sqrt(reportDistrict.getEntities().size()));
		double size = squareSize * (config.getAbapAdvBuildingDefSize("FAMIX.Report") * config.getAbapAdvBuildingScale("FAMIX.Report") + config.getBuildingHorizontalGap());
		
//		Double squareSize = reportDistrict.getEntities().get(0).getWidth();
//		double size = squareSize * ( (config.getAbapAdvBuildingDefSize("FAMIX.ReportAttribute") + 10) * config.getAbapAdvBuildingScale("FAMIX.Report")
//				  + config.getBuildingHorizontalGap());
		
		
		reportDistrict.setWidth(size + 2 * config.getBuildingHorizontalMargin()); // or size + config.getBuildingHorizontalMargin() + config.getBuildingHorizontalGap() ??
		reportDistrict.setLength(size + 2 * config.getBuildingHorizontalMargin());
		
		Rectangle reportDistrictSquare = new Rectangle(0, 0, size, size);

		EList<Entity> members = reportDistrict.getEntities();

		List<Rectangle> privateMembers = new ArrayList<Rectangle>();
		List<Rectangle> publicMembers = new ArrayList<Rectangle>();
		List<Rectangle> districtMembers = new ArrayList<Rectangle>();

		double unitSize =  config.getAbapAdvBuildingDefSize("FAMIX.Report") * config.getAbapAdvBuildingScale("FAMIX.Report") + config.getBuildingHorizontalGap();

		// ordering the members as rectangles by visibility
		for (Entity member : members) {
			Rectangle square = new Rectangle(0, 0, unitSize, unitSize);
			square.setEntityLink(member);

			switch (member.getType()) {
			case "FAMIX.Report":
				privateMembers.add(0, square);
				break;
			case "FAMIX.Attribute":
				privateMembers.add(square);
				break;
			case "FAMIX.Formroutine":
				publicMembers.add(square);
				break;
			case "classDistrict":				
				arrangeClassDistrict(member);
				
				square = new Rectangle(0, 0, member.getLength() , member.getWidth());
				square.setEntityLink(member);
				
				districtMembers.add(square);
				break;
			default:
				publicMembers.add(square);
				break;
			}
		}

		// start algorithm
		List<String> position = getPositionList(squareSize);

		// moving the entities to the right place
		moveElementsToPosition(privateMembers, position, reportDistrictSquare, unitSize, squareSize, false);
		moveElementsToPosition(publicMembers, position, reportDistrictSquare, unitSize, squareSize, true);
		arrangeLocalClassDistricts(reportDistrict, reportDistrictSquare, districtMembers);
		
	}

	private static List<String> getPositionList(Double squareSize) {
		int counter = 0;
		List<String> position = new ArrayList<String>();
		position.add(0, "");
		position.add(1, "U");
		position.add(2, "R");
		position.add(3, "D");
		position.add(4, "L");

		if (squareSize.intValue() % 2 == 1) {
			for (int k = 3; k <= squareSize; k += 2) {
				counter++;
				for (int i = (k - 2) * (k - 2); i < k * k; ++i) {
					// the first four fields are already filled
					if (i < 5)
						continue;

					if ((i <= (k - 2) * (k - 2) + 3)) {
						position.add(i, appendNextCharacter(position.get(i - 8 * (counter - 1)), false));
					} else {
						if (position.get(i - 4).length() % counter == 0) {
							position.add(i, appendNextCharacter(position.get(i - 4), true));
						} else {
							position.add(i, appendNextCharacter(position.get(i - 4), false));
						}
					}
				}
			}
		} else {
			for (int l = 4; l <= squareSize; l += 2) {
				counter++;
				for (int j = (l - 2) * (l - 2) + 1; j <= l * l; ++j) {
					// the first four need some special treatment
					if (j < 9) {
						switch (j) {
						case 5:
							position.add(5, "U");
							break;
						case 6:
							position.add(6, "R");
							break;
						case 7:
							position.add(7, "D");
							break;
						case 8:
							position.add(8, "L");
							break;
						}
						continue;
					}

					if (j <= (l - 2) * (l - 2) + 4) {
						position.add(j, appendNextCharacter(position.get(j - 8 * (counter - 1) - 4), false)); // j - 8 *
																												// counter
																												// + 4
					} else {
						if (position.get(j - 4).length() % counter == 0) {
							position.add(j, appendNextCharacter(position.get(j - 4), true));
						} else {
							position.add(j, appendNextCharacter(position.get(j - 4), false));
						}
					}

				}
			}
		}
		return position;
	}

	private static String appendNextCharacter(String string, boolean changeDirection) {
		String lastCharacter = string.substring(string.length() - 1);
		if (changeDirection) {
			switch (lastCharacter) {
			case "U":
				return string.concat("R");
			case "R":
				return string.concat("D");
			case "D":
				return string.concat("L");
			case "L":
				return string.concat("U");
			default:
				return "";
			}
		} else {
			return string.concat(lastCharacter);
		}
	}

	private static void moveElementsToPosition(List<Rectangle> childrenRectangles, List<String> position,
			Rectangle districtSquare, double unitSize, Double squareSize, boolean reverse) {
		int counter, counterIncrement;

		if (reverse) {
			counter = squareSize.intValue() * squareSize.intValue() - 1;
			counterIncrement = -1;

		} else {
			counter = 0;
			counterIncrement = 1;
		}

		if (squareSize.intValue() % 2 == 1) {
			for (Rectangle r : childrenRectangles) {
				Position newPos = cityFactory.createPosition();
				newPos = getCenterPosition(squareSize, districtSquare, counter, unitSize);

				if (counter != 0) {
					for (int i = 0; i < position.get(counter).length(); ++i) {
						char direction = position.get(counter).charAt(i);
						doOneStep(newPos, direction, unitSize);
					}
				}

				r.getEntityLink().setPosition(newPos);
				counter += counterIncrement;
			}
		} else {
			counter += 1;

			for (Rectangle r : childrenRectangles) {
				Position newPos = cityFactory.createPosition();
				newPos = getCenterPosition(squareSize, districtSquare, counter, unitSize);

				if (counter > 4) {
					for (int i = 0; i < position.get(counter).length(); ++i) {
						char direction = position.get(counter).charAt(i);
						doOneStep(newPos, direction, unitSize);
					}
				}

				r.getEntityLink().setPosition(newPos);
				counter += counterIncrement;
			}
		}
	}

	private static Position getCenterPosition(Double squareSize, Rectangle districtSquare, int counter,
			double unitSize) {
		Position centerPos = cityFactory.createPosition();

		centerPos.setX(districtSquare.getCenterX());
		centerPos.setZ(districtSquare.getCenterY());

		if (squareSize.intValue() % 2 == 0) {
			switch (counter % 4) {
			case 1:
				centerPos.setX(centerPos.getX() + unitSize / 2);
				centerPos.setZ(centerPos.getZ() + unitSize / 2);
				break;
			case 2:
				centerPos.setX(centerPos.getX() + unitSize / 2);
				centerPos.setZ(centerPos.getZ() - unitSize / 2);
				break;
			case 3:
				centerPos.setX(centerPos.getX() - unitSize / 2);
				centerPos.setZ(centerPos.getZ() - unitSize / 2);
				break;
			case 0:
				centerPos.setX(centerPos.getX() - unitSize / 2);
				centerPos.setZ(centerPos.getZ() + unitSize / 2);
				break;
			}
		}

		return centerPos;
	}

	private static void doOneStep(Position pos, char direction, double length) {
		switch (direction) {
		case 'U':
			pos.setZ(pos.getZ() + length);
			break;
		case 'R':
			pos.setX(pos.getX() + length);
			break;
		case 'D':
			pos.setZ(pos.getZ() - length);
			break;
		case 'L':
			pos.setX(pos.getX() - length);
			break;
		}
	}
	
	private static void arrangeLocalClassDistricts(Entity district, Rectangle districtSquare, List<Rectangle> districtMembers) {
		for (Rectangle localClassDistrict : districtMembers) {
			
			// Je nachdem, ob der zugrunde liegende Distrikt, in dem die lokalen Klassen angeordnet werden sollen, breiter als länger ist oder nicht,
			// wird der Distrikt der lokalen Klasse entweder darüber oder rechts daneben angeordnet, um möglichst platzeffizient vorzugehen.			
			if (districtSquare.getWidth() > districtSquare.getLength()) {
				
				double newUpperRightX = districtSquare.getWidth() >= localClassDistrict.getWidth() ? 
										districtSquare.getBottomRightX() : 
										localClassDistrict.getBottomRightX() + 2 * config.getBuildingHorizontalMargin();
				
				double newUpperRightY = districtSquare.getBottomRightY() + localClassDistrict.getBottomRightY() + 2 * config.getBuildingHorizontalMargin();
				
				localClassDistrict.changeRectangle(districtSquare.getUpperLeftX(),
												   districtSquare.getBottomRightY(),
												   localClassDistrict.getWidth() + 2 * config.getBuildingHorizontalGap(),
												   localClassDistrict.getLength() + 2 * config.getBuildingHorizontalGap(), 
												   1);
				
				districtSquare.changeRectangle(districtSquare.getUpperLeftX(),
											   districtSquare.getUpperLeftY(),
											   newUpperRightX - districtSquare.getUpperLeftX() + 2 * config.getBuildingHorizontalMargin(),
											   newUpperRightY - districtSquare.getUpperLeftY() + 2 * config.getBuildingHorizontalMargin(),
											   1);
								
			} else {
				
				double newUpperRightX = districtSquare.getBottomRightX() + localClassDistrict.getBottomRightX() + 2 * config.getBuildingHorizontalMargin();
				
				double newUpperRightY = districtSquare.getLength() >= localClassDistrict.getLength() ? 
									    districtSquare.getBottomRightY() : 
									    localClassDistrict.getBottomRightY() + 2 * config.getBuildingHorizontalMargin();
				
				localClassDistrict.changeRectangle(districtSquare.getBottomRightX(),
												   districtSquare.getUpperLeftY(),
						   						   localClassDistrict.getWidth() + 2 * config.getBuildingHorizontalGap(),
						   						   localClassDistrict.getLength() + 2 * config.getBuildingHorizontalGap(),
						   						   1);
				
				districtSquare.changeRectangle(districtSquare.getUpperLeftX(),
											   districtSquare.getUpperLeftY(),
											   newUpperRightX - districtSquare.getUpperLeftX() + 2 * config.getBuildingHorizontalMargin(),
											   newUpperRightY - districtSquare.getUpperLeftY() + 2 * config.getBuildingHorizontalMargin(),
											   1);		
			}
			
			Position newLocalClassDistrictPos = cityFactory.createPosition();
			newLocalClassDistrictPos.setX(localClassDistrict.getCenterX());
			newLocalClassDistrictPos.setZ(localClassDistrict.getCenterY());
			localClassDistrict.getEntityLink().setPosition(newLocalClassDistrictPos);
			
			Position newDistrictSquarePos = cityFactory.createPosition();
			newDistrictSquarePos.setX(districtSquare.getCenterX());
			newDistrictSquarePos.setZ(districtSquare.getCenterY());
			district.setPosition(newDistrictSquarePos);			
			district.setLength(districtSquare.getLength());
			district.setWidth(districtSquare.getWidth());	
		}
	}
	
	
	/*** NEW LAYOUT PROCESSING FOR DCDATA ***/ 
	
	private static void arrangeDomainDistrict(Entity domainDistrict) {
		Double squareSize = Math.ceil((domainDistrict.getEntities().size() - 1)/8.0)* 2 + 1;
		double size = squareSize * (config.getAbapAdvBuildingDefSize("FAMIX.Domain") * config.getAbapAdvBuildingScale("FAMIX.Domain") + config.getBuildingHorizontalGap());		
		domainDistrict.setWidth(size + 2 * config.getBuildingHorizontalMargin()); // or size + config.getBuildingHorizontalMargin() + config.getBuildingHorizontalGap() ??
		domainDistrict.setLength(size + 2 * config.getBuildingHorizontalMargin());
		//Rectangle dcDataDistrictSquare = new Rectangle(0, 0, size, size);
		
		EList<Entity> members = domainDistrict.getEntities();
		
		List<Rectangle> dataElements = new ArrayList<Rectangle>();
		List<Rectangle> domains = new ArrayList<Rectangle>();
		
		double unitSize = config.getAbapAdvBuildingDefSize("FAMIX.Domain") * config.getAbapAdvBuildingScale("FAMIX.Domain") + config.getBuildingHorizontalGap();
		
		// ordering the members as rectangles by type
		for (Entity member : members) {
			Rectangle square = new Rectangle(0, 0, unitSize, unitSize);
			square.setEntityLink(member);
			
			switch (member.getType()) {
			case "FAMIX.DataElement":
				dataElements.add(square);
				break;
			case "FAMIX.Domain":
				domains.add(square);
				break;
			default:
				dataElements.add(square);
				break;
			}
		}
		
		// start algorithm
		//List<String> position = getPositionListDcData(squareSize);
		Position centerPos = cityFactory.createPosition();
		
		centerPos.setX(size / 2.0);
		centerPos.setZ(size / 2.0);
		
		if(!domains.isEmpty()) {
			domains.get(0).getEntityLink().setPosition(centerPos);
		}
		

		
		int counter = 1; 
		String direction = "R";
		
		Position lastPos = cityFactory.createPosition();
		
		
		for (Rectangle dataElement : dataElements) {
			Position newPos = cityFactory.createPosition();
			if (counter == 1) {
				//newPos.setX(unitSize / 2.0);
				newPos.setX(size - (unitSize / 2.0));
				newPos.setZ(size - (unitSize / 2.0));
				dataElement.getEntityLink().setPosition(newPos);
				lastPos = newPos;
				counter++; 
				
			} else {
				switch (direction) {
				case "R" : 
					newPos.setX(lastPos.getX() - unitSize);
					newPos.setZ(lastPos.getZ());
					break;
				case "D" : 
					newPos.setX(lastPos.getX());
					newPos.setZ(lastPos.getZ() - unitSize);
					break; 
				case "L" : 
					newPos.setX(lastPos.getX() + unitSize);
					newPos.setZ(lastPos.getZ());
					break; 
				case "U" : 
					newPos.setX(lastPos.getX());
					newPos.setZ(lastPos.getZ() + unitSize);				
					break; 
				}
			
				dataElement.getEntityLink().setPosition(newPos);
				lastPos = newPos;
				
				if (counter % (squareSize - 1) == 1) {
					switch (direction) {
					case "R" : 
						direction = "D"; 
						break; 
					case "D" : 
						direction = "L"; 
						break; 
					case "L" : 
						direction = "U"; 
						break; 
					}
				}
				
				counter++;
			}
		}  
	}
	
	private static void arrangeVirtualDomainDistrict(Entity virtualDomainDistrict) {
		
		Double squareSize = Math.ceil((virtualDomainDistrict.getEntities().size() - 1)/8.0)* 2 + 1;
		double size = squareSize * (config.getAbapAdvBuildingDefSize("FAMIX.VirtualDomain") * config.getAbapAdvBuildingScale("FAMIX.VirtualDomain") + config.getBuildingHorizontalGap());		
		virtualDomainDistrict.setWidth(size + 2 * config.getBuildingHorizontalMargin()); // or size + config.getBuildingHorizontalMargin() + config.getBuildingHorizontalGap() ??
		virtualDomainDistrict.setLength(size + 2 * config.getBuildingHorizontalMargin());
		//Rectangle dcDataDistrictSquare = new Rectangle(0, 0, size, size);
		
		EList<Entity> members = virtualDomainDistrict.getEntities();
		
		List<Rectangle> dataElements = new ArrayList<Rectangle>();
		List<Rectangle> domains = new ArrayList<Rectangle>();
		
		double unitSize = config.getAbapAdvBuildingDefSize("FAMIX.VirtualDomain") * config.getAbapAdvBuildingScale("FAMIX.VirtualDomain") + config.getBuildingHorizontalGap();
		
		// ordering the members as rectangles by type
		for (Entity member : members) {
			Rectangle square = new Rectangle(0, 0, unitSize, unitSize);
			square.setEntityLink(member);
			
			switch (member.getType()) {
			case "FAMIX.DataElement":
				dataElements.add(square);
				break;
			case "FAMIX.VirtualDomain":
				domains.add(square);
				break;
			default:
				dataElements.add(square);
				break;
			}
		}
		// start algorithm
		//List<String> position = getPositionListDcData(squareSize);
		Position centerPos = cityFactory.createPosition();
		
		centerPos.setX(size / 2.0);
		centerPos.setZ(size / 2.0);
		
		if(!domains.isEmpty()) {
			domains.get(0).getEntityLink().setPosition(centerPos);
		}
		

		
		int counter = 1; 
		String direction = "R";
		
		Position lastPos = cityFactory.createPosition();
		
		
		for (Rectangle dataElement : dataElements) {
			Position newPos = cityFactory.createPosition();
			if (counter == 1) {
				//newPos.setX(unitSize / 2.0);
				newPos.setX(size - (unitSize / 2.0));
				newPos.setZ(size - (unitSize / 2.0));
				dataElement.getEntityLink().setPosition(newPos);
				lastPos = newPos;
				counter++; 
				
			} else {
				switch (direction) {
				case "R" : 
					newPos.setX(lastPos.getX() - unitSize);
					newPos.setZ(lastPos.getZ());
					break;
				case "D" : 
					newPos.setX(lastPos.getX());
					newPos.setZ(lastPos.getZ() - unitSize);
					break; 
				case "L" : 
					newPos.setX(lastPos.getX() + unitSize);
					newPos.setZ(lastPos.getZ());
					break; 
				case "U" : 
					newPos.setX(lastPos.getX());
					newPos.setZ(lastPos.getZ() + unitSize);				
					break; 
				}
			
				dataElement.getEntityLink().setPosition(newPos);
				lastPos = newPos;
				
				if (counter % (squareSize - 1) == 1) {
					switch (direction) {
					case "R" : 
						direction = "D"; 
						break; 
					case "D" : 
						direction = "L"; 
						break; 
					case "L" : 
						direction = "U"; 
						break; 
					}
				}
				
				counter++;
			}
		}  
	}
		
	private static void arrangeDataElementDistrict(Entity dataElementDistrict) {
		Double squareSize = Math.ceil((dataElementDistrict.getEntities().size() - 1)/8.0)* 2 + 1;
		double size = squareSize * (config.getAbapAdvBuildingDefSize("FAMIX.Domain") * config.getAbapAdvBuildingScale("FAMIX.Domain") + config.getBuildingHorizontalGap());		
		dataElementDistrict.setWidth(size + 2 * config.getBuildingHorizontalMargin()); // or size + config.getBuildingHorizontalMargin() + config.getBuildingHorizontalGap() ??
		dataElementDistrict.setLength(size + 2 * config.getBuildingHorizontalMargin());
		//Rectangle dcDataDistrictSquare = new Rectangle(0, 0, size, size);
		
		EList<Entity> members = dataElementDistrict.getEntities();
		
		List<Rectangle> dataElements = new ArrayList<Rectangle>();
		List<Rectangle> domains = new ArrayList<Rectangle>();
		
		double unitSize = config.getAbapAdvBuildingDefSize("FAMIX.Domain") * config.getAbapAdvBuildingScale("FAMIX.Domain") + config.getBuildingHorizontalGap();
		
		// ordering the members as rectangles by type
		for (Entity member : members) {
			Rectangle square = new Rectangle(0, 0, unitSize, unitSize);
			square.setEntityLink(member);
			
			switch (member.getType()) {
			case "FAMIX.DataElement":
				dataElements.add(square);
				break;
			case "FAMIX.Domain":
				domains.add(square);
				break;
			default:
				dataElements.add(square);
				break;
			}
			}
		
		// start algorithm
		//List<String> position = getPositionListDcData(squareSize);
		Position centerPos = cityFactory.createPosition();
		
		centerPos.setX(size / 2.0);
		centerPos.setZ(size / 2.0);
		
		if(!domains.isEmpty()) {
			domains.get(0).getEntityLink().setPosition(centerPos);
		}
		

		
		int counter = 1; 
		String direction = "R";
		
		Position lastPos = cityFactory.createPosition();
		
		
		for (Rectangle dataElement : dataElements) {
			Position newPos = cityFactory.createPosition();
			if (counter == 1) {
				//newPos.setX(unitSize / 2.0);
				newPos.setX(size - (unitSize / 2.0));
				newPos.setZ(size - (unitSize / 2.0));
				dataElement.getEntityLink().setPosition(newPos);
				lastPos = newPos;
				counter++; 
				
			} else {
				switch (direction) {
				case "R" : 
					newPos.setX(lastPos.getX() - unitSize);
					newPos.setZ(lastPos.getZ());
					break;
				case "D" : 
					newPos.setX(lastPos.getX());
					newPos.setZ(lastPos.getZ() - unitSize);
					break; 
				case "L" : 
					newPos.setX(lastPos.getX() + unitSize);
					newPos.setZ(lastPos.getZ());
					break; 
				case "U" : 
					newPos.setX(lastPos.getX());
					newPos.setZ(lastPos.getZ() + unitSize);				
					break; 
				}
			
				dataElement.getEntityLink().setPosition(newPos);
				lastPos = newPos;
				
				if (counter % (squareSize - 1) == 1) {
					switch (direction) {
					case "R" : 
						direction = "D"; 
						break; 
					case "D" : 
						direction = "L"; 
						break; 
					case "L" : 
						direction = "U"; 
						break; 
					}
				}
				
				counter++;
			}
		}  
	}
	
	
private static void arrangeStructureDistrict(Entity structureDistrict) {
	Double squareSizeTtyp = Math.ceil(Math.sqrt(structureDistrict.getEntities().size()));
	Double squareSizeStruc = Math.ceil((structureDistrict.getEntities().size() - 1)/8.0)* 2 + 1;
	double sizeStruc = squareSizeStruc * (config.getAbapAdvBuildingDefSize("FAMIX.StrucElement") * config.getAbapAdvBuildingScale("FAMIX.StrucElement")/* + config.getBuildingHorizontalGap()*/);	
	double sizeTtyp = squareSizeTtyp * (config.getAbapAdvBuildingDefSize("FAMIX.StrucElement") * config.getAbapAdvBuildingScale("FAMIX.StrucElement") /*+ config.getBuildingHorizontalGap()*/);
	//structureDistrict.setWidth(120); // or size + config.getBuildingHorizontalMargin() + config.getBuildingHorizontalGap() ??
	structureDistrict.setWidth(sizeStruc + 4.5 * config.getBuildingHorizontalMargin());
	structureDistrict.setLength(sizeStruc + 3 * config.getBuildingHorizontalMargin());
	/*structureDistrict.setWidth(sizeStruc + 2 * config.getBuildingHorizontalMargin()); // or size + config.getBuildingHorizontalMargin() + config.getBuildingHorizontalGap() ??
	structureDistrict.setLength(sizeStruc + 2 * config.getBuildingHorizontalMargin());*/
	Rectangle structureDistrictSquareT = new Rectangle(0, 0, sizeTtyp, sizeTtyp);
	
	EList<Entity> members = structureDistrict.getEntities();
	
	List<Rectangle> abapStrucs = new ArrayList<Rectangle>();
	List<Rectangle> tableTypes = new ArrayList<Rectangle>();
	
	double unitSize = config.getAbapAdvBuildingDefSize("FAMIX.StrucElement") * config.getAbapAdvBuildingScale("FAMIX.StrucElement") /*+ config.getBuildingHorizontalGap()*/;
	
	// ordering the members as rectangles by type
	for (Entity member : members) {
		Rectangle square = new Rectangle(0, 0, unitSize, unitSize);
		square.setEntityLink(member);
		
		switch (member.getType()) {
		case "FAMIX.ABAPStruc":
			abapStrucs.add(square);
			break;
		case "FAMIX.TableType":
			tableTypes.add(square);
			break;
		default:
			abapStrucs.add(square);
			break;
		}
	}
	
	int counter = 1; 
	String direction = "R";
	
	Position lastPos = cityFactory.createPosition();
	
	
	for (Rectangle abapStruc : abapStrucs) {
		Position newPos = cityFactory.createPosition();
		if (counter == 1) {
			/*newPos.setX(unitSize / 2.0);
			newPos.setZ(unitSize / 2.0);*/
			newPos.setX(sizeStruc - (unitSize / 2.0));
			newPos.setZ(sizeStruc - (unitSize / 2.0));
			abapStruc.getEntityLink().setPosition(newPos);
			lastPos = newPos;
			counter++; 
			
		} else {
			switch (direction) {
			case "R" : 
				newPos.setX(lastPos.getX() - unitSize);
				newPos.setZ(lastPos.getZ());
				break;
			case "D" : 
				newPos.setX(lastPos.getX());
				newPos.setZ(lastPos.getZ() - unitSize);
				break; 
			case "L" : 
				newPos.setX(lastPos.getX() + unitSize);
				newPos.setZ(lastPos.getZ());
				break; 
			case "U" : 
				newPos.setX(lastPos.getX());
				newPos.setZ(lastPos.getZ() + unitSize);				
				break; 
			}
		
			abapStruc.getEntityLink().setPosition(newPos);
			lastPos = newPos;
			
			if (counter % (squareSizeStruc - 1) == 1) {
				switch (direction) {
				case "R" : 
					direction = "D"; 
					break; 
				case "D" : 
					direction = "L"; 
					break; 
				case "L" : 
					direction = "U"; 
					break; 
				}
			}
			
			counter++;
		}
	}  
//}



	List<String> position = getPositionListStructure(squareSizeTtyp);
//	
//	// moving the entities to the right place
//moveElementsToPositionStructure(tableTypes, position, structureDistrictSquareT, unitSize, squareSizeTtyp, true);
moveElementsToPositionStructure(tableTypes, position, structureDistrictSquareT, unitSize, squareSizeTtyp, false);
//	moveElementsToPositionStructure(abapStrucs, position, structureDistrictSquare, unitSize, squareSize, true);

}

	private static List<String> getPositionListStructure(Double squareSize) {
		int counter = 0;
		List<String> position = new ArrayList<String>();
		position.add(0, "");
		position.add(1, "L");
		position.add(2, "D");
		position.add(3, "R");
		position.add(4, "U");

		if (squareSize.intValue() % 2 == 1) {
			for (int k = 3; k <= squareSize; k += 2) {
				counter++;
				for (int i = (k - 2) * (k - 2); i < k * k; ++i) {
					// the first four fields are already filled
					if (i < 5)
						continue;

					if ((i <= (k - 2) * (k - 2) + 3)) {
						position.add(i, appendNextCharacterStructure(position.get(i - 8 * (counter - 1)), false));
					} else {
						if (position.get(i - 4).length() % counter == 0) {
							position.add(i, appendNextCharacterStructure(position.get(i - 4), true));
						} else {
							position.add(i, appendNextCharacterStructure(position.get(i - 4), false));
						}
					}
				}
			}
		} else {
			for (int l = 4; l <= squareSize; l += 2) {
				counter++;
				for (int j = (l - 2) * (l - 2) + 1; j <= l * l; ++j) {
					// the first four need some special treatment
					if (j < 9) {
						switch (j) {
						case 5:
							position.add(5, "L");
							break;
						case 6:
							position.add(6, "D");
							break;
						case 7:
							position.add(7, "R");
							break;
						case 8:
							position.add(8, "U");
							break;
						}
						continue;
					}

					if (j <= (l - 2) * (l - 2) + 4) {
						position.add(j, appendNextCharacterStructure(position.get(j - 8 * (counter - 1) - 4), false)); // j
																														// -
																														// 8
																														// *
																														// counter
																														// +
																														// 4
					} else {
						if (position.get(j - 4).length() % counter == 0) {
							position.add(j, appendNextCharacterStructure(position.get(j - 4), true));
						} else {
							position.add(j, appendNextCharacterStructure(position.get(j - 4), false));
						}
					}

				}
			}
		}
		return position;
	}

	private static String appendNextCharacterStructure(String string, boolean changeDirection) {
		String lastCharacter = string.substring(string.length() - 1);
		if (changeDirection) {
			switch (lastCharacter) {
			case "L":
				return string.concat("D");
			case "D":
				return string.concat("R");
			case "R":
				return string.concat("U");
			case "U":
				return string.concat("L");
			default:
				return "";
			}
		} else {
			return string.concat(lastCharacter);
		}
	}

	private static void moveElementsToPositionStructure(List<Rectangle> childrenRectangles, List<String> position,
			Rectangle districtSquare, double unitSize, Double squareSize, boolean reverse) {
		int counter, counterIncrement;

		if (reverse) {
			counter = squareSize.intValue() * squareSize.intValue() - 1;
			counterIncrement = -1;

		} else {
			counter = 0;
			counterIncrement = 1;
		}

		if (squareSize.intValue() % 2 == 1) {
			for (Rectangle r : childrenRectangles) {
				Position newPos = cityFactory.createPosition();
				newPos = getCenterPositionStructure(squareSize, districtSquare, counter, unitSize);

				if (counter != 0) {
					for (int i = 0; i < position.get(counter).length(); ++i) {
						char direction = position.get(counter).charAt(i);
						makeStepStructure(newPos, direction, unitSize);
					}
				}

				r.getEntityLink().setPosition(newPos);
				counter += counterIncrement;
			}
		} else {
			counter += 1;

			for (Rectangle r : childrenRectangles) {
				Position newPos = cityFactory.createPosition();
				newPos = getCenterPositionStructure(squareSize, districtSquare, counter, unitSize);

				if (counter > 4) {
					for (int i = 0; i < position.get(counter).length(); ++i) {
						char direction = position.get(counter).charAt(i);
						makeStepStructure(newPos, direction, unitSize);
					}
				}

				r.getEntityLink().setPosition(newPos);
				counter += counterIncrement;
			}
		}
	}

	private static Position getCenterPositionStructure(Double squareSize, Rectangle districtSquare, int counter,
			double unitSize) {
		Position newPos = cityFactory.createPosition();

		newPos.setX(districtSquare.getCenterX());
		newPos.setZ(districtSquare.getCenterY());

		if (squareSize.intValue() % 2 == 0) {
			switch (counter % 4) {

//		case 1:
//			newPos.setX(newPos.getX()- unitSize);
//			newPos.setZ(newPos.getZ());
//			break;
//		case 2:
//			newPos.setX(newPos.getX());
//			newPos.setZ(newPos.getZ() - unitSize );
//			break;
//		case 3:
//			newPos.setX(newPos.getX() + unitSize);
//			newPos.setZ(newPos.getZ());
//			break;
//		case 0:
//			newPos.setX(newPos.getX());
//			newPos.setZ(newPos.getZ() + unitSize);
//			break;
//		}
//	}
			case 1:
				newPos.setX(newPos.getX() + unitSize / 2);
				newPos.setZ(newPos.getZ() + unitSize / 2);
				break;
			case 2:
				newPos.setX(newPos.getX() + unitSize / 2);
				newPos.setZ(newPos.getZ() - unitSize / 2);
				break;
			case 3:
				newPos.setX(newPos.getX() - unitSize / 2);
				newPos.setZ(newPos.getZ() - unitSize / 2);
				break;
			case 0:
				newPos.setX(newPos.getX() - unitSize / 2);
				newPos.setZ(newPos.getZ() + unitSize / 2);
				break;
			}
		}

		return newPos;
	}

	private static void makeStepStructure(Position pos, char direction, double unitSize) {
//	switch (direction) {
//	case 'R':
//		pos.setX(pos.getX() + length);
//		break;
//	case 'D':
//		pos.setZ(pos.getZ() - length);
//		break;
//	case 'L':
//		pos.setX(pos.getX() - length);
//		break;
//	case 'U':
//		pos.setZ(pos.getZ() + length);
//		break;
//	}
//   }
		switch (direction) {
		case 'R':
			pos.setX(pos.getX() - unitSize);
			pos.setZ(pos.getZ());
			break;
		case 'D':
			pos.setX(pos.getX());
			pos.setZ(pos.getZ() - unitSize);
			break;
		case 'L':
			pos.setX(pos.getX() + unitSize);
			pos.setZ(pos.getZ());
			break;
		case 'U':
			pos.setX(pos.getX());
			pos.setZ(pos.getZ() + unitSize);
			break;
		}
	}
}