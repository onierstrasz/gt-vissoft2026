Class {
	#name : 'VSLoadSnapshot',
	#superclass : 'Object',
	#category : 'GtVissoft2026-Examples',
	#package : 'GtVissoft2026',
	#tag : 'Examples'
}

{ #category : 'accessing' }
VSLoadSnapshot >> clearVSPackage [
	<gtExample>
	<noTest>
	self packageOrganizer
		packageNamed: #VISSOFT
		ifPresent: [ :p | p removeFromSystem ].
	^ Smalltalk packageOrganizer ensurePackage: 'VISSOFT'
]

{ #category : 'as yet unclassified' }
VSLoadSnapshot >> fileIn: fileOutName [
	self clearVSPackage.
	(self fileOutsFolder / fileOutName) fileIn.
	^ self vsPackage
]

{ #category : 'as yet unclassified' }
VSLoadSnapshot >> fileOutsFolder [
	<gtExample>
	<noTest>
	^ FileLocator gtResource / 'onierstrasz' / 'gt-vissoft2026' / 'fileOuts'
]

{ #category : 'as yet unclassified' }
VSLoadSnapshot >> incrementalFullModel [
	<gtExample>
	<noTest>
	^ self fileIn: 'VISSOFT-full-model.st'
]

{ #category : 'as yet unclassified' }
VSLoadSnapshot >> incrementalFullModelWithoutMondrianGraphs [
	"Same as incrementalFullModel but without the Mondrian graphs and views."

	<gtExample>
	<noTest>
	^ self fileIn: 'VISSOFT-model-without-mondrian-views.st'
]

{ #category : 'as yet unclassified' }
VSLoadSnapshot >> oneShotModelGeneration [
	<gtExample>
	<noTest>
	^ self fileIn: 'VISSOFT-1shot-model-creation.st'
]

{ #category : 'as yet unclassified' }
VSLoadSnapshot >> vsPackage [
	<gtExample>
	<noTest>
	^ #VISSOFT asPackage
]
