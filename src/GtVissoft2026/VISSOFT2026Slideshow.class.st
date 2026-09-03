Class {
	#name : 'VISSOFT2026Slideshow',
	#superclass : 'PrioritySlideshow',
	#category : 'GtVissoft2026-Slideshows',
	#package : 'GtVissoft2026',
	#tag : 'Slideshows'
}

{ #category : 'slides' }
VISSOFT2026Slideshow >> approaches: aSlide [
	<gtSlide>
	<text:
'TODO # Approaches
Build a navigable model first.
Have cheap, composable visualization engine.
Model and visualize the LLM interactions and actions themselves. 
Enable the LLM to see and interpret the generated views.'>
<demo:
''>
	^ aSlide paragraph
		setPriority;
		subtitleWithFormat: (self asSubtitle: 'Temaplte');
		paragraphWithFormat: (self
				asText: 
'
')
]

{ #category : 'slides' }
VISSOFT2026Slideshow >> caseStudy: aSlide [
	<gtSlide>
	<text:
'TODO # Case study — the 2016 dataset.
Build a model, proving detailed instructions (no magic). 
Add basic visualizations (views). 
Views are simple, cheap, composable and navigable.
Views are just extensions to the model.
TO DO — can we demo the model creation?'>
<demo:
''>
	^ aSlide paragraph
		setPriority;
		subtitleWithFormat: (self asSubtitle: 'Temaplte');
		paragraphWithFormat: (self
				asText: 
'
')
]

{ #category : 'slides' }
VISSOFT2026Slideshow >> codeChanges: aSlide [
	<gtSlide>
	<text:
'TODO # Code Changes
Code changes can also be visualized and explored.
TO DO — need a code change scenario. Refactoring?'>
<demo:
''>
	^ aSlide paragraph
		setPriority;
		subtitleWithFormat: (self asSubtitle: 'Temaplte');
		paragraphWithFormat: (self
				asText: 
'
')
]

{ #category : 'page' }
VISSOFT2026Slideshow >> dynamicLePage [
	<lePage>
	<gtExample>
	<noTest>
	^ (LePage named: 'A dynamic Lepiter page')
		addSnippet: (LeTextSnippet new
				string: 'This page is dynamically created and stored in a transient Lepiter database.';
				yourself);
		addSnippet: (LeTextSnippet new
				string: 'A link to [[Another dynamic page]].';
				yourself);
		addSnippet: (LePharoSnippet new
				code: '''hello''';
				yourself);
		yourself
]

{ #category : 'slides' }
VISSOFT2026Slideshow >> generatingVisualizations: aSlide [
	<gtSlide>
	<text:
'TODO # Generating visualizations
We build a Mondrian graph. Instead of being just a picture, it is navigable and is just an extension to the model.'>
<demo:
''>
	^ aSlide paragraph
		setPriority;
		subtitleWithFormat: (self asSubtitle: 'Temaplte');
		paragraphWithFormat: (self
				asText: 
'
')
]

{ #category : 'slides' }
VISSOFT2026Slideshow >> interpretingResults: aSlide [
	<gtSlide>
	<text:
'TODO # LLM interpreting the results
The LLM can also leverage the views.
TO DO — need a good demo. 
Ask it to assess the goal from the abstract. 
'>
<demo:
''>
	^ aSlide paragraph
		setPriority;
		subtitleWithFormat: (self asSubtitle: 'Temaplte');
		paragraphWithFormat: (self
				asText: 
'
')
]

{ #category : 'slides' }
VISSOFT2026Slideshow >> otherVisualizations: aSlide [
	<gtSlide>
	<text:
'TODO # Other visualizations?
Bar graph?
Do we have a decent bar graph example?
Line graph? Tree map?'>
<demo:
''>
	^ aSlide paragraph
		setPriority;
		subtitleWithFormat: (self asSubtitle: 'Temaplte');
		paragraphWithFormat: (self
				asText: 
'
')
]

{ #category : 'slides' }
VISSOFT2026Slideshow >> reifyingChats: aSlide [
	<gtSlide>
	<text:
'TODO # Reifying the chat
The generation process is itself modeled, visualized and navigable.'>
<demo:
''>
	^ aSlide paragraph
		setPriority;
		subtitleWithFormat: (self asSubtitle: 'Temaplte');
		paragraphWithFormat: (self
				asText: 
'
')
]

{ #category : 'acccessing' }
VISSOFT2026Slideshow >> slidePriorities [
	<gtExample>
	<return: #Array>
	^ #(
		title:
		thenAndNow:
		whereAreWe:
		approaches:
		caseStudy:
		reifyingChats:
		codeChanges:
		generatingVisualizations:
		otherVisualizations:
		interpretingResults:
		summary:
		)	
]

{ #category : 'slides' }
VISSOFT2026Slideshow >> summary: aSlide [
	<gtSlide>
	<text:
'TODO # Conclusions 
TO DO'>
<demo:
''>
	^ aSlide paragraph
		setPriority;
		subtitleWithFormat: (self asSubtitle: 'Temaplte');
		paragraphWithFormat: (self
				asText: 
'
')
]

{ #category : 'slides' }
VISSOFT2026Slideshow >> template: aSlide [
	"<gtSlide>"
	<text:
'# TEMPLATE'>
<demo:
''>
	^ aSlide paragraph
		setPriority;
		subtitleWithFormat: (self asSubtitle: 'Temaplte');
		paragraphWithFormat: (self
				asText: 
'
')
]

{ #category : 'slides' }
VISSOFT2026Slideshow >> thenAndNow: aSlide [
	<gtSlide>
	<text:
'TODO # Then and now

Ten years ago ... what has changed?
Do AIs / LLMs solve the visualization problem?
Main issues: trust, interpretation 

'>
<demo:
''>
	^ aSlide paragraph
		setPriority;
		subtitleWithFormat: (self asSubtitle: 'Temaplte');
		paragraphWithFormat: (self
				asText: 
'
')
]

{ #category : 'slides' }
VISSOFT2026Slideshow >> title: aSlide [
	<gtSlide>
<text:
'TODO # Towards Actionable Visualization: Ten Years Later

What Generative AI Changes and What It Cannot.
'>
	^ (aSlide titleWithFooters)
		setPriority;
		titleWithFormat: (self asTitle: 'Towards Actionable Visualization:');
		subtitleWithFormat: (self asSubtitle: 'Ten Years Later, What Generative AI Changes and What It Cannot');
		newFooterWithFormat: (self asBigText: 'Leonel Merino');
		newFooterWithFormat: (self asBigText: 'Mohammad Ghafari');
		newFooterWithFormat: (self asBigText: 'Oscar Nierstrasz') underline
]

{ #category : 'slides' }
VISSOFT2026Slideshow >> whereAreWe: aSlide [
	<gtSlide>
	<text:
'TODO # Where are we?
AI builds a visualization. Explains in text what it did.
Do we understand it? Do we trust it?
Show a visualization built by a standard tool.
TO DO try with chatGPT or Gemini

Issues
How did it do the work (in detail)?
Does the visualization truly reflect the data?
What is the underlying model?
How do we interpret the result? What can we do with it?'>
<demo:
''>
	^ aSlide paragraph
		setPriority;
		subtitleWithFormat: (self asSubtitle: 'Temaplte');
		paragraphWithFormat: (self
				asText: 
'
')
]
