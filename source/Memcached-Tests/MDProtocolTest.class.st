"
Unit tests for MDProtocol
"
Class {
	#name : #MDProtocolTest,
	#superclass : #TestCase,
	#instVars : [
		'protocol',
		'data',
		'key'
	],
	#category : #'Memcached-Tests'
}

{ #category : #running }
MDProtocolTest >> setUp [

	protocol := MDProtocolBuilder buildDefault.
	key := ByteArray with: 107 with: 101 with: 121.
	data := ByteArray
		with: 49
		with: 51
		with: 51
		with: 55
]

{ #category : #running }
MDProtocolTest >> tearDown [

	protocol quit execute
]

{ #category : #running }
MDProtocolTest >> testAdd [

	| item expected |
	self assert: (protocol add key: key; data: data; execute). 
	
	item := protocol get key: key; execute.
	expected := String streamContents: [ :stream |
		key do: [ :each |
			stream nextPut: (Character value: each) ] ].
	self assert: item key = expected.
	self assert: item data = data.
	
	protocol delete key: key; execute

]

{ #category : #running }
MDProtocolTest >> testCount [

	| countKey count |

	countKey :=  ByteArray withAll: #(99 111 117 110 116 75 101 121).
	protocol set key: countKey; data: (ByteArray with: $0 asciiValue); execute.
	
	count := protocol incr key: countKey; execute.
	self assert: count = 1.
	
	count := protocol incr key: countKey; value: (ByteArray with: $9 asciiValue); execute.
	self assert: count = 10.
	
	count := protocol decr key: countKey; execute.
	self assert: count = 9.
	
	count := protocol decr key: countKey; value: (ByteArray with: $9 asciiValue); execute.
	self assert: count = 0.
	
	"integer underflow"
	count := protocol decr key: countKey; execute.
	self assert: count = 0.
	
	"integer overflow"
	protocol set key: countKey; data: ((2 raisedTo: 64) - 1) asString asByteArray; execute.
	count := protocol incr key: countKey; execute.
	self assert: count = 0.
]

{ #category : #running }
MDProtocolTest >> testFlow [

	| hasAdded hasDeleted hasReplaced |

	hasAdded := protocol add key: key; data: data; execute.
	self assert: hasAdded.
	hasAdded := protocol add key: key; data: data; execute.
	self deny: hasAdded.
	hasDeleted := protocol delete key: key; execute.
	self assert: hasDeleted.
	hasDeleted := protocol delete key: key; execute.
	self deny: hasDeleted.

	hasReplaced := protocol replace key: key; data: data; execute.
	self deny: hasReplaced.
	protocol set key: key; data: data; execute.
	hasReplaced := protocol replace key: key; data: data; execute.
	self assert: hasReplaced.
	
	hasDeleted := protocol delete key: key; execute.
	self assert: hasDeleted.
]

{ #category : #running }
MDProtocolTest >> testFlushAll [

	protocol flushAll execute
]

{ #category : #running }
MDProtocolTest >> testNoKey [

	protocol delete key: key, #(100); execute.
	self should: [ protocol incr key: key, #(100); execute ] raise: MDKeyNotFoundError.
	self should: [ protocol decr key: key, #(100); execute ] raise: MDKeyNotFoundError.
]

{ #category : #running }
MDProtocolTest >> testStats [

	| stats |

	stats := protocol stats execute.
	self assert: stats version equals: '1.6.7';
		assert: stats currentItems > 0;
		assert: stats evictions equals: 0;
		assert: stats hits > 0;
		assert: stats misses > 0;
		assert: stats retrievalRequests > 0;
		assert: stats storageRequests > 0;
		assert: stats totalItems > 0;
		assert: stats maximumBytes equals: 67108864;
		assert: stats pointerSize equals: 64;
		assert: stats bytesRead > 0;
		assert: stats bytesUsed > 0;
		assert: stats bytesWritten > 0;
		assert: stats connectionStructures isInteger;
		assert: stats currentConnections > 0.
]
