*McProjectMigrate
allVersionInfos
	^ self allFileNames collect: [ :e | self versionInfoFromFileNamed: e ]