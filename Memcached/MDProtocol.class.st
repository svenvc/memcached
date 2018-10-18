"
A MDProtocol is a low level implementation of the memcached protocol that deals with bytes.
"
Class {
	#name : #MDProtocol,
	#superclass : #Object,
	#instVars : [
		'stream',
		'mutex',
		'codec'
	],
	#category : #'Memcached-Core'
}

{ #category : #'instance creation' }
MDProtocol class >> on: aStream [
	^self new initializeWithStream: aStream
]

{ #category : #commands }
MDProtocol >> add [
	"'add' means 'store this data, but only if the server *doesn't* already
  hold data for this key'"
	^self storageCommand add
]

{ #category : #'private-decoding' }
MDProtocol >> checkServerError: aByteArray [
	(aByteArray beginsWith: #(69 82 82 79 82)) "'ERROR' asByteArray"
		ifTrue: [ self noSuchCommand ].
	(aByteArray beginsWith: #(67 76 73 69 78 84 95 69 82 82 79 82)) "'CLIENT_ERROR' asByteArray"
		ifTrue: [ self clientError: aByteArray ].
	(aByteArray beginsWith: #(83 69 82 86 69 82 95 69 82 82 79 82)) "'SERVER_ERROR' asByteArray"
		ifTrue: [ self clientError: aByteArray ]
]

{ #category : #'private-signaling' }
MDProtocol >> clientError: aByteArray [
	"CLIENT_ERROR <error>"
	MDClientError signal: (codec decodeAsciiString: aByteArray startingAt: 14)
]

{ #category : #private }
MDProtocol >> closeStream [
	stream close
]

{ #category : #accessing }
MDProtocol >> codec [
	^codec
]

{ #category : #private }
MDProtocol >> codecClass [
	^Smalltalk at: #MDChronosCodec ifAbsent: [ MDInternalCodec ]
]

{ #category : #'private-commands' }
MDProtocol >> command: aCommandClass [
	^aCommandClass on: self
]

{ #category : #'private-signaling' }
MDProtocol >> connectionClosed [
	MDConnectionClosedError signal
]

{ #category : #writing }
MDProtocol >> crlf [
	stream nextPut: 13.
	stream nextPut: 10.
]

{ #category : #'private-decoding' }
MDProtocol >> decodeAsciiString: aByteArray startingAt: anInteger [
	| buffer totalSize |
	totalSize := aByteArray size.
	buffer := WriteStream on: (String new: totalSize - anInteger).
	anInteger to: totalSize do: [ :index |
		| value |
		value := aByteArray at: index.
		value = 32 "space"
			ifTrue: [ ^buffer contents ].
		buffer nextPut: (Character value: value) ].
	^buffer contents
]

{ #category : #'private-decoding' }
MDProtocol >> decodeUnsignedInteger: aByteArray startingAt: anInteger [
	| buffer totalSize |
	totalSize := aByteArray size.
	buffer := 0.
	anInteger to: totalSize do: [ :index |
		| value |
		value := aByteArray at: index.
		value = 32 "space"
			ifTrue: [ ^buffer ].
		buffer := (buffer * 10) + (value - 48) ].
	^buffer
]

{ #category : #commands }
MDProtocol >> decr [
	^self command: MDDecrementCommand
]

{ #category : #commands }
MDProtocol >> delete [
	^self command: MDDeleteCommand
]

{ #category : #writing }
MDProtocol >> endCommand [
	self crlf.
	stream flush
]

{ #category : #private }
MDProtocol >> execute: aCommand [
	^mutex critical: [ aCommand executeOnProtocol ]
]

{ #category : #commands }
MDProtocol >> flushAll [
	^self command: MDFlushCommand
]

{ #category : #commands }
MDProtocol >> get [
	^self command: MDSingleRetrievalCommand
]

{ #category : #commands }
MDProtocol >> incr [
	^self command: MDIncrementCommand
]

{ #category : #'initialize-release' }
MDProtocol >> initializeWithStream: aStream [
	stream := aStream binary.
	mutex := Semaphore forMutualExclusion.
	codec := self codecClass new
]

{ #category : #writing }
MDProtocol >> nextPutAll: aByteArray [
	stream nextPutAll: aByteArray
]

{ #category : #'private-signaling' }
MDProtocol >> noSuchCommand [
	MDNoSuchCommandError signal
]

{ #category : #'private-signaling' }
MDProtocol >> protocolError [
	"SERVER_ERROR <error>"
	MDProtocolError signal
]

{ #category : #commands }
MDProtocol >> quit [
	^self command: MDQuitCommand
]

{ #category : #reading }
MDProtocol >> readResponse [
	"read up to CR LF into a byte array"

	stream atEnd 	ifTrue: [ self connectionClosed ].
	^ByteArray streamContents: [ :buffer |
		| last secondLast |
		secondLast := stream next.
		last := stream next.
		[ secondLast = 13
			and: [ last = 10 ] ]
				whileFalse: [
					buffer nextPut: secondLast.
					secondLast := last.
					last := stream next ] ]
]

{ #category : #reading }
MDProtocol >> readResponse: anInteger [
	"read up to CR LF into a byte array"
	| data cr lf |
	data := stream next: anInteger.
	cr := stream next.
	lf := stream next.
	(cr ~= 13 or: [ lf ~= 10 ])
		ifTrue: [ self protocolError ].
	^data
]

{ #category : #commands }
MDProtocol >> replace [
	"'replace' means 'store this data, but only if the server *does*
  already hold data for this key'"
	^self storageCommand replace
]

{ #category : #'private-signaling' }
MDProtocol >> serverError: aByteArray [
	"SERVER_ERROR <error>"
	MDClientError signal: (codec decodeAsciiString: aByteArray startingAt: 14)
]

{ #category : #commands }
MDProtocol >> set [
	"'set' means 'store this data'"
	^self storageCommand set
]

{ #category : #writing }
MDProtocol >> space [
	stream nextPut: 32.
]

{ #category : #commands }
MDProtocol >> stats [
	^self command: MDStatisticsCommand
]

{ #category : #'private-commands' }
MDProtocol >> storageCommand [
	^self command: MDStorageCommand
]

{ #category : #commands }
MDProtocol >> version [
	^self command: MDVersionCommand
]
