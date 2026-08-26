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
	| names |
	names := (record keys
		select: [ :each | each endsWith: ' Author' ])
		collect: [ :each | (record at: each) copyWithout: $" ].
	names := names collect: [ :each | each trimBoth ].
	^ names select: [ :each | each isNotEmpty ]
]

{ #category : 'accessing' }
VSPaper >> authors [
	^ self authorNames collect: [ :eachName | study authorNamed: eachName ]
]

{ #category : 'views' }
VSPaper >> gtAuthorsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Authors';
		items: [ self authors ];
		column: 'Author' text: [ :anAuthor | anAuthor name ] weight: 2;
		column: '# of papers' text: [ :anAuthor | anAuthor papers size ] weight: 0.6;
		send: [ :anAuthor | anAuthor ]
]

{ #category : 'views' }
VSPaper >> gtStudyDetailsFor: aView [
	<gtView>
	selectedRecord ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Study Details';
		items: [ selectedRecord associations sorted: [ :left :right | left key <= right key ] ];
		column: 'Attribute' text: [ :anAssociation | anAssociation key ] weight: 1;
		column: 'Value' text: [ :anAssociation | anAssociation value ] weight: 4;
		send: [ :anAssociation | anAssociation value ]
]

{ #category : 'views' }
VSPaper >> gtSummaryFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Summary';
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
