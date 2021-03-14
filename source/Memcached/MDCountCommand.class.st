"
A MDCountCommand is a command that changes the value of a variable on the server.

Commands ""incr"" and ""decr"" are used to change data for some item
in-place, incrementing or decrementing it. The data for the item is
treated as decimal representation of a 32-bit unsigned integer. If the
current data value does not conform to such a representation, the
commands behave as if the value were 0. Also, the item must already
exist for incr/decr to work; these commands won't pretend that a
non-existent key exists with value 0; instead, they will fail.

Instance Variables
	key:		<String>
	value:		<Integer>


- key
	is the key of the item the client wishes to change

- value
	is the amount by which the client wants to increase/decrease
	the item. It is a decimal representation of a 32-bit unsigned integer.
"
Class {
	#name : #MDCountCommand,
	#superclass : #MDCommand,
	#instVars : [
		'key',
		'value'
	],
	#category : #'Memcached-Commands'
}

{ #category : #private }
MDCountCommand >> decodeResponse: aByteArray [
	super decodeResponse: aByteArray.
	aByteArray = (ByteArray withAll: #(78 79 84 95 70 79 85 78 68)) "'NOT_FOUND' asByteArray"
		ifTrue: [ self keyNotFound ].
	^protocol decodeUnsignedInteger: aByteArray startingAt: 1
]

{ #category : #accessing }
MDCountCommand >> key: aByteArray [ 
	key := aByteArray
]

{ #category : #private }
MDCountCommand >> keyNotFound [
	self keyNotFound: key asString
]

{ #category : #private }
MDCountCommand >> setProtocol: aProtocol [
	super setProtocol: aProtocol.
	value := ByteArray with:  49 "$1 asciiValue"
]

{ #category : #accessing }
MDCountCommand >> value: aByteArray [ 
	value := aByteArray
]

{ #category : #private }
MDCountCommand >> writeToProtocol [
	protocol space.
	protocol nextPutAll: key.
	protocol space.
	protocol nextPutAll: value.
	protocol endCommand
]
