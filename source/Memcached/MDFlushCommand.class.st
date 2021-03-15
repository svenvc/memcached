"
""flush_all"" is a command with an optional numeric argument. It always
succeeds, and the server sends ""OK\r\n"" in response. Its effect is to
invalidate all existing items immediately (by default) or after the
expiration specified.  After invalidation none of the items will be returned
in response to a retrieval command (unless it's stored again under the
same key *after* flush_all has invalidated the items). flush_all doesn't
actually free all the memory taken up by existing items; that will
happen gradually as new items are stored. The most precise definition
of what flush_all does is the following: it causes all items whose
update time is earlier than the time at which flush_all was set to be
executed to be ignored for retrieval purposes.

The intent of flush_all with a delay, was that in a setting where you
have a pool of memcached servers, and you need to flush all content,
you have the option of not resetting all memcached servers at the
same time (which could e.g. cause a spike in database load with all
clients suddenly needing to recreate content that would otherwise
have been found in the memcached daemon).

The delay option allows you to have them reset in e.g. 10 second
intervals (by passing 0 to the first, 10 to the second, 20 to the
third, etc. etc.).
"
Class {
	#name : #MDFlushCommand,
	#superclass : #MDCommand,
	#instVars : [
		'delay'
	],
	#category : #'Memcached-Commands'
}

{ #category : #private }
MDFlushCommand >> decodeResponse: aByteArray [
	super decodeResponse: aByteArray.
	aByteArray = (ByteArray with: 79 with: 75)"'OK' asByteArray"
		ifFalse: [ protocol protocolError ].
	^true
]

{ #category : #accessing }
MDFlushCommand >> delay: aByteArray [ 
	delay := aByteArray
]

{ #category : #private }
MDFlushCommand >> setProtocol: aProtocol [
	super setProtocol: aProtocol.
	delay := ByteArray with: 48 "$0 asciiValue"
]

{ #category : #private }
MDFlushCommand >> writeToProtocol [
	protocol nextPutAll: #[102 108 117 115 104 95 97 108 108]. "'flush_all' asByteArray"
	protocol endCommand
]
