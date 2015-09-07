as yet unclassified
exampleMigrateToMczRepo
	| source destination files |
	source := MCHttpRepository allSubInstances detect: [ :e | e location includesSubstring: 'Playground' ].
	destination := MCHttpRepository allSubInstances detect: [ :e | e location includesSubstring: 'Engelbart' ].

	files := source allVersionNames select: [ :e | e includesSubstring: 'Chord' ].
	
	McProjectMigrate new
		source: source;
		destination: destination;
		versionFilenames: files;
		execute.