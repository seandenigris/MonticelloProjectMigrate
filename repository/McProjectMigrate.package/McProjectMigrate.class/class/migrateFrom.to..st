convenience
migrateFrom: sourceRepo to: destinationRepo
	"self migrateFrom: anMCRepository to: (MCHttpRepository allSubInstances detect: [ :e | e location includesSubstring: 'aString'])"
	^ self new
		source: sourceRepo;
		destination: destinationRepo;
		execute