command
executeBitbucket

	| goferSource   sourceVersionsByDate versionsToCopy |
	goferSource := Gofer new repository: self source.
	sourceVersionsByDate := source allVersionInfos sort: [ :a :b | a timeStamp < b timeStamp ].
	versionsToCopy := sourceVersionsByDate select: [ :resolved | 
		self versionFilenames anySatisfy: [ :each |
	    resolved name = each ] ].
	versionsToCopy do: [ :each | goferSource version: each name ].

	goferSource fetch. "download all the source's mczs locally"

	versionsToCopy do: [ :info | | message |
		Gofer new
			repository: self destination;
			version: info name;
			push.
		message := 'v. ', (info versionNumber asString padLeftTo: 2 with: $0).
		info message = 'empty log message' ifFalse: [ 
			message := message, ':'.
			message := info message lines size > 1
				ifTrue: [ message, Character cr asString ]
				ifFalse: [ message, Character space asString ].
			message := message, info message ].
			(message includes: $') ifTrue: [ 
				message := message copyReplaceAll: '''' with: '' ].	
			NBMacShell run: 'cd /Users/sean/Dynabook/Working\ Images/ProjectProject/git/;git add -A'.
			NBMacShell run: 'cd /Users/sean/Dynabook/Working\ Images/ProjectProject/git/;git commit -m ''', message, ''''.
			 ].