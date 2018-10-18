Class {
	#name : #MDInternalCodec,
	#superclass : #Object,
	#category : #'Memcached-Core'
}

{ #category : #private }
MDInternalCodec >> argumentError: aString [
	MDArgumentError signal: aString
]

{ #category : #converting }
MDInternalCodec >> asDateAndTime: anInteger [
	^(DateAndTime year: 1970 month: 1 day: 1 hour: 0 minute: 0 second: 0 offset: (Duration seconds: 0)) + (Duration seconds: anInteger)
]

{ #category : #converting }
MDInternalCodec >> asDuration: anInteger [
	^Duration seconds: anInteger
]

{ #category : #decoding }
MDInternalCodec >> decodeAsciiString: aByteArray [
	^self decodeAsciiString: aByteArray startingAt: 1
]

{ #category : #decoding }
MDInternalCodec >> decodeAsciiString: aByteArray startingAt: anInteger [
	| buffer totalSize |
	totalSize := aByteArray size.
	buffer := WriteStream on: (String new: totalSize - anInteger).
	anInteger to: totalSize do: [ :index |
		| value |
		value := aByteArray at: index.
		value = 32 "space"
			ifTrue: [ ^buffer contents ].
		buffer nextPut: (Character value: value) ].
	^buffer contents
]

{ #category : #decoding }
MDInternalCodec >> decodeSecondsMilliseconds: aByteArray [
	| split |
	split := self firstNonNumericIn: aByteArray startingAt: 1.
	^self
		seconds: (self decodeUnsignedInteger: (aByteArray first: split - 1))
		microseconds: (self decodeUnsignedInteger: aByteArray startingAt: split + 1)
]

{ #category : #decoding }
MDInternalCodec >> decodeUnsignedInteger: aByteArray [
	^self decodeUnsignedInteger: aByteArray startingAt: 1
]

{ #category : #decoding }
MDInternalCodec >> decodeUnsignedInteger: aByteArray startingAt: anInteger [
	| buffer totalSize |
	totalSize := aByteArray size.
	buffer := 0.
	anInteger to: totalSize do: [ :index |
		| value |
		value := aByteArray at: index.
		value = 32 "space"
			ifTrue: [ ^buffer ].
		buffer := (buffer * 10) + (value - 48) ].
	^buffer
]

{ #category : #encoding }
MDInternalCodec >> encodeIntegerToByteArray: anInteger [
	| decimal bytes |
	decimal := anInteger printStringBase: 10.
	bytes := ByteArray new: decimal size.
	1 to: decimal size do: [ :index |
		bytes at: index put: (decimal at: index) asciiValue ].
	^bytes
]

{ #category : #encoding }
MDInternalCodec >> encodeUInt32: anInteger [
	anInteger < 0
		ifTrue: [ self argumentError: 'can only encode positive integers' ].
	anInteger >  16rFFFFFFFF
		ifTrue: [ self argumentError: 'can only encode integers smallte than: ', 16r100000000 printString ].
	^self encodeIntegerToByteArray: anInteger
]

{ #category : #encoding }
MDInternalCodec >> encodeUInt64: anInteger [
	anInteger < 0
		ifTrue: [ self argumentError: 'can only encode positive integers' ].
	anInteger >  16rFFFFFFFFFFFFFFFF
		ifTrue: [ self argumentError: 'can only encode integers smallte than: ', 16r10000000000000000 printString ].
	^self encodeIntegerToByteArray: anInteger
]

{ #category : #decoding }
MDInternalCodec >> firstNonNumericIn: aByteArray startingAt: anInteger [
	| index each |
	index := anInteger.
	each := aByteArray at: index.
	[ each >= 48 and: [ each <= 57 ] ] whileTrue: [
		index := index + 1.
		each := aByteArray at: index.
	].
	^index
]

{ #category : #converting }
MDInternalCodec >> seconds: secondsInteger [
	^self seconds: secondsInteger microseconds: 0
]

{ #category : #converting }
MDInternalCodec >> seconds: secondsInteger microseconds: microsecondsInteger [
	^Duration seconds: secondsInteger nanoSeconds: 1000 * microsecondsInteger
]
