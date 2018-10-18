"
I am the basic memcache client for memcache 1.2.6 or less.
"
Class {
	#name : #MDCacheClient,
	#superclass : #MDCacheClientBase,
	#category : #'Memcached-Client'
}

{ #category : #defaults }
MDCacheClient class >> defaultStaleTime [
	^ 5 seconds
]

{ #category : #protocol }
MDCacheClient >> get: aString [
	"when a get goes stale, reset the value with a stale flag to expire shortly, this prevents
	other gets from all stampeeding the database for fresh data all at once"

	| result needsRefreshed |
	result := super get: aString.
	result ifNil: [ ^ nil ].
	needsRefreshed := result second.
	(result first < DateAndTime now and: [ needsRefreshed not ])
		ifTrue: [ 
			"this 0 seconds will actually be just the defaultStaleTimeout"
			self
				set: aString
				value: result third
				expires: 0 seconds
				refreshed: true.	
			"this return of nil should cause client to reset value if necessary, otherwise
			the timeout will expire shortly"
			^ nil ].
	^ result third
]

{ #category : #protocol }
MDCacheClient >> set: aString value: aValue expires: aDuration [
	^ self
		set: aString
		value: aValue
		expires: aDuration
		refreshed: false
]

{ #category : #private }
MDCacheClient >> set: aString value: aValue expires: aDuration refreshed: isRefreshed [
	"embed the actual expire time in the data and add an additional stale time to
	memcached timeout to prevent stampeed when key expires; get does the opposite"

	| timeout |
	timeout := aDuration
		ifNil: [ DateAndTime now + 10 days ]
		ifNotNil: [ DateAndTime now + aDuration ].
	super
		set: aString
		value: { timeout. 	isRefreshed. aValue } 
		expires:
			(aDuration
				ifNil: [ 10 days ]
				ifNotNil: [ aDuration + self class defaultStaleTime ]).
	^ aValue
]
