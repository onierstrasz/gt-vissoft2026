Class {
	#name : 'VSTopic',
	#superclass : 'Object',
	#instVars : [
		'name',
		'papers'
	],
	#category : 'GtVissoft2026-Model',
	#package : 'GtVissoft2026',
	#tag : 'Model'
}

{ #category : 'adding' }
VSTopic >> addPaper: aVSPaper [
	papers addIfNotPresent: aVSPaper
]

{ #category : 'initialization' }
VSTopic >> initialize [
	super initialize.
	papers := OrderedCollection new
]

{ #category : 'accessing' }
VSTopic >> name [
	^ name
]

{ #category : 'accessing' }
VSTopic >> name: aString [
	name := aString
]

{ #category : 'accessing' }
VSTopic >> papers [
	^ papers
]

{ #category : 'printing' }
VSTopic >> printOn: aStream [
	aStream nextPutAll: self name
]
