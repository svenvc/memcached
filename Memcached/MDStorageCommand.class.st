"
A MDStorageCommand is a command that stores data on the server.

Instance Variables
	name:		<String>
	key:		<String>
	flags:		<SmallInteger>
	expiration:	<Integer>
	data:		<ByteArray>
	bytes:		<ByteArray>


name
	- 'set', 'add' or 'replace'
	  ""set"" means ""store this data"".  

	  ""add"" means ""store this data, but only if the server *doesn't* already
	  hold data for this key"".  

	  ""replace"" means ""store this data, but only if the server *does*
	  already hold data for this key"".

key
	- the key under which the client asks to store the data. A key
	is a text string which should uniquely identify the data for clients
	that are interested in storing and retrieving it.  Currently the
	length limit of a key is set at 250 characters (of course, normally
	clients wouldn't need to use such long keys); the key must not include
	control characters or whitespace.

flags
	- an arbitrary 16-bit unsigned integer (written out in
	decimal) that the server stores along with the data and sends back
	 when the item is retrieved. Clients may use this as a bit field to
	store data-specific information; this field is opaque to the server.
	Note that in memcached 1.2.1 and higher, flags may be 32-bits, instead
	of 16, but you might want to restrict yourself to 16 bits for
	compatibility with older versions.

expirationTime
	- expiration time. If it's 0, the item never expires
	(although it may be deleted from the cache to make place for other
	items). If it's non-zero (either Unix time or offset in seconds from
	current time), it is guaranteed that clients will not be able to
	retrieve this item after the expiration time arrives (measured by
	server time). 

data
	- is a chunk of arbitrary 8-bit data
	
bytes
	 - is the number of bytes in the data block to follow, *not*
	including the delimiting \r\n. <bytes> may be zero (in which case
	it's followed by an empty data block).
"
Class {
	#name : #MDStorageCommand,
	#superclass : #MDCommand,
	#instVars : [
		'name',
		'key',
		'flags',
		'expiration',
		'data',
		'bytes'
	],
	#category : #'Memcached-Commands'
}

{ #category : #actions }
MDStorageCommand >> add [
	name :=  #[97 100 100] "'add' asByteArray"
]

{ #category : #private }
MDStorageCommand >> argumentError: aString [
	MDArgumentError signal: aString
]

{ #category : #private }
MDStorageCommand >> data: aByteArray [
	aByteArray size > 16r100000
		ifTrue: [ self argumentError: 'can not store more than 1 MiB' ].
	data := aByteArray.
	bytes := protocol codec encodeIntegerToByteArray: aByteArray size
]

{ #category : #private }
MDStorageCommand >> decodeResponse: aByteArray [
	super decodeResponse: aByteArray.
	(aByteArray = (ByteArray withAll: #(83 84 79 82 69 68))) "'STORED' asByteArray"
		ifTrue: [ ^true ].
	(aByteArray = (ByteArray withAll: #(78 79 84 95 83 84 79 82 69 68))) "'NOT_STORED' asByteArray"
		ifTrue: [ ^false ].
	protocol protocolError
]

{ #category : #accessing }
MDStorageCommand >> expiration [
	^expiration
]

{ #category : #accessing }
MDStorageCommand >> expiration: anInteger [ 
	expiration := anInteger
]

{ #category : #accessing }
MDStorageCommand >> flags: anInteger [ 
	flags := anInteger
]

{ #category : #accessing }
MDStorageCommand >> key: anInteger [ 
	key := anInteger
]

{ #category : #actions }
MDStorageCommand >> replace [
	name :=  #[114 101 112 108 97 99 101] "'replace' asByteArray"
]

{ #category : #actions }
MDStorageCommand >> set [
	name :=  ByteArray with: 115 with: 101 with: 116 "'set' asByteArray"
]

{ #category : #private }
MDStorageCommand >> setProtocol: aProtocol [
	super setProtocol: aProtocol.
	expiration := ByteArray with: 48. "$0 asciiValue"
	flags := ByteArray with: 48.  "$0 asciiValue"
	data := ByteArray new
]

{ #category : #private }
MDStorageCommand >> writeToProtocol [
	"<command name> <key> <flags> <exptime> <bytes>\r\n"
	protocol nextPutAll: name.
	protocol space.
	protocol nextPutAll: key.
	protocol space.
	protocol nextPutAll: flags.	
	protocol space.
	protocol nextPutAll: expiration.
	protocol space.
	protocol nextPutAll: bytes.
	protocol crlf.
	"<data block>\r\n"
	protocol nextPutAll: data.
	protocol endCommand
]
