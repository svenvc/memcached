"
I am the UTF8 codec
"
Class {
	#name : #MDUtf8Codec,
	#superclass : #MDNullCodec,
	#classVars : [
		'Latin1ToUtf8Encodings',
		'Latin1ToUtf8Map'
	],
	#category : #'Memcached-Core'
}

{ #category : #'class initialization' }
MDUtf8Codec class >> initialize [
	"MDUtf8Coded initialize"
	| latin1 utf8 |
	Latin1ToUtf8Map := ByteArray new: 256.
	Latin1ToUtf8Encodings := Array new: 256.
	0 to: 255 do:[ :index |
		latin1 := String with: (Character value: index).
		utf8 := latin1 convertToEncoding: #utf8.
		latin1 = utf8
			ifTrue: [
				Latin1ToUtf8Map at: index + 1 put: 0 ] "no translation needed"
			ifFalse: [
				Latin1ToUtf8Map at: index + 1 put: 1. "no translation needed"
				Latin1ToUtf8Encodings at: index + 1 put: utf8 ] ]
]

{ #category : #private }
MDUtf8Codec >> invalidUtf8 [
	MDArgumentError signal: 'Invalid UTF-8 input'
]

{ #category : #private }
MDUtf8Codec >> latin1ToUtf8: aByteString [
	"Convert the given string from UTF-8 using the fast path if converting to Latin-1"
	| outStream lastIndex nextIndex |
	lastIndex := 1.
	nextIndex := ByteString findFirstInString: aByteString inSet: Latin1ToUtf8Map startingAt: lastIndex.
	nextIndex = 0 ifTrue:[ ^aByteString ].
	outStream := (String new: aByteString size * 2) writeStream.
	[	outStream next: nextIndex - lastIndex putAll: aByteString startingAt: lastIndex.
		outStream nextPutAll: (Latin1ToUtf8Encodings at: (aByteString byteAt: nextIndex) + 1).
		lastIndex := nextIndex + 1.
		nextIndex := ByteString findFirstInString: aByteString inSet: Latin1ToUtf8Map startingAt: lastIndex.
		nextIndex = 0 ] whileFalse.
	outStream next: aByteString size - lastIndex + 1 putAll: aByteString startingAt: lastIndex.
	^outStream contents
]

{ #category : #encoding }
MDUtf8Codec >> toUtf8: aString [
	^aString isByteString
		ifTrue: [ self latin1ToUtf8: aString ]
		ifFalse: [ aString convertToEncoding: #utf8 ]
]

{ #category : #decoding }
MDUtf8Codec >> utf8ToLatin1: aByteString [
	"Convert the given string from UTF-8 using the fast path if converting to Latin-1"
	| outStream lastIndex nextIndex byte1 byte2 byte3 byte4 unicode |
	lastIndex := 1.
	nextIndex := ByteString findFirstInString: aByteString inSet: Latin1ToUtf8Map startingAt: lastIndex.
	nextIndex = 0 ifTrue:[ ^aByteString ].
	outStream := (String new: aByteString size) writeStream.
		[outStream next: nextIndex-lastIndex putAll: aByteString startingAt: lastIndex.
		byte1 := aByteString byteAt: nextIndex.
		(byte1 bitAnd: 16rE0) = 192 ifTrue: [ "two bytes"
			byte2 := aByteString byteAt: (nextIndex := nextIndex+1).
			(byte2 bitAnd: 16rC0) = 16r80 ifFalse:[ self invalidUtf8 ].
			unicode := ((byte1 bitAnd: 31) bitShift: 6) + (byte2 bitAnd: 63)].
		(byte1 bitAnd: 16rF0) = 224 ifTrue: [ "three bytes"
			byte2 := aByteString byteAt: (nextIndex := nextIndex+1).
			(byte2 bitAnd: 16rC0) = 16r80 ifFalse:[ self invalidUtf8 ].
			byte3 := aByteString byteAt: (nextIndex := nextIndex+1).
			(byte3 bitAnd: 16rC0) = 16r80 ifFalse:[ self invalidUtf8 ].
			unicode := ((byte1 bitAnd: 15) bitShift: 12) + ((byte2 bitAnd: 63) bitShift: 6)
				+ (byte3 bitAnd: 63)].
		(byte1 bitAnd: 16rF8) = 240 ifTrue: [ "four bytes"
			byte2 := aByteString byteAt: (nextIndex := nextIndex+1).
			(byte2 bitAnd: 16rC0) = 16r80 ifFalse:[ self invalidUtf8 ].
			byte3 := aByteString byteAt: (nextIndex := nextIndex+1).
			(byte3 bitAnd: 16rC0) = 16r80 ifFalse:[ self invalidUtf8 ].
			byte4 := aByteString byteAt: (nextIndex := nextIndex+1).
			(byte4 bitAnd: 16rC0) = 16r80 ifFalse:[ self invalidUtf8 ].
			unicode := ((byte1 bitAnd: 16r7) bitShift: 18) +
							((byte2 bitAnd: 63) bitShift: 12) + 
							((byte3 bitAnd: 63) bitShift: 6) +
							(byte4 bitAnd: 63)].
		unicode ifNil:[ self invalidUtf8 ].
		outStream nextPut: (Character value: unicode).
		lastIndex := nextIndex + 1.
		nextIndex := ByteString findFirstInString: aByteString inSet: Latin1ToUtf8Map startingAt: lastIndex.
		nextIndex = 0 ] whileFalse.
	outStream next: aByteString size - lastIndex + 1 putAll: aByteString startingAt: lastIndex.
	^outStream contents
]
