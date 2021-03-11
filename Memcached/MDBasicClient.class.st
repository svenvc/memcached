"
I am MDBasicClient, an interface to a single memcached server.
For more information, see http://en.wikipedia.org/wiki/Memcached

| client |
client := MDBasicClient new.
[
	client 
		at: 'foo-key' 
		ifAbsentPut: [ 'my-long-query-result' asByteArray ].

] ensure: [ client close ]

My 'operations' protocol has methods named according to memcached commands,
my 'convenience' protocol has methods named according to Smalltalk conventions.
"
Class {
	#name : #MDBasicClient,
	#superclass : #Object,
	#instVars : [
		'server',
		'protocol',
		'encoder',
		'decoder'
	],
	#category : #'Memcached-Client'
}

{ #category : #initialize }
MDBasicClient class >> on: mdServer [
	"MDBasicClient on: (MDServer host: 'myhost' port: 22452)."

	^ (self new) server: mdServer; yourself
]

{ #category : #operations }
MDBasicClient >> add: key value: value [
	"Store value under key, but only if key does not already exist.
	Return a boolean indicating whether a store was actually done."
	
	| add |
	add := self protocol add.
	add
		key: key;
		data: (self encode: value).
	^ add execute
]

{ #category : #convenience }
MDBasicClient >> at: key [
	"Return the data stored under key or signal MDKeyNotFoundError"
	
	^ self get: key
]

{ #category : #convenience }
MDBasicClient >> at: key add: value [
	"Store value under key, but only when key is not yet present.
	Return a boolean indicating actual storage."
	
	^ self add: key value: value
]

{ #category : #convenience }
MDBasicClient >> at: key ifAbsent: block [
	"Return the value stored under key, execute block if not key is found."

	| found |
	"Evaluate the block outside the error handler to release the lock inside"
	(found := [ self get: key ]
		on: MDKeyNotFoundError
		do: [ :signal | signal return: nil ]) isNil
		ifTrue: [ ^ block value ].
	^ found
]

{ #category : #convenience }
MDBasicClient >> at: key ifAbsentPut: block [
	"The conventional Smalltalk cache method: 
	lookup the value stored under key and return it if found,
	otherwise evaluate block to compute a new value and store it.
	Always return either the old or the new value."
	
	^ self at: key ifAbsent: [ self at: key put: block value ]
]

{ #category : #convenience }
MDBasicClient >> at: key put: value [
	"Store value under key and return value."
	
	self set: key value: value.
	^ value
]

{ #category : #'initialize-release' }
MDBasicClient >> close [
	protocol notNil 
		ifTrue: [ 
			protocol quit execute. 
			protocol := nil ]
]

{ #category : #private }
MDBasicClient >> decode: byteArray [
	^ decoder isNil
		ifTrue: [ byteArray ]
		ifFalse: [ decoder value: byteArray ]
]

{ #category : #accessing }
MDBasicClient >> decoder [
	^ decoder
]

{ #category : #'initialize-release' }
MDBasicClient >> decoder: block [
	"Set my decoder, a one argument block to convert 
	a byte array to a Smalltalk object. Can be nil."
	
	decoder := block
]

{ #category : #operations }
MDBasicClient >> decrement: key [
	"Assuming the value stored under key is the ASCII representation of an integer,
	decrement the value and return it. Signals MDKeyNotFoundError if key is not found."
	
	| decr |
	decr := self protocol decr.
	decr key: key.
	^ decr execute
]

{ #category : #operations }
MDBasicClient >> delete: key [
	"Delete the value stored under key.
	Return true when the key was found and deleted, false otherwise."
	
	| delete |
	delete := self protocol delete.
	delete key: key.
	^ delete execute
]

{ #category : #private }
MDBasicClient >> encode: object [
	^ encoder isNil
		ifTrue: [ object ]
		ifFalse: [ encoder value: object ]
]

{ #category : #accessing }
MDBasicClient >> encoder [
	^ encoder
]

{ #category : #'initialize-release' }
MDBasicClient >> encoder: block [
	"Set my encoder, a one argument block to convert 
	a Smalltalk object to a byte array. Can be nil."
	
	encoder := block
]

{ #category : #operations }
MDBasicClient >> flushAll [
	"Remove all entries from the cache (in a lazy manner)."
	
	^ self protocol flushAll execute
]

{ #category : #operations }
MDBasicClient >> get: key [
	"Return the data stored under key. 
	Signals MDKeyNotFoundError if key is not found."
	
	| get |
	get := self protocol get.
	get key: key.
	^ self decode: get execute data
]

{ #category : #convenience }
MDBasicClient >> includesKey: key [
	"Return a boolean indicating whether or not I have data stored under key"

	^ [ self get: key.
	true ]
		on: MDKeyNotFoundError
		do: [ :signal | signal return: false ]
]

{ #category : #operations }
MDBasicClient >> increment: key [
	"Assuming the value stored under key is the ASCII representation of an integer,
	increment the value and return it. Signals MDKeyNotFoundError if key is not found."
	
	| incr |
	incr := self protocol incr.
	incr key: key.
	^ incr execute
]

{ #category : #accessing }
MDBasicClient >> protocol [
	protocol isNil 
		ifTrue: [ 
			protocol := self server openProtocol ].
	^ protocol
]

{ #category : #convenience }
MDBasicClient >> removeAll [
	"Remove all my keys, return self"
	
	self flushAll
]

{ #category : #convenience }
MDBasicClient >> removeKey: key [
	"Remove any data that I store under key.
	Contrary to the Smalltalk convention to return the value if found,
	a boolean indicating actual removal is returned."
	
	^ self delete: key
]

{ #category : #operations }
MDBasicClient >> replace: key value: value [
	"Store value under key, but only if key does already exist.
	Return a boolean indicating whether a store was actually done."

	| replace |
	replace := self protocol replace.
	replace
		key: key;
		data: (self encode: value).
	^ replace execute
]

{ #category : #accessing }
MDBasicClient >> server [
	server isNil 
		ifTrue: [ 
			server := MDServer default ].
	^ server
]

{ #category : #'initialize-release' }
MDBasicClient >> server: anMDServer [
	self close.
	server := anMDServer
]

{ #category : #operations }
MDBasicClient >> set: key value: value [
	"Store value under key. Return a boolean indicating success."
	
	| set |
	set := self protocol set.
	set 
		key: key;
		data: (self encode: value).
	^ set execute
]

{ #category : #operations }
MDBasicClient >> stats [
	"Return an MDStatistic object containing interesting data regarding the memcached server"
	
	^ self protocol stats execute
]
