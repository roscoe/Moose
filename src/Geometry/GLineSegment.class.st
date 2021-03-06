"
I am a copy of RTLineSegment from Roassal.
"
Class {
	#name : #GLineSegment,
	#superclass : #Object,
	#instVars : [
		'from',
		'to'
	],
	#category : 'Geometry'
}

{ #category : #'instance-creation' }
GLineSegment class >> from: fromPoint to: toPoint [
	^ self new
		from: fromPoint to: toPoint;
		yourself
]

{ #category : #comparing }
GLineSegment >> = anotherSegment [
	"Answer true if the receiver's species, from and to matches anotherSegment."

	^ self species = anotherSegment species
		ifTrue: [ ^ from = anotherSegment from and: [ to = anotherSegment to ] ]
		ifFalse: [ ^ false ]
]

{ #category : #'line forms' }
GLineSegment >> a [
	"value from normal form (ax + by + c) of line on which line segment lies on"

	^ to y - from y
]

{ #category : #geometry }
GLineSegment >> angleInDeg [
	^ self vector degrees
]

{ #category : #geometry }
GLineSegment >> angleInRad [
	^ self angleInDeg degreesToRadians
]

{ #category : #'line forms' }
GLineSegment >> b [
	"value from normal form (ax + by + c) of line on which line segment lies on"

	^ from x - to x
]

{ #category : #accessing }
GLineSegment >> bottom [
	^ from y < to y
		ifTrue: [ from ]
		ifFalse: [ to ]
]

{ #category : #'line forms' }
GLineSegment >> c [
	"value from normal form (ax + by + c) of line on which line segment lies on"

	^ (self a * from x + (self b * from y)) negated
]

{ #category : #geometry }
GLineSegment >> cotan [
	| vector |
	vector := self vector.
	vector y isZero
		ifTrue: [ ^ nil ].
	^ vector x / vector y
]

{ #category : #comparing }
GLineSegment >> finiteLinesIntersectFrom: current to: next [
	| uat ubt uy z1 z2 z3 z4 ua ub |
	z1 := from.
	z2 := to.
	z3 := current.
	z4 := next.
	uat := ((z4 x - z3 x)*(z1 y - z3 y))-((z4 y - z3 y)*(z1 x - z3 x)).
	ubt := ((z2 x - z1 x)*(z1 y - z3 y))-((z2 y - z1 y)*(z1 x - z3 x)).
	uy := ((z4 y - z3 y)*(z2 x - z1 x))-((z4 x - z3 x)*(z2 y - z1 y)).
	uy isZero not ifTrue: [ 
		ua := uat / uy.
		ub := ubt / uy.
		((ua between: 0 and: 1) and: [ ub between: 0 and: 1 ]) 
			ifTrue: [ ^ (z1 x + (ua *(z2 x - z1 x)))@(z1 y + (ua *(z2 y - z2 y)))  ]
			ifFalse: [ ^ nil ]
		 ] 
	ifFalse: [ 
		(uat isZero or: [ ubt isZero ]) ifTrue: [ 
			"Parallel, coincident lines. Check if overlap"
			(Array with: z1 x with: z2 x with: z4 x) sort second = z4 x 
				ifTrue: [ ^ z4 ].
			(Array with: z1 x with: z2 x with: z3 x) sort second = z3 x 
				ifTrue: [ ^ z3 ].
			(Array with: z3 x with: z4 x with: z2 x) sort second = z2 x 
				ifTrue: [ ^ z2 ].
			^ nil. ]
		ifFalse: [ ^ nil ].
	 ]
	
]

{ #category : #accessing }
GLineSegment >> from [
	^ from
]

{ #category : #accessing }
GLineSegment >> from: fromPoint [
	from := fromPoint
]

{ #category : #accessing }
GLineSegment >> from: fromPoint to: toPoint [
	from := fromPoint.
	to := toPoint.  
]

{ #category : #comparing }
GLineSegment >> hash [
	"Hash is reimplemented because = is implemented."

	^ from hash bitXor: to hash
]

{ #category : #initialization }
GLineSegment >> initialize [
	super initialize.
	from := 0 @ 0.
	to := 0 @ 0
]

{ #category : #'as yet unclassified' }
GLineSegment >> intersect: otherShape [
	^ otherShape intersectLineSegment: self
]

{ #category : #'as yet unclassified' }
GLineSegment >> intersectCircle: aCircle [
	| e l d det t1 t2 a b c result root |
	e := from - aCircle center.
	l := to - aCircle center.
	d := l - e.
	a := d x squared + d y squared.
	b := 2 * e x * d x + (2 * e y * d y).
	c := e x squared + e y squared - aCircle radius squared.
	det := b squared - (4 * a * c).
	det < 0
		ifTrue: [ ^ #() ].
	a = 0
		ifTrue: [ ^ #() ].
	root := det sqrt.
	t1 := (b negated + root) / (2 * a).
	t2 := (b negated - root) / (2 * a).
	result := (Set with: t1 with: t2) collect: [ :each | e + (each * d) + aCircle center ].
	^ (result select: [ :each | each onLineFrom: self from to: self to ]) asArray
]

{ #category : #'as yet unclassified' }
GLineSegment >> intersectCircleArc: aCircleArc [
	| intersections |
	intersections := self intersectCircle: aCircleArc circle.
	intersections ifEmpty: [ ^ #() ].
	^ intersections
		select: [ :each | 
			| angle |
			angle := ((each y - aCircleArc center y) negated arcTan: each x - aCircleArc center x)
				% Float twoPi.
			angle between: aCircleArc startAngle and: aCircleArc endAngle ]
]

{ #category : #'as yet unclassified' }
GLineSegment >> intersectEllipse: anEllipse [
	| hr_sq vr_sq lp ldir diff mdir mdiff a b c det result |
	hr_sq := anEllipse a squared.
	vr_sq := anEllipse b squared.
	lp := Array with: from with: to.
	
	ldir := lp second - lp first.
	diff := lp first - anEllipse center.
	mdir := ldir x / hr_sq @ (ldir y / vr_sq).
	mdiff := diff x / hr_sq @ (diff y / vr_sq).
	
	a := ldir dotProduct: mdir.
	b := ldir dotProduct: mdiff.
	c := (diff dotProduct: mdiff) - 1.
	det := b squared - a*c.
	a = 0 ifTrue: [ ^#() ].
	
	result := OrderedCollection new.
	det = 0 ifTrue: [ |t|
		t := b negated / a.
		result add: (lp first + ((lp second - lp first) * t))
	].
	(det > 0) ~= false ifTrue: [ |root t_a t_b|
		root := det sqrt.
		t_a := b negated - root / a.
		t_b := b negated + root / a.
		result add: (lp first + ((lp second - lp first) * t_a)).
		result add: (lp first + ((lp second - lp first) * t_b)).
	].

	^ result select: [ :each | each onLineFrom: self from to: self to ]
]

{ #category : #'as yet unclassified' }
GLineSegment >> intersectEllipseOld: anEllipse [
	| hr_sq vr_sq lp ldir diff mdir mdiff a b c det result |
	hr_sq := anEllipse a squared.
	vr_sq := anEllipse b squared.
	lp := Array with: from with: to.
	
	ldir := lp second - lp first.
	diff := lp first - anEllipse center.
	mdir := ldir x / hr_sq @ (ldir y / vr_sq).
	mdiff := diff x / hr_sq @ (diff y / vr_sq).
	
	a := ldir dotProduct: mdir.
	b := ldir dotProduct: mdiff.
	c := (diff dotProduct: mdiff) - 1.
	det := b squared - a*c.
	
	result := OrderedCollection new.
	det = 0 ifTrue: [ |t|
		t := b negated / a.
		result add: (lp first + ((lp second - lp first) * t))
	].
	(det > 0) ~= false ifTrue: [ |root t_a t_b|
		root := det sqrt.
		t_a := b negated - root / a.
		t_b := b negated + root / a.
		result add: (lp first + ((lp second - lp first) * t_a)).
		result add: (lp first + ((lp second - lp first) * t_b)).
	].

	^ result select: [ :each | each onLineFrom: self from to: self to ]
]

{ #category : #'as yet unclassified' }
GLineSegment >> intersectEllipseOlder: anEllipse [
	"collection of points of intersection with a GEllipse.
	Assume centered ellipse so move myself a bit
	
	\frac{x^2}{a^2} + \frac{y^2}{b^2} = 1
	
	z = a^2k^2 + b^2
	D = z - q^2
	x12 = \frac{a^2kq}{z} \pm \frac{ab}{z}\sqrt{D}
	y12 = \frac{b^2q}{z} \pm \frac{abk}{z}\sqrt{D}
	"

	| me z D k q a b |
"	me := self class from: self from - anEllipse center to: self to - anEllipse center."
	me := self.
	a := anEllipse a.
	b := anEllipse b.
	k := me parameters first.
	q := me parameters second.
	z := a squared * k squared + b squared.
	D := z - q squared.
	self haltOnce.
	"No solutions"
	D < 0
		ifTrue: [ ^ #() ].
	"One solution"
	D = 0
		ifTrue: [ ^ {((a squared * k * q / z) @ (b squared * q / z) + anEllipse center)} ].
	"Two solutions"
	^ Array
		with:
			anEllipse center
				+
					((a squared * k * q / z + (a * b * D sqrt / z))
						@ (b squared * q / z + (a * b * k * D sqrt / z)))
		with:
			anEllipse center
				+
					((a squared * k * q / z - (a * b * D sqrt / z))
						@ (b squared * q / z - (a * b * k * D sqrt / z)))
]

{ #category : #private }
GLineSegment >> intersectHorizontal: other [
	"Intersection with other line segment. Self must be horizontal (optimization purposes)"

	| pt |
	(pt := self intersectHorizontalLine: other) ifNil: [ ^ nil ].
	pt x < self left x | (pt x > self right x) | (pt y < other bottom y) | (pt y > other top y)
		ifTrue: [ ^ nil ].
	^ pt
]

{ #category : #private }
GLineSegment >> intersectHorizontalLine: other [
	"point of intersection of line on which line segment lies with line of other line segment or nil if parallel. Self must be horizontal (optimization purposes)"

	| x y vector |
	vector := other vector.
	vector y isZero
		ifTrue: [ ^ nil ].
	y := self from y.
	x := (self from y - other from y) * other cotan + other from x.
	^ x @ y
]

{ #category : #comparing }
GLineSegment >> intersectLine: other [
	"point of intersection of line on which line segment lies with line of other line segment or nil if parallel"

	| det x y |
	self isHorizontal
		ifTrue: [ ^ self intersectHorizontalLine: other ].
	self isVertical
		ifTrue: [ ^ self intersectVerticalLine: other ].
	det := self a * other b - (other a * self b).
	det isZero
		ifTrue: [ ^ nil ].
	x := (self b * other c - (other b * self c)) / det.
	y := (other a * self c - (self a * other c)) / det.
	^ x @ y
]

{ #category : #comparing }
GLineSegment >> intersectLines: other [
	^ self intersectLine: other
]

{ #category : #comparing }
GLineSegment >> intersectPolygon: polygon [
	"^ self intersectRectangle: polygon encompasingRectangle."
	| intersections vertices next intersection |
	intersections := Set new.
	vertices := polygon vertices.
	vertices doWithIndex: [ :current :i | 
		next := i = vertices size
			ifTrue: [ vertices first ]
			ifFalse: [ vertices at: i+1 ].
		intersection := self finiteLinesIntersectFrom: current to: next.
		intersection 
			ifNotNil: [ intersections add: intersection ] ].
	^ intersections
]

{ #category : #comparing }
GLineSegment >> intersectRectangle: aRectangle [
	"collection of points of intersection with not rotated rectangle"

	| pts bottomLeft bottomRight topLeft topRight |
	bottomLeft := aRectangle bottomLeft.
	bottomRight := aRectangle bottomRight.
	topLeft := aRectangle topLeft.
	topRight := aRectangle topRight.
	pts := Set new.
	pts add: ((self class from: topLeft to: topRight) intersectHorizontal: self).
	pts add: ((self class from: bottomLeft to: bottomRight) intersectHorizontal: self).
	pts add: ((self class from: topLeft to: bottomLeft) intersectVertical: self).
	pts add: ((self class from: topRight to: bottomRight) intersectVertical: self).
	pts remove: nil ifAbsent: [  ].
	^ pts
]

{ #category : #private }
GLineSegment >> intersectVertical: other [
	"Intersection with other line segment. Self must be vertical (optimization purposes)"

	| pt |
	pt := self transposed intersectHorizontal: other transposed.
	pt ifNil: [ ^ nil ].
	^ pt transposed
]

{ #category : #private }
GLineSegment >> intersectVerticalLine: other [
	"point of intersection of line on which line segment lies with line of other line segment or nil if parallel. Self must be vertical (optimization purposes)"

	| pt |
	pt := self transposed intersectHorizontalLine: other transposed.
	pt ifNil: [ ^ nil ].
	^ pt transposed
]

{ #category : #comparing }
GLineSegment >> intersection: other [
	"point of intersection with other line segment or nil if it does not exists"

	| intersection |
	self isHorizontal
		ifTrue: [ ^ self intersectHorizontal: other ].
	self isVertical
		ifTrue: [ ^ self intersectVertical: other ].
	intersection := self intersectLines: other.
	intersection ifNil: [ ^ nil ].
	(intersection onLineFrom: self from to: self to) & (intersection onLineFrom: other from to: other to)
		ifFalse: [ ^ nil ].
	^ intersection
]

{ #category : #testing }
GLineSegment >> isHorizontal [
	^ from y = to y
]

{ #category : #testing }
GLineSegment >> isVertical [
	^ from x = to x
]

{ #category : #accessing }
GLineSegment >> left [
	^ from x < to x
		ifTrue: [ from ]
		ifFalse: [ to ]
]

{ #category : #geometry }
GLineSegment >> length [
	^ self vector r
]

{ #category : #geometry }
GLineSegment >> parameters [
	| k q |
	"y = kx + q
	k = (y2-y1) / (x2-x1)
	q = y1 - k * x1	"
	k := (to y - from y) / (to x - from x).
	q := from y - (k * from x).
	^ Array with: k with: q
]

{ #category : #geometry }
GLineSegment >> pointForBalance: aNumber [
	"Return point on the line as specified by the balance.
	Balance is
		\in <0,1> for relative (e.g. 0 start, 1 end, 0.5 middle).
		>1 for absolute starting from source (e.g. '10' is 10 pixels from the FROM)
		<1 for absolute starting from end (e.g. '-10' is 10 pixesl from the TO)
	"

	| balance |
	balance := aNumber.
	(aNumber between: 0 and: 1)
		ifTrue: [ balance := self length * aNumber ].
	balance < 0
		ifTrue: [ balance := self length - balance negated ].
	^ self length > 0
		ifTrue: [ from + (self vector / self length * balance) ]
		ifFalse: [ from ]
]

{ #category : #accessing }
GLineSegment >> right [
	^ from x > to x
		ifTrue: [ from ]
		ifFalse: [ to ]
]

{ #category : #geometry }
GLineSegment >> sideOfPoint: aPoint [
	"Compute on which side of the segment a point is.
	For line going from left A=(a_x, a_y) to right B=(b_x, b_y) the value is
	d = (x - a_x)(b_y - a_y) - (y - a_y)(b_x - a_x)
	1 - above the line
	0 - on the line
  -1 - below the line
	"

	^ ((aPoint x - from x) * (to y - from y) - ((aPoint y - from y) * (to x - from x))) sign
]

{ #category : #'as yet unclassified' }
GLineSegment >> sintersectEllipse: anEllipse [
	"collection of points of intersection with a GEllipse.
	Assume centered ellipse so move myself a bit
	
	\frac{x^2}{a^2} + \frac{y^2}{b^2} = 1
	
	z = a^2k^2 + b^2
	D = z - q^2
	x12 = \frac{a^2kq}{z} \pm \frac{ab}{z}\sqrt{D}
	y12 = \frac{b^2q}{z} \pm \frac{abk}{z}\sqrt{D}
	"

	| me z D k q a b |
	"	me := self class from: self from - anEllipse center to: self to - anEllipse center."
	me := self.
	a := anEllipse a.
	b := anEllipse b.
	k := me parameters first.
	q := me parameters second.
	z := a squared * k squared + b squared.
	D := z - q squared.
	"No solutions"
	D < 0
		ifTrue: [ ^ #() ].
	"One solution"
	D = 0
		ifTrue: [ ^ {((a squared * k * q / z) @ (b squared * q / z) + anEllipse center)} ].
	"Two solutions"
	^ Array
		with:
			anEllipse center
				+
					((a squared * k * q / z + (a * b * D sqrt / z))
						@ (b squared * q / z + (a * b * k * D sqrt / z)))
		with:
			anEllipse center
				+
					((a squared * k * q / z - (a * b * D sqrt / z))
						@ (b squared * q / z - (a * b * k * D sqrt / z)))
]

{ #category : #geometry }
GLineSegment >> tan [
	| vector |
	vector := self vector.
	vector x isZero
		ifTrue: [ ^ nil ].
	^ vector y / vector x
]

{ #category : #accessing }
GLineSegment >> to [
	^ to
]

{ #category : #accessing }
GLineSegment >> to: toPoint [
	to := toPoint
]

{ #category : #accessing }
GLineSegment >> top [
	^ from y > to y
		ifTrue: [ from ]
		ifFalse: [ to ]
]

{ #category : #geometry }
GLineSegment >> transposed [
	^ self class from: from transposed to: to transposed
]

{ #category : #geometry }
GLineSegment >> vector [
	^ to - from
]
