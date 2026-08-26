Class {
	#name : 'VSStudy',
	#superclass : 'Object',
	#instVars : [
		'allPapers',
		'selectedPapers'
	],
	#category : 'GtVissoft2026-Model',
	#package : 'GtVissoft2026',
	#tag : 'Model'
}

{ #category : 'accessing' }
VSStudy >> allPapers [
	^ allPapers
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
	allPaperRecords do: [ :each |
		| paper |
		paper := VSPaper new
			study: self;
			record: each;
			yourself.
		paper isDesignStudy ifTrue: [
			paper selectedRecord: (selectedPapersById at: paper id ifAbsent: [ nil ]) ].
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
