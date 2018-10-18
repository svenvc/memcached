Class {
	#name : #MDBasicClientTest,
	#superclass : #TestCase,
	#category : #MemcachedTests
}

{ #category : #testing }
MDBasicClientTest >> testConvenience [
	| client |
	client := MDBasicClient new.
	[
		client at: 'foo' ifAbsentPut: [ #[1 2 3] ].
		self assert: (client at: 'foo') = #[1 2 3].
		self assert: (client includesKey: 'foo').
		client removeKey: 'foo'.
		self deny: (client includesKey: 'foo').
		self should: [ client at: 'foo' ] raise: MDKeyNotFoundError 
	] ensure: [ client close ]
]

{ #category : #testing }
MDBasicClientTest >> testEncoderDecoder [
	| client |
	client := MDBasicClient new.
	client 
		encoder: [ :object | object printString asByteArray ];
		decoder: [ :byteArray | Object readFrom: byteArray asString ].
	[
		client set: 'string' value: 'aStringValue'.
		self assert: (client get: 'string') = 'aStringValue'.
		client set: 'integer' value: 123456.
		self assert: (client get: 'integer') = 123456.
		client set: 'boolean' value: true.
		self assert: (client get: 'boolean') = true.
	] ensure: [ client close ]
]

{ #category : #testing }
MDBasicClientTest >> testSetGet [
	| client |
	client := MDBasicClient new.
	[
		client set: 'foo' value: #[1 2 3].
		self assert: (client get: 'foo') = #[1 2 3]
	] ensure: [ client close ]
]
