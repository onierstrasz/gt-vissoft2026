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

{ #category : 'visualization' }
VSPaper >> authorPaperMondrian: aMondrian [
	"Build a three-level graph: this paper, its authors, and all papers by those authors."
	| authors papers |
	authors := self authors.
	papers := ({ self } , (authors flatCollect: #papers)) asSet asOrderedCollection.

	aMondrian nodes
		stencil: [ :aPaper |
			BlTextElement new
				text: '' asRopedText;
				background: (Color r: 1.0 g: 0.78 b: 0.82);
				border: (BlBorder paint: Color gray);
				geometry: BlEllipseGeometry new;
				size: (30 + (aPaper authors size * 8)) asPoint;
				aptitude: (BrGlamorousWithLabelTooltipAptitude text: (aPaper record at: 'Title'));
				when: BlClickEvent do: [ :anEvent | anEvent currentTarget phlow spawnObject: aPaper ] ];
		with: papers.
	aMondrian nodes
		stencil: [ :anAuthor |
			BlTextElement new
				text: (self initialsForAuthor: anAuthor) asRopedText;
				background: (Color r: 0.68 g: 0.85 b: 0.90);
				border: (BlBorder paint: Color gray);
				geometry: BlRectangleGeometry new;
				size: (30 + (anAuthor papers size * 8)) asPoint;
				aptitude: (BrGlamorousWithLabelTooltipAptitude text: anAuthor name);
				when: BlClickEvent do: [ :anEvent | anEvent currentTarget phlow spawnObject: anAuthor ] ];
		with: authors.
	aMondrian edges
		connect: papers
		from: [ :aPaper | aPaper ]
		toAll: #authors.
	aMondrian layout custom: (GtGraphForceBasedLayout new
		charge: -2000;
		length: 200)
]

{ #category : 'accessing' }
VSPaper >> authors [
	^ self authorNames collect: [ :eachName | study authorNamed: eachName ]
]

{ #category : 'visualization' }
VSPaper >> gtAuthorPaperGraphFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Author-paper graph';
		priority: 10;
		painting: [ :aMondrian | self authorPaperMondrian: aMondrian ];
		actionUpdateButton
]

{ #category : 'gt-views' }
VSPaper >> gtAuthorsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Authors';
		priority: 1;
		items: [ self authors ];
		column: 'Author' text: [ :anAuthor | anAuthor name ] weight: 2;
		column: '# of papers' text: [ :anAuthor | anAuthor papers size ] weight: 0.6;
		send: [ :anAuthor | anAuthor ]
]

{ #category : 'gt-views' }
VSPaper >> gtStudyDetailsFor: aView [
	<gtView>
	selectedRecord ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Study Details';
		priority: 3;
		items: [ selectedRecord associations sorted: [ :left :right | left key <= right key ] ];
		column: 'Attribute' text: [ :anAssociation | anAssociation key ] weight: 1;
		column: 'Value' text: [ :anAssociation | anAssociation value ] weight: 4;
		send: [ :anAssociation | anAssociation value ]
]

{ #category : 'gt-views' }
VSPaper >> gtSummaryFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Summary';
		priority: 2;
		items: [
			| authorKeys otherKeys orderedKeys |
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
			otherKeys := record keys reject: [ :aKey |
				(aKey allSatisfy: [ :aCharacter | aCharacter isDigit ])
					or: [ aKey = 'Title' or: [ authorKeys includes: aKey ] ] ].
			orderedKeys := { 'Title' }
				, (authorKeys select: [ :aKey | record includesKey: aKey ])
				, otherKeys asSortedCollection.
			orderedKeys collect: [ :aKey | aKey -> (record at: aKey) ] ];
		column: 'Attribute' text: [ :anAssociation | anAssociation key ] weight: 1;
		column: 'Value' text: [ :anAssociation | anAssociation value ] weight: 4;
		send: [ :anAssociation | anAssociation value ]
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
