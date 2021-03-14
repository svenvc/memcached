"
A MDStatistic is a memcached server statistic.

Instance Variables
	bytesRead:		<Integer>
	bytesUsed:		<Integer>
	bytesWritten:		<Integer>
	connectionStructures:	<Integer>
	currentConnections:		<Integer>
	currentItems:		<Integer>
	evictions:		<Integer>
	hits:		<Integer>
	maximumBytes:		<Integer>
	misses:		<Integer>
	pointerSize: 		<Integer>
	processId:		<Integer>
	retrievalRequests:		<Integer>
	storageRequests:		<Integer>
	systemTime:		<Duration>
	time:		<DateAndTime>
	toatlConnections:		<Integer>
	totalItems:		<Integer>
	uptime:		<Duration>
	userTime:		<Duration>
	version:		<String>

bytesRead
	- Total number of bytes read by this server from network

bytesUsed
	- Current number of bytes used by this server to store items

bytesWritten
	- Total number of bytes sent by this server to network

connectionStructures
	- Number of connection structures allocated by the server
	
currentConnections
	- Number of open connections

currentItems
	- Current number of items stored by the server

evictions
	- Number of valid items removed from cache to free memory for new items

hits
	- Number of keys that have been requested and found present

maximumBytes
	- Number of bytes this server is allowed to use for storage. 

misses
	- Number of items that have been requested and not found
	
pointerSize
	- pointer size in bits

processId
	- Process id of this server process

retrievalRequests
	- Cumulative number of retrieval requests

storageRequests
	- Cumulative number of storage requests

systemTime
	- Accumulated system time for this process
	
totalConnections
	- Total number of connections opened since the server started running

time
	- current UNIX time according to the server

totalItems
	- Total number of items stored by this server ever since it started

uptime
	- Number of seconds this server has been running

userTime
	- Accumulated user time for this process

version
	- Version string of this server

"
Class {
	#name : #MDStatistic,
	#superclass : #Object,
	#instVars : [
		'processId',
		'uptime',
		'time',
		'version',
		'userTime',
		'systemTime',
		'totalItems',
		'currentItems',
		'bytesUsed',
		'currentConnections',
		'totalConnections',
		'connectionStructures',
		'retrievalRequests',
		'storageRequests',
		'hits',
		'misses',
		'evictions',
		'bytesRead',
		'bytesWritten',
		'maximumBytes',
		'pointerSize'
	],
	#category : #'Memcached-Core'
}

{ #category : #accessing }
MDStatistic >> bytesRead [
	^bytesRead
]

{ #category : #accessing }
MDStatistic >> bytesRead: anInteger [ 
	bytesRead := anInteger
]

{ #category : #accessing }
MDStatistic >> bytesUsed [
	^bytesUsed
]

{ #category : #accessing }
MDStatistic >> bytesUsed: anInteger [ 
	bytesUsed := anInteger
]

{ #category : #accessing }
MDStatistic >> bytesWritten [
	^bytesWritten
]

{ #category : #accessing }
MDStatistic >> bytesWritten: anInteger [ 
	bytesWritten := anInteger
]

{ #category : #accessing }
MDStatistic >> connectionStructures [
	^connectionStructures
]

{ #category : #accessing }
MDStatistic >> connectionStructures: anInteger [ 
	connectionStructures := anInteger
]

{ #category : #accessing }
MDStatistic >> currentConnections [
	^currentConnections
]

{ #category : #accessing }
MDStatistic >> currentConnections: anInteger [ 
	currentConnections := anInteger
]

{ #category : #accessing }
MDStatistic >> currentItems [
	^currentItems
]

{ #category : #accessing }
MDStatistic >> currentItems: anInteger [ 
	currentItems := anInteger
]

{ #category : #accessing }
MDStatistic >> evictions [
	^evictions
]

{ #category : #accessing }
MDStatistic >> evictions: anInteger [ 
	evictions := anInteger
]

{ #category : #accessing }
MDStatistic >> hits [
	^hits
]

{ #category : #accessing }
MDStatistic >> hits: anInteger [ 
	hits := anInteger
]

{ #category : #accessing }
MDStatistic >> maximumBytes [
	^maximumBytes
]

{ #category : #accessing }
MDStatistic >> maximumBytes: anInteger [ 
	maximumBytes := anInteger
]

{ #category : #accessing }
MDStatistic >> misses [
	^misses
]

{ #category : #accessing }
MDStatistic >> misses: anInteger [ 
	misses := anInteger
]

{ #category : #accessing }
MDStatistic >> pointerSize [
	^pointerSize
]

{ #category : #accessing }
MDStatistic >> pointerSize: anInteger [ 
	pointerSize := anInteger
]

{ #category : #accessing }
MDStatistic >> processId [
	^processId
]

{ #category : #accessing }
MDStatistic >> processId: anInteger [ 
	processId := anInteger
]

{ #category : #accessing }
MDStatistic >> retrievalRequests [
	^retrievalRequests
]

{ #category : #accessing }
MDStatistic >> retrievalRequests: anInteger [ 
	retrievalRequests := anInteger
]

{ #category : #accessing }
MDStatistic >> storageRequests [
	^storageRequests
]

{ #category : #accessing }
MDStatistic >> storageRequests: anInteger [ 
	storageRequests := anInteger
]

{ #category : #accessing }
MDStatistic >> systemTime [
	^systemTime
]

{ #category : #accessing }
MDStatistic >> systemTime: aDuration [ 
	systemTime := aDuration
]

{ #category : #accessing }
MDStatistic >> time [
	^time
]

{ #category : #accessing }
MDStatistic >> time: aDateAndTime [ 
	time := aDateAndTime
]

{ #category : #accessing }
MDStatistic >> totalConnections [
	^totalConnections
]

{ #category : #accessing }
MDStatistic >> totalConnections: anInteger [ 
	totalConnections := anInteger
]

{ #category : #accessing }
MDStatistic >> totalItems [
	^totalItems
]

{ #category : #accessing }
MDStatistic >> totalItems: anInteger [ 
	totalItems := anInteger
]

{ #category : #accessing }
MDStatistic >> uptime [
	^uptime
]

{ #category : #accessing }
MDStatistic >> uptime: aDuration [ 
	uptime := aDuration
]

{ #category : #accessing }
MDStatistic >> userTime [
	^userTime
]

{ #category : #accessing }
MDStatistic >> userTime: aDuration [ 
	userTime := aDuration
]

{ #category : #accessing }
MDStatistic >> version [
	^version
]

{ #category : #accessing }
MDStatistic >> version: aString [ 
	version := aString
]
