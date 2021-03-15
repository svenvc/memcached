"
Abstract superclass of all memcached protocl commands
"
Class {
	#name : #MDCommand,
	#superclass : #Object,
	#instVars : [
		'protocol'
	],
	#category : #'Memcached-Commands'
}

{ #category : #'instance creation' }
MDCommand class >> on: aProtocol [
	^self new setProtocol: aProtocol
]

{ #category : #private }
MDCommand >> decodeResponse: aByteArray [
	protocol checkServerError: aByteArray
]

{ #category : #actions }
MDCommand >> execute [
	^self decodeResponse: (protocol execute: self)
]

{ #category : #private }
MDCommand >> executeOnProtocol [
	self writeToProtocol.
	^protocol readResponse
]

{ #category : #private }
MDCommand >> keyNotFound: aString [
	MDKeyNotFoundError signal: 'key not found: ', aString
]

{ #category : #private }
MDCommand >> setProtocol: aProtocol [
	protocol := aProtocol
]

{ #category : #private }
MDCommand >> writeToProtocol [
	self subclassResponsibility
]
