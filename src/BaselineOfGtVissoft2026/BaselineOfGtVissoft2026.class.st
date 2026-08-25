Class {
	#name : 'BaselineOfGtVissoft2026',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfGtVissoft2026',
	#package : 'BaselineOfGtVissoft2026'
}

{ #category : 'loading' }
BaselineOfGtVissoft2026 class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'gt-vissoft2026' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : 'baseline' }
BaselineOfGtVissoft2026 >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'GtVissoft2026'
		]
]
