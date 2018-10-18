"
A MDDecrementCommand is a command that decrements a variable on the server.

Note that underflow in the ""decr"" command is caught: if a client tries
to decrease the value below 0, the new value will be 0.

Note also that decrementing a number such that it loses length isn't
guaranteed to decrement its returned length.  The number MAY be
space-padded at the end, but this is purely an implementation
optimization, so you also shouldn't rely on that.
"
Class {
	#name : #MDDecrementCommand,
	#superclass : #MDCountCommand,
	#category : #'Memcached-Commands'
}

{ #category : #private }
MDDecrementCommand >> writeToProtocol [
	"decr <key> <value>\r\n"
	protocol nextPutAll: #[100 101 99 114]. "decr' asByteArray"
	super writeToProtocol
]
