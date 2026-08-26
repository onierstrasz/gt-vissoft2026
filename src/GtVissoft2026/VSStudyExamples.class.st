Class {
	#name : 'VSStudyExamples',
	#superclass : 'Object',
	#category : 'GtVissoft2026-Examples',
	#package : 'GtVissoft2026',
	#tag : 'Examples'
}

{ #category : 'examples' }
VSStudyExamples >> authorsAreListedByName [
	<gtExample>
	| aStudy authors |
	aStudy := self study.
	authors := aStudy authors values asSortedCollection: [ :anAuthor :anotherAuthor | anAuthor name < anotherAuthor name ].
	self assert: authors size equals: aStudy authors size.
	self assert: (authors allSatisfy: [ :anAuthor | anAuthor isKindOf: VSAuthor ]).
	self assert: (authors allSatisfy: [ :anAuthor | anAuthor papers isNotEmpty ]).
	^ aStudy
]

{ #category : 'examples' }
VSStudyExamples >> paperAuthorCounts [
	<gtExample>
	| aStudy papers |
	aStudy := self study.
	papers := aStudy allPapers values.
	self assert: (papers allSatisfy: [ :aPaper | aPaper authorNames size >= 0 ]).
	self assert: (papers anySatisfy: [ :aPaper | aPaper authorNames size > 1 ]).
	^ papers
]

{ #category : 'examples' }
VSStudyExamples >> papersAreNumberedAndSortedById [
	<gtExample>
	| aStudy papers |
	aStudy := self study.
	papers := aStudy allPapers values
		sorted: [ :aPaper :anotherPaper | aPaper id asNumber < anotherPaper id asNumber ].
	self assert: papers first id equals: '1'.
	self assert: papers size equals: aStudy allPapers size.
	self assert: (papers withIndexCollect: [ :aPaper :anIndex | anIndex -> aPaper ]) first key equals: 1.
	^ papers
]

{ #category : 'examples' }
VSStudyExamples >> selectedDesignStudyPapers [
	<gtExample>
	| aStudy papers |
	aStudy := self study.
	papers := aStudy allPapers values select: [ :aPaper | aPaper isDesignStudy and: [ aPaper selectedRecord notNil ] ].
	self assert: papers size equals: aStudy selectedPapers size.
	self assert: (papers allSatisfy: [ :aPaper | aPaper isDesignStudy ]).
	^ papers
]

{ #category : 'examples' }
VSStudyExamples >> selectedPapersAreNumberedAndSortedById [
	<gtExample>
	| aStudy papers |
	aStudy := self study.
	papers := (aStudy allPapers values select: [ :aPaper | aPaper isDesignStudy and: [ aPaper selectedRecord notNil ] ])
		sorted: [ :aPaper :anotherPaper | aPaper id asNumber < anotherPaper id asNumber ].
	self assert: papers size equals: aStudy selectedPapers size.
	self assert: (papers withIndexCollect: [ :aPaper :anIndex | anIndex -> aPaper ]) first key equals: 1.
	self assert: (papers allSatisfy: [ :aPaper | aPaper isDesignStudy ]).
	^ papers
]

{ #category : 'examples' }
VSStudyExamples >> study [
	<gtExample>
	| aStudy |
	aStudy := VSStudy new.
	self assert: aStudy allPapers size equals: 346.
	self assert: aStudy selectedPapers size equals: 65.
	^ aStudy
]
