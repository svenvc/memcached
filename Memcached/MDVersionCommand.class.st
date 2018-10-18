"
A MDVersionCommand is a command the returns the the version string for the server.

"
Class {
	#name : #MDVersionCommand,
	#superclass : #MDCommand,
	#category : #'Memcached-Commands'
}

{ #category : #private }
MDVersionCommand >> decodeResponse: aByteArray [
	super decodeResponse: aByteArray.
	"VERSION <version>"
	(aByteArray beginsWith: #(86 69 82 83 73 79 78)) "'VERSION' asByteArray"
		ifFalse: [ protocol protocolError ].
	^protocol codec decodeAsciiString: aByteArray startingAt: 9
]

{ #category : #private }
MDVersionCommand >> writeToProtocol [
	"version\r\n"
	protocol nextPutAll: #[118 101 114 115 105 111 110]. "'version' asByteArray"
	protocol endCommand
]
