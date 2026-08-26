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

{ #category : 'views' }
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
		send: [ :anAssociation | anAssociation value ]
]

{ #category : 'initialization' }
VSAuthor >> initialize [
	super initialize.
	papers := OrderedCollection new
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
