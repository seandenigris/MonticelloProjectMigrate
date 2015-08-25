accessing
versionFilenames
	^ versionFilenames
		ifNil: [ self source allVersionNames ]
		ifNotNil: [ :names | names value ]