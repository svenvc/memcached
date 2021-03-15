"
Unit tests for MDInternalCodec
"
Class {
	#name : #MDInternalCodecTest,
	#superclass : #TestCase,
	#instVars : [
		'codec'
	],
	#category : #'Memcached-Tests'
}

{ #category : #running }
MDInternalCodecTest >> setUp [
	codec := MDInternalCodec new
]

{ #category : #testing }
MDInternalCodecTest >> testAsDateTime [
	| dateTime |
	dateTime := codec asDateAndTime: (60 * 60 * 24).
	self assert: dateTime = (DateAndTime year: 1970 month: 1 day: 2 hour: 0 minute: 0 second: 0 offset: (Duration seconds: 0))
]

{ #category : #testing }
MDInternalCodecTest >> testAsDuration [
	| dateTime |
	dateTime := codec asDuration: 60 * 60.
	self assert: dateTime = (Duration hours: 1)
]

{ #category : #testing }
MDInternalCodecTest >> testDecodeAsciiString [
	| string |
	string := codec decodeAsciiString: (ByteArray with: 32 with: 97 with: 98 with: 32) startingAt: 2.
	self assert: string = 'ab'.
	
	string := codec decodeAsciiString: (ByteArray with: 97 with: 98) startingAt: 1.
	self assert: string = 'ab'.
]

{ #category : #testing }
MDInternalCodecTest >> testDecodeInteger [
	| decoded |
	decoded := codec decodeUnsignedInteger: (ByteArray with: 100 with: 48) startingAt: 2.
	self assert: decoded = 0.
	
	decoded := codec decodeUnsignedInteger: (ByteArray withAll: #(52 50 57 52 57 54 55 50 57 54)) startingAt: 1.
	self assert: decoded = (2 raisedTo: 32).
]

{ #category : #testing }
MDInternalCodecTest >> testDecodeSecondsMicroseconds [
	| dateTime |
	dateTime := codec decodeSecondsMilliseconds: (ByteArray with: 53 with: 58 with: 54).
	self assert: dateTime = (codec seconds: 5 microseconds: 6)
]

{ #category : #testing }
MDInternalCodecTest >> testEncodeInteger [
	| encoded |
	encoded := codec encodeIntegerToByteArray: 0.
	self assert: encoded = (ByteArray with: 48).
	encoded := codec encodeIntegerToByteArray: (2 raisedTo: 32).
	self assert: encoded = (ByteArray withAll: #(52 50 57 52 57 54 55 50 57 54))
]

{ #category : #testing }
MDInternalCodecTest >> testFirstNonNumeric [
	| index |
	index := codec firstNonNumericIn: (ByteArray with: 100 with: 100) startingAt: 1.
	self assert: index = 1.
	
	index := codec firstNonNumericIn: (ByteArray with: 100 with: 100) startingAt: 2.
	self assert: index = 2.
	
	index := codec firstNonNumericIn: (ByteArray with: 100 with: 50 with: 100) startingAt: 2.
	self assert: index = 3.
]

{ #category : #testing }
MDInternalCodecTest >> testInvalidArgument [
	self should: [ codec encodeUInt32: -1 ] raise: MDArgumentError.
	self should: [ codec encodeUInt32: (2 raisedTo: 32) ] raise: MDArgumentError.
	self should: [ codec encodeUInt64: -1 ] raise: MDArgumentError.
	self should: [ codec encodeUInt64: (2 raisedTo: 64) ] raise: MDArgumentError.
]

{ #category : #testing }
MDInternalCodecTest >> testSecondsMicroseconds [
	| duration |
	duration := codec seconds: 5 microseconds: 6.
	self assert: duration = (Duration seconds: 5 nanoSeconds: 6000)
]
