command
execute

	| goferSource goferDestination destinationFiles |
	goferSource := Gofer new repository: self source.
	goferDestination := Gofer new repository: self destination.

	(goferSource allResolved select: [ :resolved | self versionFilenames anySatisfy: [ :each |
	    resolved name = each ] ]) do: [ :each | goferSource package: each packageName ].

	goferSource fetch. "downloads all mcz on your computer"

	destinationFiles := self destination allVersionNames. "checks what self versionFilenames are already at destination"
	self versionFilenames reject: [ :file | destinationFiles includes: file ] thenDo: [ :file |
	    goferDestination version: file ]. "selects only the mcz that are not yet at destination"

	goferDestination push. "sends everything to SmalltalkHub"

	Halt now.
	self assert: self destination allVersionNames sorted = self versionFilenames sorted.
	"checks we have exactly the same self versionFilenames at source and destination"