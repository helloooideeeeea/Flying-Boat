
import Cocoa
import FileProvider

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        
        let ret = PersistManager.fetchPath(context: persistentContainer.viewContext, nil)
        if let error = ret.error {
            // TODO error
            print(error)
        }
        
        if let cons = ret.cons, cons.count > 0 {
            let con = cons[0]
            let domain = NSFileProviderDomain(identifier: NSFileProviderDomainIdentifier(Bundle.main.bundleIdentifier!), displayName: con.src_path!)
            NSFileProviderManager.add(domain, completionHandler: { error in
                print("file provider domain: \(error as NSError?)")
            })
        }
        
        
//        FileProviderExtension(domain: domain)
        
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    func saveContext () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
        do {
          try context.save()
        } catch {
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }
}


extension Notification.Name {
    static let StatusBarNotification = Notification.Name("statusBarNotify")
}
