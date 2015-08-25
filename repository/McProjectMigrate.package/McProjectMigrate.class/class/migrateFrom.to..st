convenience
migrateFrom: sourceRepo to: destinationRepo
	^ self new
		source: sourceRepo;
		destination: destinationRepo;
		execute