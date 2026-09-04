Class {
	#name : 'VISSOFT2026Slideshow',
	#superclass : 'PrioritySlideshow',
	#category : 'GtVissoft2026-Slideshows',
	#package : 'GtVissoft2026',
	#tag : 'Slideshows'
}

{ #category : 'slides' }
VISSOFT2026Slideshow >> buildingAModel: aSlide [
	<gtSlide>
	<text:
'# Building a domain model

We have the CSV data. We have documented experience building a domain model from raw data. We also have documented experience (design patterns) in constructing cheap, composable views on top of the model.

We feed this documentation to the LLM and let it build the model.
'>
<demo:
'- The slide starts with an empty package.
- Show the tools and the documentation.
- Discuss the prompt.
- Run the prompt and explore the actions.
- Show the created classes.
- Run the tests.
- Explore the dataset instance and see how we can navigate.
- In case the result is partially broken, file in the saved version.
- Show how the views are cheap to implement and easy to navigate.

'>
		^ aSlide lepiterPage
		setPriority;
		pageNamed: 'Building a domain model from the raw CSV data' from: 'VISSOFT 2026';
		yourself
]

{ #category : 'page' }
VISSOFT2026Slideshow >> chaGptVisualizationPage [
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
VISSOFT2026Slideshow >> generatingAGraphView: aSlide [
	<gtSlide>
	<text:
'TODO # Generating a graph view
'>
<demo:
''>
		^ aSlide lepiterPage
		setPriority;
		pageNamed: 'Generating a Mondrian graph view' from: 'VISSOFT 2026';
		yourself
]

{ #category : 'slides' }
VISSOFT2026Slideshow >> howToTrustAnLLM: aSlide [
	<gtSlide>
	<text: '# How to build trust in an LLM

— Model the domain — don''t just work with raw data.
— Extend the model with composable views — views should be cheap to create, and enable navigation through the model
— Model the Chat — expose the LLM interactions using composable views
— Expose views to the LLM  — enable the LLM to see and interpret the generated views.'>
	^ aSlide paragraph
		setPriority;
		subtitleWithFormat: (self asSubtitle: 'How to build trust in an LLM');
		paragraphWithFormat: (self
				asText: '
— Model the domain
— Extend the model with cheap, composable views
— Model the Chat
— Expose views to the LLM
')
]

{ #category : 'as yet unclassified' }
VISSOFT2026Slideshow >> picturesDirectoryPath [
	"Default path may be overridden"

	^ Path * 'onierstrasz' / 'gt-vissoft2026' / 'images'
]

{ #category : 'acccessing' }
VISSOFT2026Slideshow >> slidePriorities [
	<gtExample>
	<return: #Array>
	^ #(
		title:
		thenAndNow:
		theTroubleWithAI:
		howToTrustAnLLM:
		buildingAModel:
		generatingAGraphView:
		summary:
		)	
]

{ #category : 'slides' }
VISSOFT2026Slideshow >> summary: aSlide [
	<gtSlide>
	<text:
'TODO # Conclusions 
TO DO

End with a bullet list or a view of chat?
Ask a Chat to summarize?

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
VISSOFT2026Slideshow >> template: aSlide [
	<gtSlide>
	<text:
'# TEMPLATE'>
<demo:
''>
	^ aSlide paragraph
		setPriority;
		subtitleWithFormat: (self asSubtitle: 'Template');
		paragraphWithFormat: (self
				asText: 
'
')
]

{ #category : 'slides' }
VISSOFT2026Slideshow >> theTroubleWithAI: aSlide [
	<gtSlide>
	<text: 'TODO: Discuss the ChatGPT line graph issues # The Trouble with AI

(Say something about "AI" vs "LLM")

AI builds a visualization. Explains in text what it did.
Do we understand it? Do we trust it?
Show a visualization built by a standard tool.
TO DO try with chatGPT or Gemini

We can show the ChatGPT prompt and visualization.

Issues
How did it do the work (in detail)?
Does the visualization truly reflect the data?
What is the underlying model?
How do we interpret the result? What can we do with it?'>
	<demo: ''>
	^ aSlide textAndElement
		elementWeight: 0.60;
		setPriority;
		newTextWithFormat: (self
				asText: 'ChatGPT (-5.6 Luna) can easily visualize the data:

... but ') , (self asText: 'do we trust it?') italic;
		element: [ GtFilePictureLiveSlide new
				fileReference: (GtResourcesUtility
						resourceAtPath: self picturesDirectoryPath
								/ 'Visualise Design Study Evolution - ChatGPT-prompt+result.png') ]
]

{ #category : 'slides' }
VISSOFT2026Slideshow >> thenAndNow: aSlide [
	<gtSlide>
	<text:
'TODO: summarize past and issues today # Then and now

Ten years ago ... what has changed?
Do AIs / LLMs solve the visualization problem?
Main issues: trust, interpretation 


'>
<demo:
''>
	^ aSlide paragraph
		setPriority;
		subtitleWithFormat: (self asSubtitle: 'Then and now');
		paragraphWithFormat: (self
				asText: 
'
')
]

{ #category : 'slides' }
VISSOFT2026Slideshow >> title: aSlide [
	<gtSlide>
<text:
'TODO: write up intro text # Towards Actionable Visualization: Ten Years Later
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
