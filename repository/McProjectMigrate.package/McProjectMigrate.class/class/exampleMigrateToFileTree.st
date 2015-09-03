as yet unclassified
exampleMigrateToFileTree
	| projectName source destination files m |
	projectName := ''.
	source := MCHttpRepository allSubInstances detect: [ :e | e location includesSubstring: projectName ].
	destination := MCFileTreeRepository allSubInstances detect: [ :e | e location includesSubstring: projectName ].
	files := source allVersionNames reject: [ :e | e includesSubstring: 'ConfigurationOf' ].
	m := McProjectMigrate new
		source: source;
		versionFilenames: files;
		destination: destination.
	m executeBitbucket