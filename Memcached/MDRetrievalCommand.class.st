Class {
	#name : #MDRetrievalCommand,
	#superclass : #MDMultilineCommand,
	#category : #'Memcached-Commands'
}

{ #category : #private }
MDRetrievalCommand >> decodeLine: aByteArray [
	| header key flags bytes data codec end |
	header := aByteArray first: 6.
	(header = (ByteArray withAll: #(86 65 76 85 69 32))) "'VALUE ' asByteArray"
		ifFalse: [ protocol protocolError ].
	codec := protocol codec.
	key := codec decodeAsciiString: aByteArray startingAt: 7.
	flags := codec decodeUnsignedInteger: aByteArray startingAt: 7 + key size.
	end := codec firstNonNumericIn: aByteArray startingAt: 9 + key size.
	bytes := codec decodeUnsignedInteger: aByteArray startingAt: end + 1.
	data := protocol readResponse: bytes.
	^MDItem key: key flags: flags data: data
]

{ #category : #private }
MDRetrievalCommand >> decodeResponse: anArray [
	"nothing to do, already done"
	^anArray
]

{ #category : #private }
MDRetrievalCommand >> writeToProtocol [
	protocol nextPutAll: #[103 101 116]. "'get' asByteArray"
	protocol space
]
