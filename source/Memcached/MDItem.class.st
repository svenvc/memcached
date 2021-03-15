"
MDItem holds information about a single key: it value (data) and flags
"
Class {
	#name : #MDItem,
	#superclass : #Object,
	#instVars : [
		'key',
		'flags',
		'data'
	],
	#category : #'Memcached-Commands'
}

{ #category : #'instance creation' }
MDItem class >> key: aString flags: anInteger data: aByteArray [
	^self new
		initializeWithKey: aString flags: anInteger data: aByteArray
]

{ #category : #accessing }
MDItem >> data [
	^data
]

{ #category : #accessing }
MDItem >> flags [
	^flags
]

{ #category : #'initialize-release' }
MDItem >> initializeWithKey: aString flags: anInteger data: aByteArray [
	key := aString.
	flags := anInteger.
	data := aByteArray.
]

{ #category : #accessing }
MDItem >> key [
	^key
]
