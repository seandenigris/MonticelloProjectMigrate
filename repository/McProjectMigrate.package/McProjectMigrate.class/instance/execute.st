command
execute

	| goferSource goferDestination destinationFiles sourceVersionsByDate versionsToCopy |
	goferSource := Gofer new repository: self source.
	goferDestination := Gofer new repository: self destination.
	sourceVersionsByDate := source allVersionInfos sort: [ :a :b | a timeStamp < b timeStamp ].
	versionsToCopy := sourceVersionsByDate select: [ :resolved | 
		self versionFilenames anySatisfy: [ :each |
	    resolved name = each ] ].
	versionsToCopy do: [ :each | goferSource version: each name ].

	goferSource fetch. "download all the source's mczs locally"

	"skip versions that are already at the destination"
	destinationFiles := self destination allVersionNames.

	versionsToCopy 
		reject: [ :info | destinationFiles includes: info name ]
		thenDo: [ :info | goferDestination version: info name ].
	
	goferDestination push. "send everything to destination"

	self assert: self destination allVersionNames sorted = self versionFilenames sorted. "check that we have exactly the same versions at source and destination. This may not be meaningful when moving to a non-empty destination"