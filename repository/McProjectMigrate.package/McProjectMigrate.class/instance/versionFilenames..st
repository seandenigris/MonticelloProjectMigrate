accessing
versionFilenames: anObject
	"anObject - anything which responds to #value with a collection of filenames
		For example:
			aCollection - #('file1.mcz' 'file2.mcz')
			aBlock - [ source allVersionNames select: [ :e | e beginsWith: prefix ] ]"

	versionFilenames := anObject