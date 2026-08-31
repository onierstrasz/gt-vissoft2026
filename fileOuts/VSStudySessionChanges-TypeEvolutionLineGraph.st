"File-out of code added during the VSStudy session"Object subclass: #VSPaperTypeLineChart	instanceVariableNames: 'study'	classVariableNames: ''	package: 'GtVissoft2026'VSStudy >> #gtPaperGroupsByTypeFor:gtPaperGroupsByTypeFor: aView
	<gtView>
	^ aView columnedList
		title: 'Paper groups by type';
		priority: 2.01;
		items: [
			((VSPaperGroup withAll: allPapers values)
				groupedBy: [ :aPaper | aPaper record at: 'Type' ]) associations
				sorted: [ :anAssociation :anotherAssociation | anAssociation key < anotherAssociation key ] ];
		column: 'Type' text: [ :anAssociation | anAssociation key ];
		column: '# of papers' text: [ :anAssociation | anAssociation value size ];
		send: [ :anAssociation | anAssociation value ];
		actionUpdateButton!VSStudy >> #paperTypeCountsByYearChartpaperTypeCountsByYearChart
	| years types colors data chart |
	years := (allPapers values collect: [ :aPaper | aPaper record at: 'Paper Year' ]) asSet
		asSortedCollection.
	types := ((allPapers values collect: [ :aPaper | aPaper record at: 'Type' ]) asSet
		remove: 'N/A';
		asSortedCollection).
	colors := {
		'Commentary' -> Color red.
		'Design Study' -> Color blue.
		'Evaluation' -> Color green.
		'Formalism' -> Color orange.
		'System' -> Color purple.
		'Taxonomy' -> Color brown.
		'Technique' -> Color magenta } asDictionary.
	data := GtPlotterDataGroup new values: (years flatCollect: [ :aYear |
		types collect: [ :aType |
			{ aYear asNumber. aType. (allPapers values count: [ :aPaper |
				(aPaper record at: 'Paper Year') = aYear and: [ (aPaper record at: 'Type') = aType ] ]) } ] ]).
	data := data
		groupedBy: [ :each | each second ]
		labelled: [ :aType | aType ]
		colored: [ :aType | colors at: aType ].
	chart := VSPaperTypeLineChart new
		study: self;
		with: data;
		valueX: [ :each | each first ];
		scaleX: GtPlotterLinearScale new;
		titleX: 'Year';
		ticksX: years size;
		labelFormatX: [ :aYear | aYear asString asRopedText foreground: Color darkGray ];
		valueY: [ :each | each third ];
		scaleY: GtPlotterLinearScale new;
		titleY: 'Number of papers';
		ticksY: 10.
	^ chart!VSStudy >> #gtPaperTypeCountsByYearFor:gtPaperTypeCountsByYearFor: aView
	<gtView>
	^ aView explicit
		title: 'Paper types by year';
		priority: 2.31;
		stencil: [ self paperTypeCountsByYearChart asElement ];
		actionUpdateButton!VSStudy >> #papersOfType:papersOfType: aType
	^ VSPaperGroup withAll: (allPapers values select: [ :aPaper |
		(aPaper record at: 'Type') = aType ])!VSPaperGroup >> #gtPaperGroupsByYearFor:gtPaperGroupsByYearFor: aView
	<gtView>
	^ aView columnedList
		title: 'Paper groups by year';
		priority: 1.1;
		items: [
			(self groupedBy: [ :aPaper | aPaper record at: 'Paper Year' ]) associations
				sorted: [ :anAssociation :anotherAssociation | anAssociation key < anotherAssociation key ] ];
		column: 'Year' text: [ :anAssociation | anAssociation key ];
		column: '# of papers' text: [ :anAssociation | anAssociation value size ];
		send: [ :anAssociation | anAssociation value ];
		actionUpdateButton!VSPaperTypeLineChart >> #study:study: aVSStudy
	study := aVSStudy!VSPaperTypeLineChart >> #tooltipStrategyAt:tooltipStrategyAt: aGlobalPoint
	| anchorBounds |
	anchorBounds := BrAnchoredDelegateAnchorBounds block: [ :aReferenceElement |
		| localPoint |
		localPoint := aReferenceElement globalPointToLocal: aGlobalPoint.
		BlBounds origin: localPoint corner: localPoint ].
	^ BrAnchoredCompositeStrategy builder
		single: [ :aBuilder |
			aBuilder
				anchorBounds: anchorBounds;
				referencePoint: BrAnchoredBottomCenterReferencePoint;
				availableBounds: BrAnchoredBottomCenterAvailableBounds;
				scaleFactor: BrAnchoredGlobalScaleFactor ];
		single: [ :aBuilder |
			aBuilder
				anchorBounds: anchorBounds;
				referencePoint: BrAnchoredTopCenterReferencePoint;
				availableBounds: BrAnchoredTopCenterAvailableBounds;
				scaleFactor: BrAnchoredGlobalScaleFactor ];
		build!VSPaperTypeLineChart >> #newContentLineElementFor:newContentLineElementFor: aGroup
	| line tooltip |
	line := BlElement new
		geometry: (BlNormalizedPolylineGeometry vertices: (self newContentLineVerticesFor: aGroup));
		border: (BlBorder paint: aGroup color width: 3);
		outskirts: BlOutskirts centered;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
	tooltip := BrGlamorousWithLabelTooltipAptitude text: aGroup label.
	line
		addAptitude: tooltip;
		when: BlMouseEnterEvent do: [ :anEvent |
			tooltip strategy: (self tooltipStrategyAt: anEvent position) ];
		when: BlMouseMoveEvent do: [ :anEvent |
			tooltip strategy: (self tooltipStrategyAt: anEvent position) ];
		when: BlClickEvent do: [ :anEvent |
			anEvent consumed: true.
			anEvent currentTarget phlow spawnObject: (study papersOfType: aGroup label) ].
	^ line!VSStudyExamples >> #paperGroupsByTypepaperGroupsByType
	<gtExample>
	| groups |
	groups := (VSPaperGroup withAll: self study allPapers values)
		groupedBy: [ :aPaper | aPaper record at: 'Type' ].
	self assert: groups isNotEmpty.
	self assert: (groups values allSatisfy: [ :each | each class = VSPaperGroup ]).
	self assert: (groups values inject: 0 into: [ :sum :each | sum + each size ]) equals: self study allPapers size.
	^ groups!VSStudyExamples >> #paperTypeCountsByYearChartpaperTypeCountsByYearChart
	<gtExample>
	<return: #VSPaperTypeLineChart>
	| chart |
	chart := self study paperTypeCountsByYearChart.
	self assert: chart class equals: VSPaperTypeLineChart.
	^ chart!VSStudyExamples >> #papersOfTypepapersOfType
	<gtExample>
	| papers |
	papers := self study papersOfType: 'Design Study'.
	self assert: papers class equals: VSPaperGroup.
	self assert: papers size equals: 65.
	self assert: (papers allSatisfy: [ :each | (each record at: 'Type') = 'Design Study' ]).
	^ papers!VSStudyExamples >> #paperGroupGroupsPapersByYearpaperGroupGroupsPapersByYear
	<gtExample>
	| paperGroup groups |
	paperGroup := VSPaperGroup withAll: self study allPapers values.
	groups := paperGroup groupedBy: [ :aPaper | aPaper record at: 'Paper Year' ].
	self assert: (groups at: '2015') class equals: VSPaperGroup.
	self assert: (groups at: '2015') size equals: 31.
	self assert: (groups values inject: 0 into: [ :sum :each | sum + each size ]) equals: paperGroup size.
	^ groups!VSStudyExamples >> #paperTypeTooltipStrategypaperTypeTooltipStrategy
	<gtExample>
	| strategy |
	strategy := self study paperTypeCountsByYearChart tooltipStrategyAt: 100 @ 200.
	self assert: strategy class equals: BrAnchoredCompositeStrategy.
	^ strategy!