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

{ #category : 'graphing' }
VSStudy >> authorPaperGraphIn: aMondrian [
	"Visualize only Design Study papers and authors of those papers."
	| designStudyPapers designStudyAuthors |
	designStudyPapers := self allPapers values select: #isDesignStudy.
	designStudyAuthors := (designStudyPapers flatCollect: #authors) asIdentitySet.
	(VSPaperGroup withAll: designStudyPapers)
		renderAuthorPaperGraphIn: aMondrian
		papers: designStudyPapers
		authors: designStudyAuthors
		nodeStencil: [ :aModel | self authorPaperNodeFor: aModel ]
]

{ #category : 'visualizing' }
VSStudy >> authorPaperNodeFor: aModel [
	| isAuthor size tooltipText element |
	isAuthor := aModel isKindOf: VSAuthor.
	size := isAuthor
		ifTrue: [ 25 + (aModel papers size * 8) ]
		ifFalse: [ 25 + (aModel authors size * 8) ].
	tooltipText := isAuthor
		ifTrue: [ aModel name ]
		ifFalse: [ aModel record at: 'Title' ].
	element := BlElement new
		background: (isAuthor ifTrue: [ Color lightBlue ] ifFalse: [ Color paleRed ]);
		geometry: (isAuthor ifTrue: [ BlRectangleGeometry new ] ifFalse: [ BlEllipseGeometry new ]);
		size: size @ size;
		addAptitude: (BrGlamorousWithLabelTooltipAptitude text: tooltipText);
		when: BlClickEvent do: [ :anEvent | anEvent currentTarget phlow spawnObject: aModel ];
		yourself.
	isAuthor
		ifTrue: [
			element
				layout: BlFrameLayout new;
				addChild: (BlTextElement new
					text: (self initialsForAuthor: aModel) asRopedText;
					constraintsDo: [ :aConstraints |
						aConstraints frame horizontal alignCenter.
						aConstraints frame vertical alignCenter ]) ]
		ifFalse: [ aModel isDesignStudy ifTrue: [ element border: (BlBorder paint: Color red width: 2) ] ].
	^ element
]

{ #category : 'accessing' }
VSStudy >> authors [
	^ authors
]

{ #category : 'visualizing' }
VSStudy >> gtAuthorPaperGraphFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Design study author papers graph';
		priority: 10;
		painting: [ :aMondrian | self authorPaperGraphIn: aMondrian ];
		actionUpdateButton
]

{ #category : 'gt views' }
VSStudy >> gtAuthorsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Authors';
		priority: 3;
		items: [ self authors values asSortedCollection: [ :anAuthor :anotherAuthor | anAuthor name < anotherAuthor name ] ];
		column: 'Author' text: [ :anAuthor | anAuthor name ] weight: 2;
		column: '# of papers' text: [ :anAuthor | anAuthor papers size ] weight: 0.6;
		send: [ :anAuthor | anAuthor ];
		actionUpdateButton
]

{ #category : 'views' }
VSStudy >> gtPaperCountsByYearFor: aView [
	<gtView>
	^ aView explicit
		title: 'Papers by year';
		priority: 2.3;
		stencil: [ self paperCountsByYearChart asElement ];
		actionUpdateButton
]

{ #category : 'views' }
VSStudy >> gtPaperGroupsByYearFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Paper groups by year';
		priority: 2.1;
		items: [
			((VSPaperGroup withAll: allPapers values)
				groupedBy: [ :aPaper | aPaper record at: 'Paper Year' ]) associations
				sorted: [ :anAssociation :anotherAssociation | anAssociation key < anotherAssociation key ] ];
		column: 'Year' text: [ :anAssociation | anAssociation key ];
		column: '# of papers' text: [ :anAssociation | anAssociation value size ];
		send: [ :anAssociation | anAssociation value ];
		actionUpdateButton
]

{ #category : 'gt views' }
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
		send: [ :anAssociation | anAssociation value ];
		actionUpdateButton
]

{ #category : 'views' }
VSStudy >> gtSelectedPaperGroupsByYearFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Selected paper groups by year';
		priority: 2.2;
		items: [
			((VSPaperGroup withAll: (allPapers values select: [ :aPaper | aPaper selectedRecord notNil ]))
				groupedBy: [ :aPaper | aPaper record at: 'Paper Year' ]) associations
				sorted: [ :anAssociation :anotherAssociation | anAssociation key < anotherAssociation key ] ];
		column: 'Year' text: [ :anAssociation | anAssociation key ];
		column: '# of papers' text: [ :anAssociation | anAssociation value size ];
		send: [ :anAssociation | anAssociation value ];
		actionUpdateButton
]

{ #category : 'gt views' }
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
		send: [ :anAssociation | anAssociation value ];
		actionUpdateButton
]

{ #category : 'gt-search' }
VSStudy >> gtSpotterForPaperTitles: aSearch [
	<gtSearch>
	^ aSearch list
		title: 'Paper titles';
		priority: 10;
		items: [ self allPapers values ];
		itemsLimit: Float infinity;
		itemName: [ :aPaper | aPaper record at: 'Title' ];
		sendCategory: [ :aCategory :aStep :thisSearch |
			VSPaperGroup withAll: aCategory items contents asArray ];
		filterBySubstring
]

{ #category : 'initialization' }
VSStudy >> initialize [
	super initialize.
	self loadFromResources
]

{ #category : 'visualizing' }
VSStudy >> initialsForAuthor: anAuthor [
	"Answer initials for author names formatted as 'Surname, Given names'."
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

{ #category : 'charting' }
VSStudy >> paperCountsByYearChart [
	| years data maximumCount widthScale heightScale chart |
	years := (allPapers values collect: [ :aPaper | aPaper record at: 'Paper Year' ]) asSet
		asSortedCollection.
	data := GtPlotterDataGroup new values: (years flatCollect: [ :aYear |
		{
			{ aYear. false. self papersInYear: aYear selectedOnly: false }.
			{ aYear. true. self papersInYear: aYear selectedOnly: true } } ]).
	data := data
		groupedBy: [ :each | each first ]
		sorted: [ :a :b | a key < b key ]
		labelled: #yourself.
	data := data
		groupedBy: [ :each | each second ]
		sorted: [ :a :b | a key not ]
		colored: [ :isSelected |
			isSelected
				ifTrue: [ Color r: 244 g: 204 b: 204 range: 255 ]
				ifFalse: [ Color r: 173 g: 216 b: 230 range: 255 ] ].
	maximumCount := data inject: 0 intoValues: [ :maximum :each |
		maximum max: each third size ].
	widthScale := GtPlotterLinearScale new domainFrom: 0 to: maximumCount.
	heightScale := GtPlotterLinearScale new
		domainFrom: 0 to: data size;
		rangeFrom: 10 to: 30.
	chart := GtPlotterHorizontalBarChart new.
	chart
		withAdjacentBars;
		groupSpacing: 5;
		barLabelSpacing: 55;
		barWidthScale: widthScale;
		barWidthData: [ :each | each third size ];
		barHeightScale: heightScale;
		barHeightData: [ :eachGroup | eachGroup size ];
		amountOfTicks: 4;
		barGroupStencil: [ :aBar :aGroup :aContext |
			(aBar stencil scaleContext: aContext) asElement
				constraintsDo: [ :c |
					c horizontal matchParent.
					c vertical exact: (aBar heightScale map: (aBar heightData cull: aGroup)) ];
				when: BlClickEvent do: [ :anEvent |
					anEvent consumed: true.
					anEvent currentTarget phlow
						spawnObject: (self paperGroupFromPlotterDataEntity: aContext originalValue) ];
				geometry: (BlHistogramGeometry new beLeftToRight values: aContext mappedValue);
				background: aGroup color ];
		with: data.
	^ chart
]

{ #category : 'charting' }
VSStudy >> paperGroupFromPlotterDataEntity: aDataEntity [
	"Extract the paper group from a plotter group, removing its presentation decorators."
	^ aDataEntity decoratedEntity values first third
]

{ #category : 'querying' }
VSStudy >> papersInYear: aYear selectedOnly: aBoolean [
	| papers |
	papers := allPapers values select: [ :each |
		(each record at: 'Paper Year') = aYear asString ].
	aBoolean ifTrue: [
		papers := papers select: [ :each | each selectedRecord notNil ] ].
	^ VSPaperGroup withAll: papers
]

{ #category : 'searching' }
VSStudy >> papersMatchingTitle: aQueryString [
	| query |
	query := aQueryString asLowercase.
	^ VSPaperGroup withAll: ((allPapers values select: [ :aPaper |
		(aPaper record at: 'Title') asLowercase includesSubstring: query ])
		sorted: [ :aPaper :anotherPaper | aPaper id asNumber < anotherPaper id asNumber ])
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
