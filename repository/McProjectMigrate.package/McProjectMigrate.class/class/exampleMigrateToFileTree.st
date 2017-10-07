as yet unclassified
exampleMigrateToFileTree
	| projectName source destination files m destinationParent projectFiles |
	projectName := ''.
		projectName := 'Equals'.
	
	"If source already peresent in image"
	"source := MCHttpRepository allSubInstances detect: [ :e | e location includesSubstring: projectName ]."
	"If not"
	source := MCHttpRepository location: 'http://smalltalkhub.com/mc/CAR/ReusableBricks/main' user: '' password: ''.

	"Destination Repository"
	"Option 1: Create instance on local Git clone"
	"NB: Make sure local git clone is setup before proceeding!"
	destinationParent := FileLocator home / 'Dynabook' / 'Repositories'.
	destination := MCFileTreeRepository new
		directory: (destinationParent / projectName / 'repository') ensureCreateDirectory;
		yourself.
	"Option 2: Instance already created
	destination := MCFileTreeRepository allSubInstances detect: [ :e | e location includesSubstring: projectName ]."
	
	files := source allVersionNames reject: [ :e | e includesSubstring: 'ConfigurationOf' ].
	projectFiles := files select: [ :e | e beginsWith: projectName ].
	
	m := McProjectMigrate new
		source: source;
		versionFilenames: projectFiles;
		destination: destination.
	m executeGit