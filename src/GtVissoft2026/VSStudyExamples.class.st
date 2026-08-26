Class {
	#name : 'VSStudyExamples',
	#superclass : 'Object',
	#category : 'GtVissoft2026-Examples',
	#package : 'GtVissoft2026',
	#tag : 'Examples'
}

{ #category : 'examples' }
VSStudyExamples >> study [
	<gtExample>
	| aStudy |
	aStudy := VSStudy new.
	self assert: aStudy allPapers size equals: 346.
	self assert: aStudy selectedPapers size equals: 65.
	^ aStudy
]
