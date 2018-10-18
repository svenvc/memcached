Class {
	#name : #MDServer,
	#superclass : #Object,
	#instVars : [
		'host',
		'port'
	],
	#category : #'Memcached-Core'
}

{ #category : #'instance creation' }
MDServer class >> default [
	^self new
		host: self defaultHost;
		port: self defaultPort;
		yourself
]

{ #category : #'accessing-defaults' }
MDServer class >> defaultHost [
	^#(127 0 0 1) asByteArray
]

{ #category : #'accessing-defaults' }
MDServer class >> defaultPort [
	^11211
]

{ #category : #'instance creation' }
MDServer class >> host: aStringOrByteArray [
	^self new
		host: aStringOrByteArray;
		port: self defaultPort;
		yourself
]

{ #category : #'instance creation' }
MDServer class >> host: aStringOrByteArray port: anInteger [
	^self new
		host: aStringOrByteArray;
		port: anInteger;
		yourself
]

{ #category : #'instance creation' }
MDServer class >> port: anInteger [
	^self new
		host: self defaultHost;
		port: anInteger;
		yourself
]

{ #category : #accessing }
MDServer >> host [
	^host
]

{ #category : #accessing }
MDServer >> host: aStringOrByteArray [
	"aStringOrByteArray can either be a String with the hostname or a ByteArray with the host address"
	host := aStringOrByteArray
]

{ #category : #actions }
MDServer >> openProtocol [
	| stream |
	stream := self host isString
		ifTrue: [ SocketStream openConnectionToHostNamed: self host port: self port ]
		ifFalse: [ SocketStream openConnectionToHost: self host port: self port ].
	^MDProtocol on: stream
]

{ #category : #accessing }
MDServer >> port [
	^port
]

{ #category : #accessing }
MDServer >> port: anObject [
	port := anObject
]
