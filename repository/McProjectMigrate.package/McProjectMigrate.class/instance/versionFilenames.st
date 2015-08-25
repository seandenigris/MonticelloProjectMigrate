accessing
versionFilenames
	^ versionFilenames
		ifNil: [ versionFilenames := self source allVersionNames ]
		ifNotNil: [ :names | names value ]