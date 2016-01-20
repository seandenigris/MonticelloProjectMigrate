as yet unclassified
exampleMigrateToFileTree
	| projectName source destination files m destinationParent |
	projectName := ''.
	source := MCHttpRepository allSubInstances detect: [ :e | e location includesSubstring: projectName ].

	"Destination Repository"
	"Option 1: Create instance on local Git clone"
	"NB: Make sure local git clone is setup before proceeding!"
	destinationParent := FileLocator home.
	destination := MCFileTreeRepository new
		directory: (destinationParent / projectName / 'repository') ensureCreateDirectory;
		yourself.
	"Option 2: Instance already created
	destination := MCFileTreeRepository allSubInstances detect: [ :e | e location includesSubstring: projectName ]."
	
	files := source allVersionNames reject: [ :e | e includesSubstring: 'ConfigurationOf' ].
	m := McProjectMigrate new
		source: source;
		versionFilenames: files;
		destination: destination.
	m executeGit