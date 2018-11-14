Extension { #name : #FamixTestComposed1CustomEntity4 }

{ #category : #'*Famix-TestComposedMetamodel-Entities-*Famix-TestComposedSubmetamodel1-Entities' }
FamixTestComposed1CustomEntity4 >> c24s [

	<generated>
	<MSEProperty: #c24s type: #Object>
	^ self privateState attributeAt: #c24s ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #c14s ]
]

{ #category : #'*Famix-TestComposedMetamodel-Entities-*Famix-TestComposedSubmetamodel1-Entities' }
FamixTestComposed1CustomEntity4 >> c24s: anObject [

	<generated>
	self c24s value: anObject
]

{ #category : #'*Famix-TestComposedMetamodel-Entities-*Famix-TestComposedSubmetamodel1-Entities' }
FamixTestComposed1CustomEntity4 >> customEntities4 [

	<generated>
	<MSEProperty: #customEntities4 type: #Object>
	^ self privateState attributeAt: #customEntities4 ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #customEntities4 ]
]

{ #category : #'*Famix-TestComposedMetamodel-Entities-*Famix-TestComposedSubmetamodel1-Entities' }
FamixTestComposed1CustomEntity4 >> customEntities4: anObject [

	<generated>
	self customEntities4 value: anObject
]