# Installation

## Provided groups

- `Deployment` will load all the packages needed in a deployed application 
- `Tests` will load the test cases
- `CI` is the group loaded in the continuous integration setup
- `Development` will load all the needed packages to develop and contribute to the project (basically Deployment + Tests)

## Basic Installation

You can load **Memcached** evaluating:
```smalltalk
Metacello new
	baseline: 'Memcached';
	repository: 'github://fortizpenaloza/Memcached:master';
	load.
```
>  Change `master` to some released version if you want a pinned version

## Using as dependency

In order to include **Memcached** as part of your project, you should reference the package in your product baseline:

```smalltalk
setUpDependencies: spec

	spec
		baseline: 'Memcached'
			with: [ spec
				repository: 'github://fortizpenaloza/Memcached:v{XX}';
				loads: #('Deployment') ];
		import: 'Memcached'.
```
> Replace `{XX}` with the version you want to depend on

```smalltalk
baseline: spec

	<baseline>
	spec
		for: #common
		do: [ self setUpDependencies: spec.
			spec package: 'My-Package' with: [ spec requires: #('Memcached') ] ]
```
