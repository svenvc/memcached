Class {
	#name : #MDServerTest,
	#superclass : #TestCase,
	#category : #MemcachedTests
}

{ #category : #private }
MDServerTest >> assertVersion: aString [
	self assert: aString isString.
	self deny: aString isEmpty
]

{ #category : #testing }
MDServerTest >> testServerAddress [
	| server |
	server := MDServer host: #(127 0 0 1) asByteArray port: 11211.
	self versionOfServer: server do: [ :version |
		self assertVersion: version ]
		
]

{ #category : #testing }
MDServerTest >> testServerName [
	| server |
	server := MDServer host: 'localhost' port: 11211.
	self versionOfServer: server do: [ :version |
		self assertVersion: version ]
]

{ #category : #private }
MDServerTest >> versionOfServer: aServer do: aOneArgumentBlock [
	| protocol |
	protocol := aServer openProtocol.
	[ aOneArgumentBlock value: protocol version execute ]
		ensure: [ protocol quit execute ]
]
