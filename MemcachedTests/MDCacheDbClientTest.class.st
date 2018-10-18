"
Unit tests for MDCacheDbClient
"
Class {
	#name : #MDCacheDbClientTest,
	#superclass : #MDClientTest,
	#category : #MemcachedTests
}

{ #category : #running }
MDCacheDbClientTest >> clientClass [ 
	^ MDCacheDbClient 
]

{ #category : #running }
MDCacheDbClientTest >> serverList [
	^ {'127.0.0.1:11211'}
]
