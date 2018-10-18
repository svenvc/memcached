"
I am BaselineOfMemcached, I load the code for the Pharo client to Memcached, a distributed memory caching system.
I am a BaselineOf.
"
Class {
	#name : #BaselineOfMemcached,
	#superclass : #BaselineOf,
	#category : #BaselineOfMemcached
}

{ #category : #baselines }
BaselineOfMemcached >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			spec package: 'Memcached'.
			spec package: 'MemcachedTests' with: [ spec requires: #('Memcached') ] ]
]
