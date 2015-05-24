import CoreData


/// MARK: - DACoreDataManager
class DACoreDataManager {

    /// MARK: - class method
    static let sharedInstance = DACoreDataManager()


    /// MARK: - property
    var managedObjectModel: NSManagedObjectModel {
        let modelURL = NSBundle.mainBundle().URLForResource("DAModel", withExtension: "momd")
        return NSManagedObjectModel(contentsOfURL: modelURL!)!
    }

    var managedObjectContext: NSManagedObjectContext {
        var coordinator = self.persistentStoreCoordinator

        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }

    var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentsDirectory = documentsDirectories[documentsDirectories.count - 1] as! NSURL
        let storeURL = documentsDirectory.URLByAppendingPathComponent("DAModel.sqlite")

        var error: NSError? = nil
        var persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        persistentStoreCoordinator.addPersistentStoreWithType(
            NSSQLiteStoreType,
            configuration: nil,
            URL: storeURL,
            options: nil,
            error: &error
        )

        return persistentStoreCoordinator
    }


    /// MARK: - initialization
    init() {
    }

}
