Class {
	#name : #MDClientTest,
	#superclass : #TestCase,
	#instVars : [
		'cache'
	],
	#category : #MemcachedTests
}

{ #category : #'as yet unclassified' }
MDClientTest class >> isAbstract [
	^ self name = #MDClientTest
]

{ #category : #running }
MDClientTest >> clientClass [
	self subclassResponsibility
]

{ #category : #running }
MDClientTest >> sampleObject [
	^ {true.
	1.
	'cool'.
	{}.
	4.0.
	(Date today)}
]

{ #category : #running }
MDClientTest >> serverList [
	self subclassResponsibility
]

{ #category : #running }
MDClientTest >> setUp [
	super setUp.
	cache := self clientClass onServers: self serverList
]

{ #category : #running }
MDClientTest >> testBigSet [
	| bigList |
	bigList := (1 to: 1000) collect:[:e | self sampleObject ].
	cache set: #bigList value: bigList.
	self assert: bigList size equals: (cache get: #bigList) size

]

{ #category : #running }
MDClientTest >> testBigSetExpires [
	| bigList |
	bigList := (1 to: 1000) collect:[:e | self sampleObject ].
	cache set: #bigList value: bigList expires: 10 seconds.
	self assert: bigList size equals: (cache get: #bigList) size

]

{ #category : #running }
MDClientTest >> testDecrement [
	cache setCounter: #someKey value: 10.
	self assert: 9 equals: (cache decrement: #someKey) .
	self assert: 8 equals: (cache decrement: #someKey) .
	self assert: 7 equals: (cache decrement: #someKey) .
	self assert: 6 equals: (cache decrement: #someKey) .
	self assert: 5 equals: (cache decrement: #someKey) 
]

{ #category : #running }
MDClientTest >> testForgotToSetServers [
	cache := self clientClass new.
	self should: [ cache get: #someKey ] raise: Error
]

{ #category : #running }
MDClientTest >> testGetIfAbsentPut [
	cache remove: #testObjectAbsent.
	self assert: (cache get: #testObjectAbsent ifAbsentPut: [ 'string' ]) equals: 'string'
]

{ #category : #running }
MDClientTest >> testGetIfAbsentPutExactMatch [
	| object |
	cache remove: #testObjectAbsent.
	object := Object new.
	self assert: (cache get: #testObjectAbsent ifAbsentPut: [ object ]) == object
]

{ #category : #running }
MDClientTest >> testGetIfAbsentPutExactMatchExpires [
	| object |
	cache remove: #testObjectAbsent.
	object := Object new.
	self assert: (cache get: #testObjectAbsent ifAbsentPut: [ object ] expires: 10 seconds) == object
]

{ #category : #running }
MDClientTest >> testGetIfAbsentPutExpires [
	cache remove: #testObjectAbsent.
	self assert: (cache get: #testObjectAbsent ifAbsentPut: [ 'string' ] expires: 1 seconds) equals: 'string'
]

{ #category : #running }
MDClientTest >> testGetNotFound [
	self assert: (cache get: #testObjectNotSet) isNil.

]

{ #category : #running }
MDClientTest >> testIncrement [
	cache setCounter: #someKey value: 0.
	self assert: 1 equals: (cache increment: #someKey).
	self assert: 2 equals: (cache increment: #someKey).
	self assert: 3 equals: (cache increment: #someKey).
	self assert: 4 equals: (cache increment: #someKey).
	self assert: 5 equals: (cache increment: #someKey)
]

{ #category : #running }
MDClientTest >> testNilSetGet [
	| cached |
	cache set: #testObject value: nil.
	cached := cache get: #testObject.
	self assert: cached isNil
]

{ #category : #running }
MDClientTest >> testRemove [
	cache set: #testObject value: 'string'.
	self deny: (cache get: #testObject) isNil.
	cache remove: #testObject.
	self assert: (cache get: #testObject) isNil.

]

{ #category : #running }
MDClientTest >> testSetCounterResult [
	self assert: 1 equals: (cache setCounter: #testObject value: 1)
]

{ #category : #running }
MDClientTest >> testSetExpires [
	cache set: #testObject value: 'string' expires: 1 seconds.
	self deny: (cache get: #testObject) isNil.
	2 seconds asDelay wait.
	self assert: (cache get: #testObject) isNil.

]

{ #category : #running }
MDClientTest >> testSetExpiresResult [
	self assert: 'string' equals: (cache set: #testObject value: 'string' expires: 1 seconds)
]

{ #category : #running }
MDClientTest >> testSetGet [
	| obj cached |
	obj := self sampleObject.
	cache set: #testObject value: obj.
	cached := cache get: #testObject.
	self assert: obj equals: cached
]

{ #category : #running }
MDClientTest >> testSetResult [
	self assert: 'string' equals: (cache set: #testObject value: 'string')
]
