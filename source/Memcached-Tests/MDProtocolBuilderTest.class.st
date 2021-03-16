"
Unit tests for MDServer
"
Class {
	#name : #MDProtocolBuilderTest,
	#superclass : #TestCase,
	#category : #'Memcached-Tests'
}

{ #category : #private }
MDProtocolBuilderTest >> assertVersion: aString [

	self 		
		assert: (($. split: aString) first >= '1')
		description: 'This test requires at least version 1.5.0 released in 2017-7-21'.
	self
		assert: (($. split: aString) second >= '5') 
		description: 'This test requires at least version 1.5.0 released in 2017-7-21'
]

{ #category : #testing }
MDProtocolBuilderTest >> testServerAddress [

	| protocol |

	protocol := MDProtocolBuilder new
		host: #(127 0 0 1) asByteArray;
		port: 11211;
		build.

	self
		withVersionOf: protocol
		do: [ :version | self assertVersion: version ]
]

{ #category : #testing }
MDProtocolBuilderTest >> testServerName [
	
	| protocol |
	
	protocol := MDProtocolBuilder new
		host: 'localhost'; 
		port: 11211;
		build.
		
	self withVersionOf: protocol do: [ :version |
		self assertVersion: version ]
]

{ #category : #private }
MDProtocolBuilderTest >> withVersionOf: aProtocol do: aOneArgumentBlock [

	[ aOneArgumentBlock value: aProtocol version execute ]
		ensure: [ aProtocol quit execute ]
]
