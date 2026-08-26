"
Examples for topic relationships in a visual software study.
"
Class {
	#name : 'VSTopicExamples',
	#superclass : 'Object',
	#category : 'GtVissoft2026-Examples',
	#package : 'GtVissoft2026',
	#tag : 'Examples'
}

{ #category : 'examples' }
VSTopicExamples >> topicPrintsItsName [
	<gtExample>
	| aStudy aTopic |
	aStudy := VSStudy new.
	aTopic := aStudy topicNamed: 'Elements'.
	self assert: aTopic printString equals: aTopic name.
	^ aTopic
]
