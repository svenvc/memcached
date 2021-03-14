"
A MDStatisticsCommand is a command that queries statistics from the server.

Instance Variables
	arguments:		<Collection>

arguments
	- xxxxx
The command ""stats"" is used to query the server about statistics it
maintains and other internal data. It has two forms. Without
arguments:

stats\r\n

it causes the server to output general-purpose statistics and
settings, documented below.  In the other form it has some arguments:

stats <args>\r\n

Depending on <args>, various internal data is sent by the server. The
kinds of arguments and the data sent are not documented in this vesion
of the protocol, and are subject to change for the convenience of
memcache developers.


General-purpose statistics
--------------------------

Upon receiving the ""stats"" command without arguments, the server sents
a number of lines which look like this:

STAT <name> <value>\r\n

The server terminates this list with the line

END\r\n

In each line of statistics, <name> is the name of this statistic, and
<value> is the data.  The following is the list of all names sent in
response to the ""stats"" command, together with the type of the value
sent for this name, and the meaning of the value.

In the type column below, ""32u"" means a 32-bit unsigned integer, ""64u""
means a 64-bit unsigner integer. '32u:32u' means two 32-but unsigned
integers separated by a colon.


Name              Type     Meaning
----------------------------------
pid               32u      Process id of this server process
uptime            32u      Number of seconds this server has been running
time              32u      current UNIX time according to the server
version           string   Version string of this server
rusage_user       32u:32u  Accumulated user time for this process 
                           (seconds:microseconds)
rusage_system     32u:32u  Accumulated system time for this process 
                           (seconds:microseconds)
curr_items        32u      Current number of items stored by the server
total_items       32u      Total number of items stored by this server 
                           ever since it started
bytes             64u      Current number of bytes used by this server 
                           to store items
curr_connections  32u      Number of open connections
total_connections 32u      Total number of connections opened since 
                           the server started running
connection_structures 32u  Number of connection structures allocated 
                           by the server
cmd_get           64u      Cumulative number of retrieval requests
cmd_set           64u      Cumulative number of storage requests
get_hits          64u      Number of keys that have been requested and 
                           found present
get_misses        64u      Number of items that have been requested 
                           and not found
evictions         64u      Number of valid items removed from cache                                                                           
                           to free memory for new items                                                                                       
bytes_read        64u      Total number of bytes read by this server 
                           from network
bytes_written     64u      Total number of bytes sent by this server to 
                           network
limit_maxbytes    32u      Number of bytes this server is allowed to
                           use for storage. 
"
Class {
	#name : #MDStatisticsCommand,
	#superclass : #MDMultilineCommand,
	#instVars : [
		'arguments'
	],
	#category : #'Memcached-Commands'
}

{ #category : #accessing }
MDStatisticsCommand >> arguments: aByteArray [ 
	arguments := aByteArray
]

{ #category : #private }
MDStatisticsCommand >> decodeLine: aByteArray [
	| name value size |
	(aByteArray beginsWith: (ByteArray withAll: #(83 84 65 84))) "'STAT' asByteArray"
		ifFalse: [ protocol protocolError ].
	name := protocol codec decodeAsciiString: aByteArray startingAt: 6.
	size := aByteArray size.
	value := aByteArray copyFrom: name size + 7 to: size.
	^Array with: name with: value
]

{ #category : #private }
MDStatisticsCommand >> decodeResponse: anArray [
	"nothing to do, already done"
	| stats codec processId uptime time version userTime systemTime currentItems totalItems bytesUsed currentConnections totalConnections connectionStructures retrievalRequests storageRequests hits misses evictions bytesRead bytesWritten maximumBytes zero pointerSize |
	stats := Dictionary new.
	codec := protocol codec.
	anArray do: [ :each | stats at: (each at: 1) put: (each at: 2) ].
	zero := ByteArray with: 48.
	processId := codec decodeUnsignedInteger: (stats at: 'pid').
	uptime := codec seconds: (codec decodeUnsignedInteger: (stats at: 'uptime')).
	time := codec asDateAndTime: (codec decodeUnsignedInteger: (stats at: 'time')).
	version := codec decodeAsciiString: (stats at: 'version').
	userTime := codec decodeSecondsMilliseconds: (stats at: 'rusage_user').
	systemTime := codec decodeSecondsMilliseconds: (stats at: 'rusage_system').
	currentItems := codec decodeUnsignedInteger: (stats at: 'curr_items').
	totalItems := codec decodeUnsignedInteger: (stats at: 'total_items').
	bytesUsed := codec decodeUnsignedInteger: (stats at: 'bytes').
	currentConnections := codec decodeUnsignedInteger: (stats at: 'curr_connections').
	totalConnections := codec decodeUnsignedInteger: (stats at: 'total_connections').
	connectionStructures := codec decodeUnsignedInteger: (stats at: 'connection_structures').
	retrievalRequests := codec decodeUnsignedInteger: (stats at: 'cmd_get').
	storageRequests := codec decodeUnsignedInteger: (stats at: 'cmd_set').
	hits := codec decodeUnsignedInteger: (stats at: 'get_hits').
	misses := codec decodeUnsignedInteger: (stats at: 'get_misses').
	evictions := codec decodeUnsignedInteger: (stats at: 'evictions' ifAbsent: [ zero ]).
	bytesRead := codec decodeUnsignedInteger: (stats at: 'bytes_read').
	bytesWritten := codec decodeUnsignedInteger: (stats at: 'bytes_written').
	maximumBytes := codec decodeUnsignedInteger: (stats at: 'limit_maxbytes').
	pointerSize := codec decodeUnsignedInteger: (stats at: 'pointer_size' ifAbsent: [ zero ]).
	
	^ MDStatistic new
		processId: processId;
		uptime: uptime;
		time: time;
		version: version;
		userTime: userTime;
		systemTime: systemTime;
		currentItems: currentItems;
		totalItems: totalItems;
		bytesUsed: bytesUsed;
		currentConnections: currentConnections;
		totalConnections: totalConnections;
		connectionStructures: connectionStructures;
		retrievalRequests: retrievalRequests;
		storageRequests: storageRequests;
		hits: hits;
		misses: misses;
		evictions: evictions;
		bytesRead: bytesRead;
		bytesWritten: bytesWritten;
		maximumBytes: maximumBytes;
		pointerSize: pointerSize;
		yourself
]

{ #category : #private }
MDStatisticsCommand >> writeToProtocol [
	protocol nextPutAll: #[115 116 97 116 115]. "'stats' asByteArray"
	arguments isNil ifFalse: [
		protocol space.
		protocol nextPutAll: arguments ].
	protocol endCommand
]
