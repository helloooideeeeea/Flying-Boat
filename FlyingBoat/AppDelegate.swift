
import Cocoa
import FileProvider

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            button.action = #selector(togglePopover(_:))
        }
        
        
        popover.contentViewController = StatusBarController.freshController()
//        constructMenu()
        
        let domain = NSFileProviderDomain(identifier: NSFileProviderDomainIdentifier(Bundle.main.bundleIdentifier!), displayName: "Flying Board")
        
        NSFileProviderManager.add(domain, completionHandler: { error in
            print("file provider domain: \(error as NSError?)")
        })
        
        
//        FileProviderExtension(domain: domain)
        
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    
    @objc func togglePopover(_ sender: Any?) {
      if popover.isShown {
        closePopover(sender: sender)
      } else {
        showPopover(sender: sender)
      }
    }

    func showPopover(sender: Any?) {
      if let button = statusItem.button {
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
      }
    }

    func closePopover(sender: Any?) {
      popover.performClose(sender)
    }

    //    func constructMenu() {
    //      let menu = NSMenu()
    //      menu.addItem(NSMenuItem(title: "Print Quote", action: #selector(AppDelegate.printQuote(_:)), keyEquivalent: "P"))
    //      menu.addItem(NSMenuItem.separator())
    //      menu.addItem(NSMenuItem(title: "Quit Quotes", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    //      statusItem.menu = menu
    //    }

}

extension Notification.Name {
    static let StatusBarNotification = Notification.Name("statusBarNotify")
}
