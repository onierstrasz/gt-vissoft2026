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
VSPaper >> id [
	^ record at: 'ID'
]

{ #category : 'testing' }
VSPaper >> isDesignStudy [
	^ (record at: 'Type' ifAbsent: [ nil ]) = 'Design Study'
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
