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
VSPaperExamples >> nonDesignStudyHasNoStudyDetails [
	<gtExample>
	| aStudy aPaper |
	aStudy := VSStudy new.
	aPaper := aStudy allPapers values detect: [ :each | each isDesignStudy not ].
	self assert: aPaper selectedRecord isNil.
	^ aPaper
]

{ #category : 'examples' }
VSPaperExamples >> paperAuthorsAreLinkedToAuthorInstances [
	<gtExample>
	| aPaper authors |
	aPaper := self paperPrintsItsTitle.
	authors := aPaper authors.
	self assert: authors size equals: aPaper authorNames size.
	self assert: (authors allSatisfy: [ :anAuthor | anAuthor isKindOf: VSAuthor ]).
	self assert: (authors allSatisfy: [ :anAuthor | anAuthor papers includes: aPaper ]).
	self assert: (authors allSatisfy: [ :anAuthor | anAuthor papers size > 0 ]).
	^ aPaper
]

{ #category : 'examples' }
VSPaperExamples >> paperPrintsItsTitle [
	<gtExample>
	| aPaper |
	aPaper := self designStudyReceivesSelectedRecord.
	self assert: aPaper printString equals: (aPaper record at: 'Title').
	^ aPaper
]

{ #category : 'examples' }
VSPaperExamples >> paperSummaryContainsAllRecordAttributes [
	<gtExample>
	| aPaper |
	aPaper := self paperPrintsItsTitle.
	self assert: aPaper record associations size equals: aPaper record keys size.
	self assert: (aPaper record includesKey: 'Title').
	^ aPaper
]

{ #category : 'examples' }
VSPaperExamples >> paperSummaryOrdersTitleAndAuthorsAndHidesNumericAttributes [
	<gtExample>
	| aPaper authorKeys otherKeys orderedKeys |
	aPaper := self paperPrintsItsTitle.
	authorKeys := #(
		'First Author'
		'Second Author'
		'Third Author'
		'Fourth Author'
		'Fifth Author'
		'Sixth Author'
		'Seven Author'
		'Eighth Author'
		'Nineth Author'
		'Tenth Author'
		'Eleventh Author'
		'Twelfth Author').
	otherKeys := aPaper record keys reject: [ :aKey |
		(aKey allSatisfy: [ :aCharacter | aCharacter isDigit ])
			or: [ aKey = 'Title' or: [ authorKeys includes: aKey ] ] ].
	orderedKeys := { 'Title' }
		, (authorKeys select: [ :aKey | aPaper record includesKey: aKey ])
		, otherKeys asSortedCollection.
	self assert: orderedKeys first equals: 'Title'.
	self assert: (orderedKeys includes: '1') equals: false.
	self assert: (orderedKeys indexOf: 'First Author') < (orderedKeys indexOf: 'Second Author').
	^ aPaper
]

{ #category : 'examples' }
VSPaperExamples >> selectedPaperHasStudyDetails [
	<gtExample>
	| aPaper |
	aPaper := self designStudyReceivesSelectedRecord.
	self assert: aPaper isDesignStudy.
	self assert: aPaper selectedRecord isNotNil.
	self assert: aPaper selectedRecord associations isNotEmpty.
	^ aPaper
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
