"
Examples for the author relationships in a visual software study.
"
Class {
	#name : 'VSAuthorExamples',
	#superclass : 'Object',
	#category : 'GtVissoft2026-Examples',
	#package : 'GtVissoft2026',
	#tag : 'Examples'
}

{ #category : 'examples' }
VSAuthorExamples >> authorPapersAreSortedAndNumbered [
	<gtExample>
	| anAuthor papers |
	anAuthor := self studyCreatesUniqueAuthorsAndLinksPapers.
	papers := anAuthor papers
		sorted: [ :aPaper :anotherPaper | aPaper id asNumber < anotherPaper id asNumber ].
	self assert: papers size equals: anAuthor papers size.
	self assert: (papers allSatisfy: [ :aPaper | aPaper authors includes: anAuthor ]).
	self assert: (papers withIndexCollect: [ :aPaper :anIndex | anIndex -> aPaper ]) first key equals: 1.
	^ anAuthor
]

{ #category : 'examples' }
VSAuthorExamples >> authorPrintsItsName [
	<gtExample>
	| anAuthor |
	anAuthor := self studyCreatesUniqueAuthorsAndLinksPapers.
	self assert: anAuthor printString equals: anAuthor name.
	^ anAuthor
]

{ #category : 'examples' }
VSAuthorExamples >> reachableAuthorPaperGraph [
	<gtExample>
	<return: #GtMondrian>
	| anAuthor aGraph |
	anAuthor := self studyCreatesUniqueAuthorsAndLinksPapers.
	aGraph := GtMondrian new.
	anAuthor reachableAuthorPaperGraphIn: aGraph.
	self assert: aGraph topStep root graph nodeChildren size > anAuthor papers size.
	self assert: aGraph topStep root graph edgeChildren size > 0.
	^ aGraph
]

{ #category : 'examples' }
VSAuthorExamples >> reachableAuthorPaperGraphDoesNotModifyStartingAuthorPapers [
	<gtExample>
	<return: #GtMondrian>
	| anAuthor originalPapers aGraph |
	anAuthor := self studyCreatesUniqueAuthorsAndLinksPapers.
	originalPapers := anAuthor papers copy.
	aGraph := GtMondrian new.
	anAuthor reachableAuthorPaperGraphIn: aGraph.
	self assert: anAuthor papers equals: originalPapers.
	^ aGraph
]

{ #category : 'examples' }
VSAuthorExamples >> reachableAuthorPaperGraphHighlightsStartingAuthor [
	<gtExample>
	<return: #BlElement>
	| anAuthor aNode |
	anAuthor := self studyCreatesUniqueAuthorsAndLinksPapers.
	aNode := anAuthor authorPaperNodeFor: anAuthor.
	self assert: aNode background paint color equals: Color lightBlue darker.
	^ aNode
]

{ #category : 'examples' }
VSAuthorExamples >> studyCreatesUniqueAuthorsAndLinksPapers [
	<gtExample>
	| aStudy aPaper anAuthor |
	aStudy := VSStudy new.
	aPaper := aStudy paperAt: '1'.
	anAuthor := aStudy authorNamed: 'Sajaniemi, J.'.
	self assert: anAuthor class equals: VSAuthor.
	self assert: (aStudy authorNamed: 'Sajaniemi, J.') equals: anAuthor.
	self assert: (aStudy authorNamed: 'Sajaniemi, J.') == anAuthor.
	self assert: (anAuthor papers includes: aPaper).
	^ anAuthor
]
