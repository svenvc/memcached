"
A MDQuitCommand is a command that upon receiving causes the server to close the connection.

However, the client may also simply close the connection when it no longer needs it, without issuing this command.
"
Class {
	#name : #MDQuitCommand,
	#superclass : #MDCommand,
	#category : #'Memcached-Commands'
}

{ #category : #private }
MDQuitCommand >> decodeResponse: aByteArray [
	"no response will be sent, server will close upon receive"
]

{ #category : #private }
MDQuitCommand >> executeOnProtocol [
	self writeToProtocol
	"don't read response, there will be none"
]

{ #category : #private }
MDQuitCommand >> writeToProtocol [
	"quit\r\n"
	protocol nextPutAll: #[113 117 105 116]. "'quit' asByteArray"
	protocol endCommand.
	protocol closeStream
]
