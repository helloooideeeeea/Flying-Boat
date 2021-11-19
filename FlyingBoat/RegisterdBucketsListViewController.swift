//
//  RegisterdBucketsListViewController.swift
//  FlyingBoat
//
//  Created by Yasushi Sakita on 2021/11/18.
//

import AppKit
import CoreData

class RegisterdBucketsListViewController: NSViewController {
    
    var context: NSManagedObjectContext? = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var serviceIcon: NSImage = NSImage(named:NSImage.Name("StatusBarButtonImage"))!
    @IBOutlet weak var tableView: NSTableView!
    
    var cons: [Connections]?
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Connections")
        request.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: false),NSSortDescriptor(key: "created_at", ascending: false)]
        do {
            cons = try context?.fetch(request) as? [Connections]
            tableView.reloadData()
        } catch {}
        
    }
}

extension RegisterdBucketsListViewController : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return cons?.count ?? 0
    }
    
}

extension RegisterdBucketsListViewController : NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let SrcPathCell = "SrcPathCell"
        static let DstPathCell = "DstPathCell"
        static let RegionCell = "RegionCell"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var image: NSImage?
        var text: String = ""
        var cellIdentifier: NSUserInterfaceItemIdentifier?
        
        guard let item = cons?[row] else {
            return nil
        }
        
        if tableColumn == tableView.tableColumns[0] {
            image = serviceIcon
            text = item.src_path!
            cellIdentifier = NSUserInterfaceItemIdentifier(CellIdentifiers.SrcPathCell)
        } else if tableColumn == tableView.tableColumns[1] {
            if let dstPath = item.dst_path {
                text = dstPath
                cellIdentifier = NSUserInterfaceItemIdentifier(CellIdentifiers.DstPathCell)
            }
        } else if tableColumn == tableView.tableColumns[2] {
            if let region = item.region {
                text = region
                cellIdentifier = NSUserInterfaceItemIdentifier(CellIdentifiers.RegionCell)
            }
        }
        
        if let ci = cellIdentifier, let cell = tableView.makeView(withIdentifier: ci, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.imageView?.image = image ?? nil
            return cell
        }
        
        return nil
    }
    
}