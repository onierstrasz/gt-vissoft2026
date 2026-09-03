Class {
	#name : 'VSFiles',
	#superclass : 'Object',
	#category : 'GtVissoft2026-Examples',
	#package : 'GtVissoft2026',
	#tag : 'Examples'
}

{ #category : 'examples' }
VSFiles >> allCSV [
	<gtExample>
	<noTest>
	^ self dataFolder / 'dataset-review-vissoft-all.csv'
]

{ #category : 'examples' }
VSFiles >> chatGptVisualizationJPG [
	<gtExample>
	<noTest>
	^ self filesFolder / 'Visualise Design Study Evolution - ChatGPT.jpg'
]

{ #category : 'examples' }
VSFiles >> chatGptVisualizationJpgWithExplanation [
	<gtExample>
	<noTest>
	^ self filesFolder / 'Visualise Design Study Evolution - ChatGPT-withExplanation.jpg'
]

{ #category : 'examples' }
VSFiles >> chatGptVisualizationPDF [
	<gtExample>
	<noTest>
	^ self filesFolder / 'Visualise Design Study Evolution - ChatGPT.pdf'
]

{ #category : 'examples' }
VSFiles >> chatGptVisualizationPrompt [
	<gtExample>
	<noTest>
	^ self filesFolder / 'Visualise Design Study Evolution - ChatGPT - prompt.jpg'
]

{ #category : 'examples' }
VSFiles >> dataFolder [
	"The dataset files."

	<gtExample>
	<noTest>
	^ self repoFolder / 'data'
]

{ #category : 'examples' }
VSFiles >> fileOutsFolder [
	"FileOuts used by VSLoadSnapshot."

	<gtExample>
	<noTest>
	^ self repoFolder / 'fileOuts'
]

{ #category : 'examples' }
VSFiles >> filesFolder [
	"Other files of interest."

	<gtExample>
	<noTest>
	^ self repoFolder / 'files'
]

{ #category : 'examples' }
VSFiles >> geminiVisualizationPDF [
	<gtExample>
	<noTest>
	^ self filesFolder / 'Software Visualization Paper Evolution Analysis - Google Gemini.pdf'
]

{ #category : 'examples' }
VSFiles >> repoFolder [
	<gtExample>
	<noTest>
	^ FileLocator gtResource / 'onierstrasz' / 'gt-vissoft2026'
]

{ #category : 'examples' }
VSFiles >> selectedCSV [
	<gtExample>
	<noTest>
	^ self dataFolder / 'dataset-review-vissoft-selected.csv'
]
