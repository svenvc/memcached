"
A MDDeleteCommand is a command which deletes an item on the server.

Instance Variables
	key:	<String>
	time:	<ByteArray>


key
	- is the key of the item the client wishes the server to delete
	
time
	- is the amount of time in seconds (or Unix time until which)
	the client wishes the server to refuse ""add"" and ""replace"" commands
	with this key. For this amount of item, the item is put into a
	delete queue, which means that it won't possible to retrieve it by
	the ""get"" command, but ""add"" and ""replace"" command with this key
	will also fail (the ""set"" command will succeed, however). After the
	time passes, the item is finally deleted from server memory.

	The parameter <time> is optional, and, if absent, defaults to 0
	(which means that the item will be deleted immediately and further
	storage commands with this key will succeed).

"
Class {
	#name : #MDDeleteCommand,
	#superclass : #MDCommand,
	#instVars : [
		'key',
		'time'
	],
	#category : #'Memcached-Commands'
}

{ #category : #private }
MDDeleteCommand >> decodeResponse: aByteArray [
	super decodeResponse: aByteArray.
	(aByteArray = (ByteArray withAll: #(68 69 76 69 84 69 68))) "'DELETED' asByteArray"
		ifTrue: [ ^true ].
	(aByteArray = (ByteArray withAll: #(78 79 84 95 70 79 85 78 68))) "'NOT_FOUND' asByteArray"
		ifTrue: [ ^false ].
	protocol protocolError
]

{ #category : #accessing }
MDDeleteCommand >> key: aString [ 
	key := aString
]

{ #category : #private }
MDDeleteCommand >> setProtocol: aProtocol [
	super setProtocol: aProtocol.
	time := (ByteArray with: 0)
]

{ #category : #private }
MDDeleteCommand >> writeToProtocol [
	"delete <key> <time>\r\n"
	protocol nextPutAll: #[100 101 108 101 116 101]. "'delete' asByteArray"
	protocol space.
	protocol nextPutAll: key.
	protocol space.
	protocol nextPutAll: time.
	protocol endCommand
]
