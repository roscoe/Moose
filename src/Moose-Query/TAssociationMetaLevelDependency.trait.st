"
This trait provides a common, paradigm agnostic vocabulary to query dependencies of association entities at meta level.

For more informations: https://moosequery.ferlicot.fr/
"
Trait {
	#name : #TAssociationMetaLevelDependency,
	#category : #'Moose-Query'
}

{ #category : #meta }
TAssociationMetaLevelDependency classSide >> annotation [

	<MSEClass: #TAssociationMetaLevelDependency super: #Trait>
	<generated>
	<package: #'Moose-Query'>
	^self
]

{ #category : #accessing }
TAssociationMetaLevelDependency classSide >> dependencyFM3PropertyDescriptionIn: aMetamodel [
	"Return all the properties corresponding to the source or the target of the association"

	aMetamodel ifNil: [ ^ OrderedCollection new ].
	^ (self allDeclaredPropertiesIn: aMetamodel) select: [ :e | e isSource or: [ e isTarget ] ]
]

{ #category : #generator }
TAssociationMetaLevelDependency classSide >> generatedSlotNames [
	<generated>
	'TAssociationMetaLevelDependency class>>#generatedSlotNames'.
	^ #()
]

{ #category : #generator }
TAssociationMetaLevelDependency classSide >> generatedTraitNames [
	<generated>
	^ #()
]

{ #category : #private }
TAssociationMetaLevelDependency classSide >> privateSourceTypesIn: aMetamodel [
	"I return the classes that could be my source"

	^ (self dependencyFM3PropertyDescriptionIn: aMetamodel) select: #isSource thenCollect: [ :each | each type implementingClass ]
]

{ #category : #private }
TAssociationMetaLevelDependency classSide >> privateTargetTypesIn: aMetamodel [
	"I return the classes that could be my target"

	^ (self dependencyFM3PropertyDescriptionIn: aMetamodel) select: #isTarget thenCollect: [ :each | each type implementingClass ]
]

{ #category : #accessing }
TAssociationMetaLevelDependency classSide >> sourceTypesIn: aMetamodel [

	^ aMetamodel additionalProperty: #sourceTypes for: self ifAbsentPut: [ self privateSourceTypesIn: aMetamodel ]

]

{ #category : #accessing }
TAssociationMetaLevelDependency classSide >> targetTypesIn: aMetamodel [

	^ aMetamodel additionalProperty: #targetTypes for: self ifAbsentPut: [ self privateTargetTypesIn: aMetamodel ]

]

{ #category : #accessing }
TAssociationMetaLevelDependency >> dependencyFM3PropertyDescription [
	^ self class dependencyFM3PropertyDescriptionIn: self metamodel
]

{ #category : #accessing }
TAssociationMetaLevelDependency >> sourceTypes [
	^ self class sourceTypesIn: self metamodel
]

{ #category : #accessing }
TAssociationMetaLevelDependency >> targetTypes [
	^ self class targetTypesIn: self metamodel
]
