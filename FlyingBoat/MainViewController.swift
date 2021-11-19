//
//  MainViewController.swift
//  FlyingBoat
//
//  Created by Yasushi Sakita on 2021/11/09.
//

import AppKit
import CoreData

class MainViewController:NSViewController {
    var context: NSManagedObjectContext? = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    override func viewDidAppear() {
        if let context = context {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Connections")
            do {
                let cons = try context.fetch(request) as? [Connections]
                if let cons = cons, cons.count > 0 {
                    present(toVC: RegisterdBucketsListViewController.initiate())
                    return
                }
            } catch {}
        }
        
        present(toVC: AuthKeyPassRegisterViewController.initiate())
    }
}

