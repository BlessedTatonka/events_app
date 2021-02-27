import UIKit
import CoreData

class CoreDataHelper: NSObject {
    class var instance: CoreDataHelper {
        //вызывает dispatch_once внутри
        struct Singleton {
            static var instance = CoreDataHelper()
        }
        return Singleton.instance
    }
    
    let coordinator: NSPersistentStoreCoordinator
    let context: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    
    fileprivate override init() {
        let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd")!
        
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        
        coordinator = NSPersistentStoreCoordinator(
            managedObjectModel: model)
        
        let fileManager = FileManager.default
        
        //docsURL - file-URL к /Documents в sandbox моего приложения
        let docsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        //путь к файлу с базой данных
        let storeURL = docsURL!.appendingPathComponent("store.sqlite")
        
        //добавить (или создать) хранилище к координатору
        var error: NSError?
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil,
                        at: storeURL,
                        options: [
                            NSMigratePersistentStoresAutomaticallyOption: true,
                            NSInferMappingModelAutomaticallyOption: true,
                        ])
        } catch let error1 as NSError {
            error = error1
                
                print("не удалось открыть хранилище")
                print(error ?? "")
                abort() //закрыть приложение
        }
        
        context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        
        //создание context-а для асинхронной работы
        backgroundContext = NSManagedObjectContext(concurrencyType:
          NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        
        backgroundContext.persistentStoreCoordinator = coordinator
    }
}





