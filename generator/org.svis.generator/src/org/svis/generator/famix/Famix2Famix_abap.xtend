package org.svis.generator.famix

import java.util.List
import org.eclipse.emf.mwe.core.WorkflowContext
import org.eclipse.emf.mwe.core.issues.Issues
import org.eclipse.emf.mwe.core.monitor.ProgressMonitor
import org.svis.xtext.famix.FAMIXNamespace
import java.util.Set
import org.svis.xtext.famix.FAMIXClass
import org.svis.xtext.famix.FAMIXParameterizableClass
import org.svis.xtext.famix.FAMIXMethod
import org.svis.xtext.famix.FAMIXEnum
import org.svis.xtext.famix.FAMIXParameter
import org.svis.xtext.famix.FAMIXParameterizedType
import org.svis.xtext.famix.FAMIXInheritance
import org.svis.xtext.famix.FAMIXEnumValue
import org.svis.xtext.famix.FAMIXAttribute
import org.svis.xtext.famix.FAMIXStructure
import org.svis.xtext.famix.Root
import java.util.Collections
import org.svis.xtext.famix.FAMIXComment
import org.svis.xtext.famix.FAMIXLocalVariable
import org.svis.xtext.famix.FAMIXAnnotationType
import org.svis.xtext.famix.FAMIXAnnotationTypeAttribute
import org.svis.xtext.famix.FAMIXFileAnchor
import org.svis.xtext.famix.FAMIXAccess
import org.svis.xtext.famix.FAMIXInvocation
import org.svis.xtext.famix.FAMIXPrimitiveType
import org.svis.xtext.famix.FAMIXType
import org.svis.xtext.famix.FAMIXParameterType
import org.eclipse.emf.ecore.resource.impl.ResourceImpl
import org.apache.commons.beanutils.BeanComparator
import org.eclipse.emf.common.util.ECollections
import static org.apache.commons.codec.digest.DigestUtils.sha1Hex
import org.eclipse.xtext.linking.lazy.LazyLinkingResource
import java.util.Map
import org.svis.xtext.famix.impl.FamixFactoryImpl
import java.util.Comparator
import org.svis.xtext.famix.MethodType
import org.svis.xtext.famix.FAMIXAntipattern
import org.svis.xtext.famix.FAMIXPath
import org.svis.xtext.famix.FAMIXComponent
import org.svis.xtext.famix.IntegerReference
import org.neo4j.graphdb.GraphDatabaseService
import org.svis.lib.database.Database
import org.neo4j.graphdb.Node
import org.svis.xtext.famix.FAMIXElement
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.mwe.core.lib.WorkflowComponentWithModelSlot
import org.apache.commons.logging.LogFactory
import org.svis.generator.SettingsConfiguration
import org.svis.generator.SettingsConfiguration.FamixParser
import org.svis.generator.SettingsConfiguration.AbapNotInOriginFilter
import org.svis.xtext.famix.FAMIXReference

//ABAP
import org.svis.xtext.famix.FAMIXABAPElements
import org.svis.xtext.famix.FAMIXReport 
import org.svis.xtext.famix.FAMIXFormroutine
import org.svis.xtext.famix.FAMIXFunctionGroup
import org.svis.xtext.famix.FAMIXFunctionModule
import org.svis.xtext.famix.FAMIXMacro
import org.svis.xtext.famix.FAMIXDictionaryData
import org.svis.xtext.famix.FAMIXDataElement
import org.svis.xtext.famix.FAMIXDomain
import org.svis.xtext.famix.FAMIXTable
import org.svis.xtext.famix.FAMIXTableElement
import org.svis.xtext.famix.FAMIXABAPStruc
import org.svis.xtext.famix.FAMIXStrucElement
import org.svis.xtext.famix.FAMIXTableType
import org.svis.xtext.famix.FAMIXTableTypeElement
import org.svis.xtext.famix.FAMIXTypeOf
import org.svis.xtext.famix.FAMIXMessageClass

class Famix2Famix_abap extends WorkflowComponentWithModelSlot {
	
	override protected invokeInternal(WorkflowContext ctx, ProgressMonitor monitor, Issues issues) {
		
		var Root famixRoot
			// TODO: 	famixRoot = runAbap((resourceList as List<Root>).head)
			
			ctx.set("famix", famixRoot)
			val resource = new ResourceImpl()
			resource.contents += famixRoot
			ctx.set("metadata", resource)
	}	
}