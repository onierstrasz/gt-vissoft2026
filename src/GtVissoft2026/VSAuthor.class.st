"
An author participating in one or more papers in a visual software study.
"
Class {
	#name : 'VSAuthor',
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
VSAuthor >> addPaper: aVSPaper [
	papers addIfNotPresent: aVSPaper
]

{ #category : 'visualizing' }
VSAuthor >> authorPaperGraphIn: aMondrian papers: papers authors: authors [
	"Render a paper-author graph, emphasizing this author as its starting node."
	aMondrian nodes
		stencil: [ :aModel | self authorPaperNodeFor: aModel ];
		with: (papers asArray , authors asArray).
	authors do: [ :anAuthor |
		aMondrian edges
			connect: (anAuthor papers select: [ :aPaper | papers includes: aPaper ])
			from: [ :aPaper | anAuthor ]
			to: [ :aPaper | aPaper ] ].
	aMondrian layout custom: (GtGraphForceBasedLayout new
		charge: -2000;
		length: 200)
]

{ #category : 'visualizing' }
VSAuthor >> authorPaperNodeFor: aModel [
	| isAuthor size tooltipText element |
	isAuthor := aModel isKindOf: VSAuthor.
	size := isAuthor
		ifTrue: [ 25 + (aModel papers size * 8) ]
		ifFalse: [ 25 + (aModel authors size * 8) ].
	tooltipText := isAuthor
		ifTrue: [ aModel name ]
		ifFalse: [ aModel record at: 'Title' ].
	element := BlElement new
		background: (isAuthor
			ifTrue: [ aModel == self ifTrue: [ Color lightBlue darker ] ifFalse: [ Color lightBlue ] ]
			ifFalse: [ Color paleRed ]);
		geometry: (isAuthor
			ifTrue: [ BlRectangleGeometry new ]
			ifFalse: [ BlEllipseGeometry new ]);
		size: size @ size;
		addAptitude: (BrGlamorousWithLabelTooltipAptitude text: tooltipText);
		when: BlClickEvent do: [ :anEvent | anEvent currentTarget phlow spawnObject: aModel ];
		yourself.
	isAuthor ifTrue: [
		element
			layout: BlFrameLayout new;
			addChild: (BlTextElement new
				text: (self initialsFor: aModel) asRopedText;
				constraintsDo: [ :aConstraints |
					aConstraints frame horizontal alignCenter.
					aConstraints frame vertical alignCenter ]) ]
	ifFalse: [ aModel isDesignStudy ifTrue: [ element border: (BlBorder paint: Color red width: 2) ] ].
	^ element
]

{ #category : 'gt views' }
VSAuthor >> gtPapersFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Papers';
		items: [ (self papers
			sorted: [ :aPaper :anotherPaper | aPaper id asNumber < anotherPaper id asNumber ])
			withIndexCollect: [ :aPaper :anIndex | anIndex -> aPaper ] ];
		column: '#' text: [ :anAssociation | anAssociation key ] weight: 0.3;
		column: 'ID' text: [ :anAssociation | anAssociation value id ] weight: 0.4;
		column: 'Title' text: [ :anAssociation | anAssociation value record at: 'Title' ] weight: 4;
		column: 'Type' text: [ :anAssociation | anAssociation value record at: 'Type' ] weight: 0.8;
		column: '# of Authors' text: [ :anAssociation | anAssociation value authorNames size ] weight: 0.6;
		column: 'Year' text: [ :anAssociation | anAssociation value record at: 'Year' ] weight: 0.5;
		column: 'First author' text: [ :anAssociation | anAssociation value authorNames at: 1 ifAbsent: [ '' ] ] weight: 1.5;
		column: 'Second author' text: [ :anAssociation | anAssociation value authorNames at: 2 ifAbsent: [ '' ] ] weight: 1.5;
		send: [ :anAssociation | anAssociation value ];
		actionUpdateButton
]

{ #category : 'visualizing' }
VSAuthor >> gtReachableAuthorPaperGraphFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Reachable author papers graph';
		priority: 51;
		painting: [ :aMondrian | self reachableAuthorPaperGraphIn: aMondrian ];
		actionUpdateButton
]

{ #category : 'initialization' }
VSAuthor >> initialize [
	super initialize.
	papers := OrderedCollection new
]

{ #category : 'accessing' }
VSAuthor >> initialsFor: anAuthor [
	"Answer available given-name and surname initials for a name formatted as 'Surname, Given names'."
	| nameParts surname givenNames givenLetters surnameLetters |
	nameParts := anAuthor name substrings: ','.
	surname := nameParts first ifNil: [ '' ].
	givenNames := nameParts allButFirst joinUsing: ' '.
	givenLetters := givenNames select: #isLetter.
	surnameLetters := surname select: #isLetter.
	^ (givenLetters
		ifEmpty: [ '' ]
		ifNotEmpty: [ givenLetters first asString ])
		, (surnameLetters
			ifEmpty: [ '' ]
			ifNotEmpty: [ surnameLetters first asString ])
]

{ #category : 'accessing' }
VSAuthor >> name [
	^ name
]

{ #category : 'accessing' }
VSAuthor >> name: aString [
	name := aString
]

{ #category : 'accessing' }
VSAuthor >> papers [
	^ papers
]

{ #category : 'printing' }
VSAuthor >> printOn: aStream [
	aStream nextPutAll: self name
]

{ #category : 'visualizing' }
VSAuthor >> reachableAuthorPaperGraphIn: aMondrian [
	"Visualize the complete paper-author connected component containing this author without modifying its paper collection."
	| papers authors pendingPapers aPaper |
	papers := self papers asIdentitySet.
	authors := IdentitySet with: self.
	pendingPapers := self papers copy asOrderedCollection.
	[ pendingPapers isEmpty ] whileFalse: [
		aPaper := pendingPapers removeFirst.
		aPaper authors do: [ :anAuthor |
			authors add: anAuthor.
			anAuthor papers do: [ :anotherPaper |
				(papers includes: anotherPaper) ifFalse: [
					papers add: anotherPaper.
					pendingPapers add: anotherPaper ] ] ] ].
	self authorPaperGraphIn: aMondrian papers: papers authors: authors
]
