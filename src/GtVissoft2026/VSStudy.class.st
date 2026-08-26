Class {
	#name : 'VSStudy',
	#superclass : 'Object',
	#instVars : [
		'allPapers',
		'selectedPapers',
		'authors',
		'topics'
	],
	#category : 'GtVissoft2026-Model',
	#package : 'GtVissoft2026',
	#tag : 'Model'
}

{ #category : 'accessing' }
VSStudy >> allPapers [
	^ allPapers
]

{ #category : 'accessing' }
VSStudy >> authorNamed: aName [
	^ authors
		at: aName
		ifAbsentPut: [ VSAuthor new
			name: aName;
			yourself ]
]

{ #category : 'accessing' }
VSStudy >> authors [
	^ authors
]

{ #category : 'gt-views' }
VSStudy >> gtAuthorsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Authors';
		priority: 3;
		items: [ self authors values asSortedCollection: [ :anAuthor :anotherAuthor | anAuthor name < anotherAuthor name ] ];
		column: 'Author' text: [ :anAuthor | anAuthor name ] weight: 2;
		column: '# of papers' text: [ :anAuthor | anAuthor papers size ] weight: 0.6;
		send: [ :anAuthor | anAuthor ]
]

{ #category : 'gt-views' }
VSStudy >> gtPapersFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Papers';
		priority: 1;
		items: [ (allPapers values
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
		send: [ :anAssociation | anAssociation value ]
]

{ #category : 'gt-views' }
VSStudy >> gtSelectedPapersFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Selected Papers';
		priority: 2;
		items: [ ((allPapers values select: [ :aPaper | aPaper isDesignStudy and: [ aPaper selectedRecord notNil ] ])
			sorted: [ :aPaper :anotherPaper | aPaper id asNumber < anotherPaper id asNumber ])
			withIndexCollect: [ :aPaper :anIndex | anIndex -> aPaper ] ];
		column: '#' text: [ :anAssociation | anAssociation key ] weight: 0.3;
		column: 'ID' text: [ :anAssociation | anAssociation value id ] weight: 0.4;
		column: 'Title' text: [ :anAssociation | anAssociation value record at: 'Title' ] weight: 4;
		column: 'Type' text: [ :anAssociation | anAssociation value record at: 'Type' ] weight: 0.8;
		column: 'Topic' text: [ :anAssociation | anAssociation value topicName ifNil: [ '' ] ] weight: 1;
		column: '# of Authors' text: [ :anAssociation | anAssociation value authorNames size ] weight: 0.6;
		column: 'Year' text: [ :anAssociation | anAssociation value record at: 'Year' ] weight: 0.5;
		column: 'First author' text: [ :anAssociation | anAssociation value authorNames at: 1 ifAbsent: [ '' ] ] weight: 1.5;
		column: 'Second author' text: [ :anAssociation | anAssociation value authorNames at: 2 ifAbsent: [ '' ] ] weight: 1.5;
		send: [ :anAssociation | anAssociation value ]
]

{ #category : 'initialization' }
VSStudy >> initialize [
	super initialize.
	self loadFromResources
]

{ #category : 'initialization' }
VSStudy >> loadFromResources [
	| dataFolder allPaperRecords selectedPapersById |
	dataFolder := FileLocator gtResource / 'onierstrasz' / 'gt-vissoft2026' / 'data'.
	allPaperRecords := (CSV2JSON for: (dataFolder / 'dataset-review-vissoft-all.csv') contents) jsonObject.
	selectedPapers := (CSV2JSON for: (dataFolder / 'dataset-review-vissoft-selected.csv') contents) jsonObject.
	selectedPapersById := Dictionary new.
	selectedPapers do: [ :each | selectedPapersById at: (each at: 'ID') put: each ].
	allPapers := Dictionary new.
	authors := Dictionary new.
	topics := Dictionary new.
	allPaperRecords do: [ :each |
		| paper |
		paper := VSPaper new
			study: self;
			record: each;
			yourself.
		paper isDesignStudy ifTrue: [
			paper selectedRecord: (selectedPapersById at: paper id ifAbsent: [ nil ]) ].
		paper authorNames do: [ :eachName | (self authorNamed: eachName) addPaper: paper ].
		paper topic ifNotNil: [ :aTopic | aTopic addPaper: paper ].
		allPapers at: paper id put: paper ].
	^ self
]

{ #category : 'accessing' }
VSStudy >> paperAt: anId [
	^ allPapers at: anId
]

{ #category : 'accessing' }
VSStudy >> selectedPapers [
	^ selectedPapers
]

{ #category : 'accessing' }
VSStudy >> topicNamed: aName [
	^ topics
		at: aName
		ifAbsentPut: [ VSTopic new
			name: aName;
			yourself ]
]

{ #category : 'accessing' }
VSStudy >> topics [
	^ topics
]
