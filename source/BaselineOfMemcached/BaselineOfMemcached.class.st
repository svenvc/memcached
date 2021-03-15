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
		for: #pharo
		do: [ 
			self setUpPackages: spec.
			spec
				group: 'CI' with: 'Tests';
				group: 'Development' with: 'Tests' ]
]

{ #category : #baselines }
BaselineOfMemcached >> setUpPackages: spec [

	spec
		package: 'Memcached';
		group: 'Deployment' with: 'Memcached'.

	spec
		package: 'Memcached-Tests' with: [ spec requires: #('Memcached') ];
		group: 'Tests' with: 'Memcached-Tests'
]
