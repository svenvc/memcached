Class {
	#name : #MDMultilineCommand,
	#superclass : #MDCommand,
	#category : #'Memcached-Commands'
}

{ #category : #private }
MDMultilineCommand >> decodeLine: aByteArray [
	self subclassResponsibility
]

{ #category : #private }
MDMultilineCommand >> executeOnProtocol [
	self writeToProtocol.
	^Array streamContents: [ :stream |
		| response end |
		response := protocol readResponse.
		end := ByteArray with: 69 with: 78 with: 68. "'END' asByteArray"
		[ response = end ] whileFalse: [
			protocol checkServerError: response.
			stream nextPut: (self decodeLine: response).
			response := protocol readResponse ] ]
]
