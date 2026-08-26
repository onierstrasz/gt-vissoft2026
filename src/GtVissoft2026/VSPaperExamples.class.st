Class {
	#name : 'VSPaperExamples',
	#superclass : 'Object',
	#category : 'GtVissoft2026-Examples',
	#package : 'GtVissoft2026',
	#tag : 'Examples'
}

{ #category : 'examples' }
VSPaperExamples >> designStudyReceivesSelectedRecord [
	<gtExample>
	| aStudy designStudy |
	aStudy := VSStudy new.
	designStudy := aStudy allPapers values
		detect: [ :each | each isDesignStudy and: [ each selectedRecord notNil ] ].
	self
		assert: (designStudy selectedRecord at: 'ID')
		equals: designStudy id.
	^ designStudy
]

{ #category : 'examples' }
VSPaperExamples >> studyCreatesPapersKeyedById [
	<gtExample>
	| aStudy aPaper |
	aStudy := VSStudy new.
	self assert: aStudy allPapers size equals: 346.
	aPaper := aStudy paperAt: '1'.
	self assert: aPaper class equals: VSPaper.
	self assert: aPaper study equals: aStudy.
	self assert: aPaper id equals: '1'.
	^ aStudy
]
