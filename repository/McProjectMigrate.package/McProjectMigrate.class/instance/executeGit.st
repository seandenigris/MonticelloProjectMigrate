command
executeGit

	| goferSource sourceVersionsByDate versionsToCopy  requestedVersions |
	self assert: (self destination directory parent / '.git') exists description: 'A local git repo must already exist at the destination!!!'.
	goferSource := Gofer new repository: self source.
	self versionFilenames do: [ :e | goferSource version: e ].
	requestedVersions := goferSource resolved collect: [ :e | e version info ].
	sourceVersionsByDate := requestedVersions sort: [ :a :b | a timeStamp < b timeStamp ].
	"sourceVersionsByDate := sourceVersionsByDate allButFirst: 332."
	"sourceVersionsByDate := source allVersionInfos sort: [ :a :b | a timeStamp < b timeStamp ]."
	versionsToCopy := sourceVersionsByDate" select: [ :resolved | 
		self versionFilenames anySatisfy: [ :each |
	    resolved name = each ] ].
	versionsToCopy do: [ :each | goferSource version: each name ]".

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
					ifTrue: [ message, Character lf asString ]
					ifFalse: [ message, Character space asString ].
				message := message, info message withUnixLineEndings ].
				(message includes: $') ifTrue: [ 
					message := message copyReplaceAll: '''' with: '' ].	
				Smalltalk tools shell waitForCommand: 'cd "', destination directory parent fullName, '";git add -A'.
				Smalltalk tools shell waitForCommand: 'cd "', destination directory parent fullName, '";git commit -m ''', message, '''' ].
			job increment ] asJob
		min: 0;
		max: versionsToCopy size;
		run.