command
execute

	| goferSource goferDestination destinationFiles |
	goferSource := Gofer new repository: self source.
	goferDestination := Gofer new repository: self destination.

	(goferSource allResolved select: [ :resolved | self versionFilenames anySatisfy: [ :each |
	    resolved name = each ] ]) do: [ :each | goferSource package: each packageName ].

	goferSource fetch. "download all the source's mczs locally"

	"skip versions that are already at the destination"
	destinationFiles := self destination allVersionNames.
	self versionFilenames 
		reject: [ :file | destinationFiles includes: file ]
		thenDo: [ :file | goferDestination version: file ].

	goferDestination push. "send everything to destination"

	self assert: self destination allVersionNames sorted equals: self versionFilenames sorted. "check that we have exactly the same versions at source and destination. This may not be meaningful when moving to a non-empty destination"