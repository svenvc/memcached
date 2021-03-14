"
A MDIncrementCommand is a command that increments a variable on the server.

Overflow in the ""incr"" command is not checked.
"
Class {
	#name : #MDIncrementCommand,
	#superclass : #MDCountCommand,
	#category : #'Memcached-Commands'
}

{ #category : #private }
MDIncrementCommand >> writeToProtocol [
	"incr <key> <value>\r\n"
	protocol nextPutAll: #[105 110 99 114]. "'incr' asByteArray"
	super writeToProtocol
]
