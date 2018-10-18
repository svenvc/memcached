"
Unit tests for MDCacheClient
"
Class {
	#name : #MDCacheClientTest,
	#superclass : #MDClientTest,
	#category : #MemcachedTests
}

{ #category : #running }
MDCacheClientTest >> clientClass [ 
	^ MDCacheClient
]

{ #category : #running }
MDCacheClientTest >> serverList [
	^ {'127.0.0.1:11211'}
]

{ #category : #running }
MDCacheClientTest >> testStaleSetGet [
	cache remove: #testStaleSetGet.
	cache set: #testStaleSetGet value: 'test' expires: 3 seconds.
	4 seconds asDelay wait 
	"first guy should get nil, has time to reload cache".
	self assert: (cache get: #testStaleSetGet) isNil 
	"everyone else gets stale value allowing first guy to load from store
	and preventing everyone from piling onto the db at once".
	self assert: (cache get: #testStaleSetGet) equals: 'test'.
	(MDCacheClient defaultStaleTime + 100 milliSeconds) asDelay wait.
	"after object stale time expires, should be nil again"
	self assert: (cache get: #testStaleSetGet) isNil
]
