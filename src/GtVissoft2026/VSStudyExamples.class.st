Class {
	#name : 'VSStudyExamples',
	#superclass : 'Object',
	#category : 'GtVissoft2026-Examples',
	#package : 'GtVissoft2026',
	#tag : 'Examples'
}

{ #category : 'examples' }
VSStudyExamples >> authorPaperGraph [
	<gtExample>
	<return: #GtMondrian>
	| aStudy aGraph designStudyPapers designStudyAuthors |
	aStudy := VSStudy new.
	designStudyPapers := aStudy allPapers values select: #isDesignStudy.
	designStudyAuthors := (designStudyPapers flatCollect: #authors) asIdentitySet.
	aGraph := GtMondrian new.
	aStudy authorPaperGraphIn: aGraph.
	self assert: aGraph topStep root graph nodeChildren size equals: designStudyPapers size + designStudyAuthors size.
	self assert: aGraph topStep root graph edgeChildren size equals: (designStudyAuthors sum: [ :anAuthor | anAuthor papers count: [ :aPaper | designStudyPapers includes: aPaper ] ]).
	^ aGraph
]

{ #category : 'examples' }
VSStudyExamples >> authorPaperGraphContainsOnlyDesignStudyPapers [
	<gtExample>
	<return: #GtMondrian>
	| aStudy aGraph paperModels authorModels |
	aStudy := VSStudy new.
	aGraph := self authorPaperGraph.
	paperModels := aGraph nodeElements
		collect: [ :each | each graph model ]
		thenSelect: [ :each | each isKindOf: VSPaper ].
	authorModels := aGraph nodeElements
		collect: [ :each | each graph model ]
		thenSelect: [ :each | each isKindOf: VSAuthor ].
	self assert: (paperModels allSatisfy: #isDesignStudy).
	self assert: (authorModels allSatisfy: [ :anAuthor | anAuthor papers anySatisfy: #isDesignStudy ]).
	^ aGraph
]

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
VSStudyExamples >> paperGroupReachableAuthorPaperGraph [
	<gtExample>
	<return: #GtMondrian>
	| aGroup component aGraph |
	aGroup := self study papersMatchingTitle: 'polyptychon'.
	component := aGroup reachablePaperAuthorComponent.
	aGraph := GtMondrian new.
	aGroup reachableAuthorPaperGraphIn: aGraph.
	self assert: aGraph topStep root graph nodeChildren size equals: component key size + component value size.
	self assert: aGraph topStep root graph edgeChildren size equals: (component value sum: [ :anAuthor | anAuthor papers count: [ :aPaper | component key includes: aPaper ] ]).
	^ aGraph
]

{ #category : 'Examples' }
VSStudyExamples >> paperGroupsByYear [
	<gtExample>
	| groups |
	groups := (VSPaperGroup withAll: self study allPapers values)
		groupedBy: [ :aPaper | aPaper record at: 'Paper Year' ].
	self assert: (groups at: '2015') class equals: VSPaperGroup.
	self assert: (groups at: '2015') size equals: 31.
	self assert: (groups values inject: 0 into: [ :sum :each | sum + each size ]) equals: 346.
	^ groups
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

{ #category : 'Examples' }
VSStudyExamples >> papersInYearReturnsAllPapers [
	<gtExample>
	| papers |
	papers := self study papersInYear: 2015 selectedOnly: false.
	self assert: papers class equals: VSPaperGroup.
	self assert: papers size equals: 31.
	self assert: (papers allSatisfy: [ :each | (each record at: 'Paper Year') = '2015' ]).
	^ papers
]

{ #category : 'Examples' }
VSStudyExamples >> papersInYearReturnsSelectedPapers [
	<gtExample>
	| papers |
	papers := self study papersInYear: 2015 selectedOnly: true.
	self assert: papers class equals: VSPaperGroup.
	self assert: papers size equals: 10.
	self assert: (papers allSatisfy: [ :each |
		(each record at: 'Paper Year') = '2015'
			and: [ each selectedRecord notNil ] ]).
	^ papers
]

{ #category : 'examples' }
VSStudyExamples >> papersMatchingTitleReturnsAPaperGroup [
	<gtExample>
	| aStudy matches |
	aStudy := self study.
	matches := aStudy papersMatchingTitle: 'polyptychon'.
	self assert: matches class equals: VSPaperGroup.
	self assert: matches size equals: 1.
	self assert: matches first id equals: '305'.
	^ matches
]

{ #category : 'examples' }
VSStudyExamples >> papersMatchingTitleReturnsPapersContainingTheQuery [
	<gtExample>
	| aStudy matches |
	aStudy := self study.
	matches := aStudy papersMatchingTitle: 'polyptychon'.
	self assert: matches size equals: 1.
	self assert: matches first id equals: '305'.
	self assert: (matches first record at: 'Title') equals: 'Polyptychon: A Hierarchically-Constrained Classified Dependencies Visualization'.
	^ matches
]

{ #category : 'Examples' }
VSStudyExamples >> reachableAuthorPaperGraphDoesNotEmptyPaperGroup [
	<gtExample>
	| group originalItems graph |
	group := ((VSPaperGroup withAll: self study allPapers values)
		groupedBy: [ :aPaper | aPaper record at: 'Paper Year' ]) at: '2015'.
	originalItems := group items asArray.
	graph := GtMondrian new.
	group reachableAuthorPaperGraphIn: graph.
	self assert: group size equals: originalItems size.
	self assert: group items asArray equals: originalItems.
	^ graph
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

{ #category : 'Examples' }
VSStudyExamples >> selectedPaperGroupsByYear [
	<gtExample>
	| groups |
	groups := (VSPaperGroup withAll: (self study allPapers values select: [ :aPaper | aPaper selectedRecord notNil ]))
		groupedBy: [ :aPaper | aPaper record at: 'Paper Year' ].
	self assert: (groups at: '2015') class equals: VSPaperGroup.
	self assert: (groups at: '2015') size equals: 10.
	self assert: (groups values inject: 0 into: [ :sum :each | sum + each size ]) equals: 65.
	^ groups
]

{ #category : 'examples' }
VSStudyExamples >> selectedPaperTopics [
	<gtExample>
	| papers |
	papers := self selectedPapersAreNumberedAndSortedById collect: #value.
	self assert: (papers allSatisfy: [ :aPaper | aPaper topicName = (aPaper selectedRecord at: 'Topic' ifAbsent: [ nil ]) ]).
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
