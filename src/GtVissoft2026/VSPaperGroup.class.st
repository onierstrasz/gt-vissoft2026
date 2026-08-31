"
A moldable collection wrapper for papers in a visualization study.
"
Class {
	#name : 'VSPaperGroup',
	#superclass : 'Object',
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#category : 'GtVissoft2026-Model',
	#package : 'GtVissoft2026',
	#tag : 'Model'
}

{ #category : 'graphing' }
VSPaperGroup >> authorPaperNodeFor: aModel highlightedPapers: highlightedPapers [
	| isAuthor size tooltipText element isHighlightedPaper |
	isAuthor := aModel isKindOf: VSAuthor.
	isHighlightedPaper := (aModel isKindOf: VSPaper)
		and: [ highlightedPapers includes: aModel ].
	size := isAuthor
		ifTrue: [ 25 + (aModel papers size * 8) ]
		ifFalse: [ 25 + (aModel authors size * 8) ].
	tooltipText := isAuthor
		ifTrue: [ aModel name ]
		ifFalse: [ aModel record at: 'Title' ].
	element := BlElement new
		background: (isAuthor
			ifTrue: [ Color lightBlue ]
			ifFalse: [ isHighlightedPaper ifTrue: [ Color paleRed darker ] ifFalse: [ Color paleRed ] ]);
		geometry: (isAuthor ifTrue: [ BlRectangleGeometry new ] ifFalse: [ BlEllipseGeometry new ]);
		size: size @ size;
		addAptitude: (BrGlamorousWithLabelTooltipAptitude text: tooltipText);
		when: BlClickEvent do: [ :anEvent | anEvent currentTarget phlow spawnObject: aModel ];
		yourself.
	(aModel isKindOf: VSPaper) ifTrue: [
		aModel isDesignStudy ifTrue: [ element border: (BlBorder paint: Color red width: 2) ] ].
	isAuthor ifTrue: [
		element
			layout: BlFrameLayout new;
			addChild: (BlTextElement new
				text: (aModel name) asRopedText;
				constraintsDo: [ :aConstraints |
					aConstraints frame horizontal alignCenter.
					aConstraints frame vertical alignCenter ]) ].
	^ element
]

{ #category : 'gt-views' }
VSPaperGroup >> gtPaperGroupsByYearFor: aView [
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
		actionUpdateButton
]

{ #category : 'gt-views' }
VSPaperGroup >> gtPapersFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Papers';
		priority: 1;
		items: [ self items
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

{ #category : 'gt-views' }
VSPaperGroup >> gtReachableAuthorPaperGraphFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Reachable author papers graph';
		priority: 2;
		painting: [ :aMondrian | self reachableAuthorPaperGraphIn: aMondrian ];
		actionUpdateButton
]

{ #category : 'graphing' }
VSPaperGroup >> reachableAuthorPaperGraphIn: aMondrian [
	"Render all components reachable from my papers, emphasizing the original papers."
	| component papers authors highlightedPapers |
	component := self reachablePaperAuthorComponent.
	papers := component key.
	authors := component value.
	highlightedPapers := self items asIdentitySet.
	self
		renderAuthorPaperGraphIn: aMondrian
		papers: papers
		authors: authors
		nodeStencil: [ :aModel | self authorPaperNodeFor: aModel highlightedPapers: highlightedPapers ]
]

{ #category : 'graphing' }
VSPaperGroup >> reachablePaperAuthorComponent [
	"Answer the union of the paper-author connected components of my papers."
	| papers authors pendingPapers aPaper |
	papers := self items asIdentitySet.
	authors := IdentitySet new.
	pendingPapers := OrderedCollection new
		addAll: self items;
		yourself.
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

{ #category : 'graphing' }
VSPaperGroup >> renderAuthorPaperGraphIn: aMondrian papers: papers authors: authors nodeStencil: aStencil [
	"Render the common bipartite author-paper topology with caller-supplied node presentation."
	aMondrian nodes
		stencil: aStencil;
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
