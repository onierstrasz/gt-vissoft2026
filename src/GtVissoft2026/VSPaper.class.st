Class {
	#name : 'VSPaper',
	#superclass : 'Object',
	#instVars : [
		'record',
		'study',
		'selectedRecord'
	],
	#category : 'GtVissoft2026-Model',
	#package : 'GtVissoft2026',
	#tag : 'Model'
}

{ #category : 'accessing' }
VSPaper >> authorNames [
	| authorKeys |
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
	^ (authorKeys collect: [ :aKey |
		(record at: aKey ifAbsent: [ '' ]) copyWithout: $" ])
		collect: [ :aName | aName trimBoth ]
		thenSelect: [ :aName | aName isNotEmpty ]
]

{ #category : 'visualizing' }
VSPaper >> authorPaperGraphIn: aMondrian papers: papers authors: authors startingPaper: aStartingPaper connectStartingPaper: shouldConnectStartingPaper [
	"Render a paper/author graph using the supplied paper and author collections."
	aMondrian nodes
		stencil: [ :aModel | self authorPaperNodeFor: aModel startingPaper: aStartingPaper ];
		with: (papers asArray , authors asArray).
	shouldConnectStartingPaper ifTrue: [
		aMondrian edges
			connect: authors
			from: [ :anAuthor | self ]
			to: [ :anAuthor | anAuthor ] ].
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
VSPaper >> authorPaperNodeFor: aModel [
	^ self authorPaperNodeFor: aModel startingPaper: nil
]

{ #category : 'visualizing' }
VSPaper >> authorPaperNodeFor: aModel startingPaper: aStartingPaper [
	| size element tooltipText isAuthor isStartingPaper |
	isAuthor := aModel isKindOf: VSAuthor.
	isStartingPaper := aModel == aStartingPaper.
	size := isAuthor
		ifTrue: [ 25 + (aModel papers size * 8) ]
		ifFalse: [ 25 + (aModel authors size * 8) ].
	tooltipText := isAuthor
		ifTrue: [ aModel name ]
		ifFalse: [ aModel record at: 'Title' ].
	element := BlElement new
		background: (isAuthor
			ifTrue: [ Color lightBlue ]
			ifFalse: [ isStartingPaper ifTrue: [ Color paleRed darker ] ifFalse: [ Color paleRed ] ]);
		geometry: (isAuthor
			ifTrue: [ BlRectangleGeometry new ]
			ifFalse: [ BlEllipseGeometry new ]);
		size: size @ size;
		addAptitude: (BrGlamorousWithLabelTooltipAptitude text: tooltipText);
		when: BlClickEvent do: [ :anEvent | anEvent currentTarget phlow spawnObject: aModel ];
		yourself.
	(aModel isKindOf: VSPaper) ifTrue: [
		aModel isDesignStudy ifTrue: [
			element border: (BlBorder paint: Color red width: 2) ] ].
	isAuthor ifTrue: [
		element
			layout: BlFrameLayout new;
			addChild: (BlTextElement new
				text: (self initialsForAuthor: aModel) asRopedText;
				constraintsDo: [ :aConstraints |
					aConstraints frame horizontal alignCenter.
					aConstraints frame vertical alignCenter ]) ].
	^ element
]

{ #category : 'accessing' }
VSPaper >> authors [
	^ self authorNames collect: [ :eachName | study authorNamed: eachName ]
]

{ #category : 'accessing' }
VSPaper >> googleScholarSearchUrl [
	^ 'https://scholar.google.com/scholar?hl=en&q=' , (record at: 'Title') urlEncoded
]

{ #category : 'gt views' }
VSPaper >> gtAuthorsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Authors';
		priority: 1;
		items: [ self authors ];
		column: 'Author' text: [ :anAuthor | anAuthor name ] weight: 2;
		column: '# of papers' text: [ :anAuthor | anAuthor papers size ] weight: 0.6;
		send: [ :anAuthor | anAuthor ];
		actionUpdateButton
]

{ #category : 'gt-actions' }
VSPaper >> gtGoogleScholarSearchFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons web;
		tooltip: 'Search title in Google Scholar';
		action: [ :aButton | WebBrowser openOn: self googleScholarSearchUrl ]
]

{ #category : 'visualizing' }
VSPaper >> gtReachableAuthorPaperGraphFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Reachable author papers graph';
		priority: 11;
		painting: [ :aMondrian | self reachableAuthorPaperGraphIn: aMondrian ];
		actionUpdateButton
]

{ #category : 'gt views' }
VSPaper >> gtStudyDetailsFor: aView [
	<gtView>
	selectedRecord ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Study Details';
		priority: 3;
		items: [ selectedRecord associations sorted: [ :left :right | left key <= right key ] ];
		column: 'Attribute' text: [ :anAssociation | anAssociation key ] weight: 1;
		column: 'Value' text: [ :anAssociation | anAssociation value ] weight: 4;
		send: [ :anAssociation | anAssociation value ];
		actionUpdateButton
]

{ #category : 'gt views' }
VSPaper >> gtSummaryFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Summary';
		priority: 2;
		items: [
			| authorKeys otherKeys orderedKeys |
			authorKeys := #('First Author' 'Second Author' 'Third Author' 'Fourth Author' 'Fifth Author' 'Sixth Author' 'Seven Author' 'Eighth Author' 'Nineth Author' 'Tenth Author' 'Eleventh Author' 'Twelfth Author').
			otherKeys := record keys reject: [ :aKey |
				(aKey allSatisfy: [ :aCharacter | aCharacter isDigit ])
					or: [ aKey = 'Title' or: [ authorKeys includes: aKey ] ] ].
			orderedKeys := { 'Title' }, (authorKeys select: [ :aKey | record includesKey: aKey ]), otherKeys asSortedCollection.
			orderedKeys collect: [ :aKey | aKey -> (record at: aKey) ] ];
		column: 'Attribute' text: [ :anAssociation | anAssociation key ] weight: 1;
		column: 'Value' text: [ :anAssociation | anAssociation value ] weight: 4;
		send: [ :anAssociation | anAssociation value ];
		actionUpdateButton
]

{ #category : 'accessing' }
VSPaper >> id [
	^ record at: 'ID'
]

{ #category : 'visualization' }
VSPaper >> initialsForAuthor: anAuthor [
	"Answer the first letter of the given name followed by the first letter of the surname, without periods."
	| nameParts surname givenNames givenInitial surnameInitial |
	nameParts := anAuthor name substrings: ','.
	surname := nameParts first trimBoth.
	givenNames := nameParts allButFirst joinUsing: ' '.
	givenInitial := (givenNames select: #isLetter) first asString.
	surnameInitial := (surname select: #isLetter) first asString.
	^ givenInitial , surnameInitial
]

{ #category : 'testing' }
VSPaper >> isDesignStudy [
	^ (record at: 'Type' ifAbsent: [ nil ]) = 'Design Study'
]

{ #category : 'printing' }
VSPaper >> printOn: aStream [
	aStream nextPutAll: (record at: 'Title')
]

{ #category : 'visualizing' }
VSPaper >> reachableAuthorPaperGraphIn: aMondrian [
	"Visualize the complete paper-author connected component containing this paper."
	| component |
	component := self reachablePaperAuthorComponent.
	self
		authorPaperGraphIn: aMondrian
		papers: component key
		authors: component value
		startingPaper: self
		connectStartingPaper: false
]

{ #category : 'visualizing' }
VSPaper >> reachablePaperAuthorComponent [
	"Answer papers -> authors in the connected paper-author component containing this paper."
	| papers authors pendingPapers aPaper |
	papers := IdentitySet with: self.
	authors := IdentitySet new.
	pendingPapers := OrderedCollection with: self.
	[ pendingPapers isEmpty ] whileFalse: [
		aPaper := pendingPapers removeFirst.
		aPaper authors do: [ :anAuthor |
			authors add: anAuthor.
			anAuthor papers do: [ :anotherPaper |
				(papers includes: anotherPaper) ifFalse: [
					papers add: anotherPaper.
					pendingPapers add: anotherPaper ] ] ] ].
	^ papers -> authors
]

{ #category : 'accessing' }
VSPaper >> record [
	^ record
]

{ #category : 'accessing' }
VSPaper >> record: aDictionary [
	record := aDictionary
]

{ #category : 'accessing' }
VSPaper >> selectedRecord [
	^ selectedRecord
]

{ #category : 'accessing' }
VSPaper >> selectedRecord: aDictionary [
	selectedRecord := aDictionary
]

{ #category : 'accessing' }
VSPaper >> study [
	^ study
]

{ #category : 'accessing' }
VSPaper >> study: aVSStudy [
	study := aVSStudy
]

{ #category : 'accessing' }
VSPaper >> topic [
	^ self topicName
		ifNil: [ nil ]
		ifNotNil: [ :aName | study topicNamed: aName ]
]

{ #category : 'accessing' }
VSPaper >> topicName [
	^ selectedRecord
		ifNil: [ nil ]
		ifNotNil: [ selectedRecord at: 'Topic' ifAbsent: [ nil ] ]
]
