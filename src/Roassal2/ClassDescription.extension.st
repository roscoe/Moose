Extension { #name : #ClassDescription }

{ #category : #'*Roassal2-Core' }
ClassDescription >> ageInDays [
	"Return the number of days the class exists"
	self numberOfMethods isZero ifTrue: [ ^ 0 ].
	^ (TRPlatform current dateAndTimeClass now - self oldestMethod date) asDays
]

{ #category : #'*Roassal2-Core' }
ClassDescription >> ageInDaysRounded [
	"Return the number of days the class exists"

	^ self ageInDays rounded
]

{ #category : #'*Roassal2-Core' }
ClassDescription >> commonSuperclassWith: aClass [
	"
	Metaclass commonSuperclassWith: Class
	Metaclass commonSuperclassWith: Point
	Metaclass commonSuperclassWith: Metaclass
	Object commonSuperclassWith: RTPopup class
	"
	| t1 t2 |
	self == aClass ifTrue: [ ^ self ].
	t1 := self withAllSuperclasses reverse.
	t2 := aClass withAllSuperclasses reverse.
	1 to: (t1 size min: t2 size) do: [ :i |
		(t1 at: i) ~~ (t2 at: i)
			ifTrue: [ ^ t1 at: (i - 1) ] ].
	
	^ t1 size < t2 size 
		ifTrue: [ t1 last ]
		ifFalse: [ t2 last ]
]

{ #category : #'*Roassal2-Core' }
ClassDescription >> computeOldestMethod [
	| d m |
	d := TRPlatform current dateAndTimeClass now.
	m := nil.
	self methods, self class methods do: [ :cm | cm date < d ifTrue: [ m := cm. d := cm date ] ].
	^ m
]

{ #category : #'*Roassal2-Core' }
ClassDescription >> computeYoungestMethod [
	| d m ms aMethod |
	ms := self methods, self class methods.
	aMethod := ms anyOne.
	d := aMethod date.
	m := aMethod.
	
	ms do: [ :cm | cm date > d ifTrue: [ m := cm. d := cm date ] ].
	^ m
]

{ #category : #'*Roassal2-Core' }
ClassDescription >> gotMethodOnDay: dayAsNumber [
	"Return true if a method has been defined on dayAsNumber.
	Always returns true for dayAsNumber = 0"
	| age |
	age := self ageInDaysRounded.
	^ self rtmethods anySatisfy: [ :cm | (age - cm ageInDaysRounded) = dayAsNumber ]

]

{ #category : #'*Roassal2-Core' }
ClassDescription >> hasAnyMethodProducedAfterDay: aNumberOfDays [
	^ self methods anySatisfy: [ :cm | cm livingInDays = aNumberOfDays ]

]

{ #category : #'*Roassal2-Core' }
ClassDescription >> isReferencedBy: aClass [ 
	"
	Return true or false on whether the class receiver is referenced by aClass
	
	Halt isReferencedBy: Object 
	"
	^ aClass dependentClasses includes: self 
]

{ #category : #'*Roassal2-Core' }
ClassDescription >> livingInDays [
	self numberOfMethods isZero ifTrue: [ ^ 0 ].
	^ (TRPlatform current dateAndTimeClass now - self oldestMethod date) asDays
]

{ #category : #'*Roassal2-Core' }
ClassDescription >> numberOfSubclasses [
	^ self allSubclasses size
]

{ #category : #'*Roassal2-Core' }
ClassDescription >> oldestMethod [
	"We pick a method, and put the cache in it"
	| aMethod |
	aMethod := (self methods, self class methods) first.
	^ (aMethod properties includesKey: #oldestMethod)
		ifTrue: [ aMethod properties at: #oldestMethod ]
		ifFalse: [ | m |
			m := self computeOldestMethod.
			aMethod properties at: #oldestMethod put: m ]

]

{ #category : #'*Roassal2-Core' }
ClassDescription >> rtmethods [
	"This method is useful to have examples working on VisualWorks"
	^ self methods
]

{ #category : #'*Roassal2-Core' }
ClassDescription >> youngestMethod [
	"We pick a method, and put the cache in it"
	| aMethod |
	aMethod := (self methods, self class methods) first.
	^ (aMethod properties includesKey: #youngestMethod)
		ifTrue: [ aMethod properties at: #youngestMethod ]
		ifFalse: [ | m |
			m := self computeYoungestMethod.
			aMethod properties at: #youngestMethod put: m ]

]
