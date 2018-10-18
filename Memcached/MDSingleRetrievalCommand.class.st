Class {
	#name : #MDSingleRetrievalCommand,
	#superclass : #MDRetrievalCommand,
	#instVars : [
		'key'
	],
	#category : #'Memcached-Commands'
}

{ #category : #private }
MDSingleRetrievalCommand >> executeOnProtocol [
	| result |
	result := super executeOnProtocol.
	result isEmpty ifTrue: [ self keyNotFound ].
	^result at: 1
]

{ #category : #accessing }
MDSingleRetrievalCommand >> key: aString [ 
	key := aString
]

{ #category : #private }
MDSingleRetrievalCommand >> keyNotFound [
	self keyNotFound: key asString
]

{ #category : #private }
MDSingleRetrievalCommand >> writeToProtocol [
	"get <key>*\r\n"
	super writeToProtocol.
	protocol nextPutAll: key.
	protocol endCommand
]
