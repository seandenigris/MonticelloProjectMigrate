command
executeBitbucket

	| goferSource sourceVersionsByDate versionsToCopy |
	goferSource := Gofer new repository: self source.
	sourceVersionsByDate := source allVersionInfos sort: [ :a :b | a timeStamp < b timeStamp ].
	versionsToCopy := sourceVersionsByDate select: [ :resolved | 
		self versionFilenames anySatisfy: [ :each |
	    resolved name = each ] ].
	versionsToCopy do: [ :each | goferSource version: each name ].

	goferSource fetch. "download all the source's mczs locally"

	[ :job |
		versionsToCopy do: [ :info | | message |
			Gofer new
				repository: self destination;
				version: info name;
				push.
			message := info name.
			info message = 'empty log message' ifFalse: [ 
				message := message, ':'.
				message := info message lines size > 1
					ifTrue: [ message, Character cr asString ]
					ifFalse: [ message, Character space asString ].
				message := message, info message ].
				(message includes: $') ifTrue: [ 
					message := message copyReplaceAll: '''' with: '' ].	
				NBMacShell run: 'cd "', destination directory parent fullName, '";git add -A'.
				NBMacShell run: 'cd "', destination directory parent fullName, '";git commit -m ''', message, '''' ].
			job increment ] asJob
		min: 0;
		max: versionsToCopy size;
		run.