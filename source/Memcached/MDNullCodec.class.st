"
I am the Null codec
"
Class {
	#name : #MDNullCodec,
	#superclass : #Object,
	#category : #'Memcached-Core'
}

{ #category : #decoding }
MDNullCodec >> decodeFloat: aByteArray [
	^Float fromIEEE32Bit: aByteArray
]

{ #category : #decoding }
MDNullCodec >> decodeObject: bytes [
	Smalltalk 
		at: #FLMaterializer 
		ifPresent: [ :fuelMaterializer | 
			^ fuelMaterializer materializeFromByteArray: bytes ].
	Smalltalk 
		at: #ReferenceStream
		ifPresent: [ :referenceStream | 
			^ referenceStream unStream: bytes ].
	self error: 'No materializer found'	
]

{ #category : #decoding }
MDNullCodec >> decodeString: aByteArray [
	^aByteArray asString
]

{ #category : #encoding }
MDNullCodec >> encodeFloat: aFloat [
	^aFloat asIEEE32BitWord
]

{ #category : #encoding }
MDNullCodec >> encodeInteger: anInteger [
	"high bytes come first"
	| remaining stream |
	remaining := anInteger.
	"#byteSize"
	stream := WriteStream on: (ByteArray new: 8).
	[| next |
	next := remaining bitAnd: 16rFF.
	remaining := remaining bitShift: -8.
	(remaining > 0 and: [ remaining ~= -1 ])
		ifTrue: [
			stream nextPut: next.
			true ]
		ifFalse: [
			next > 16r7F
				ifTrue: [
					remaining = -1
						ifTrue: [
							stream nextPut: next ]
						ifFalse: [
							stream nextPut: (next bitAnd: 16r7F).
							stream nextPut: 16r01 ] ]
				ifFalse: [
					remaining = -1
						ifTrue: [
							stream nextPut: next.
							stream nextPut: 16rFF  ]
						ifFalse: [
							stream nextPut: next ] ].
			false ] ] whileTrue.
	^stream contents reversed
]

{ #category : #decoding }
MDNullCodec >> encodeObject: object [
	Smalltalk 
		at: #FLSerializer 
		ifPresent: [ :fuelSerializer | 
			^ fuelSerializer serializeToByteArray: object ].
	Smalltalk 
		at: #ReferenceStream
		ifPresent: [ :referenceStream | 
			^ referenceStream streamedRepresentationOf: object ].
	self error: 'No serializer found'
]

{ #category : #encoding }
MDNullCodec >> encodeString: aString [
	^aString asByteArray
]
