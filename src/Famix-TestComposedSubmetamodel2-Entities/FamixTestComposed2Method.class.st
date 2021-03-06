Class {
	#name : #FamixTestComposed2Method,
	#superclass : #FamixTestComposed2NamedEntity,
	#traits : 'FamixTMethod',
	#classTraits : 'FamixTMethod classTrait',
	#category : #'Famix-TestComposedSubmetamodel2-Entities-Entities'
}

{ #category : #meta }
FamixTestComposed2Method class >> annotation [

	<MSEClass: #Method super: #FamixTestComposed2NamedEntity>
	<package: #'Famix-TestComposedSubmetamodel2-Entities'>
	<generated>
	^self
]

{ #category : #generator }
FamixTestComposed2Method class >> generatedSlotNames [
	<generated>
	'FamixTestComposed2Method class>>#generatedSlotNames'.
	^ #()
]

{ #category : #generator }
FamixTestComposed2Method class >> generatedTraitNames [
	<generated>
	^ #(FamixTMethod)
]

{ #category : #meta }
FamixTestComposed2Method class >> requirements [

	<generated>
	^ { FamixTestComposed2Class }
]

{ #category : #accessing }
FamixTestComposed2Method >> belongsTo [

	<generated>
	^ self parentType

]

{ #category : #accessing }
FamixTestComposed2Method >> belongsTo: anObject [

	<generated>
	self parentType: anObject

]
