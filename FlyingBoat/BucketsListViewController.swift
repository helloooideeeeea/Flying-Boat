//
//  BucketsListViewController.swift
//  FlyingBoat
//
//  Created by Yasushi Sakita on 2021/11/16.
//

import AppKit
import SotoS3
import CoreData

class BucketsListViewController: NSViewController {
    
    var context: NSManagedObjectContext? = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    let bucketIcon: NSImage = NSImage(named:NSImage.Name("StatusBarButtonImage"))!
    
    var accessKey: String?
    var secureKey: String?
    var region: String?
    var buckets:[S3.Bucket]?
    
    let formatter = DateFormatter()
    
    @IBAction func selectClicked(_ sender: Any) {
        let index = tableView.selectedRow
        if index >= 0 {
            guard let window = view.window, let buckets = buckets else {
                return
            }
            
            let error = PersistManager.savePath(context: context, accessKey: accessKey, secureKey: secureKey, region: region, storageType: StorageType.s3.rawValue, srcPath: buckets[index].name, dstPath: nil)
            
            if let err = error {
                let alert = NSAlert()
                alert.simpleWarningDialog(window: window, message: "登録エラー", onClick: {
                    return
                })
            }
            
            present(toVC: RegisterdBucketsListViewController.initiate())
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        
    }
    
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        reloadBucketList()
    }
    
    func reloadBucketList() {
        tableView.reloadData()
    }
    

}

extension BucketsListViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return buckets?.count ?? 0
    }
    
}

extension BucketsListViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let FilenameCell = "FilenameCell"
        static let CreatedAtCell = "CreatedAtCell"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var image: NSImage?
        var text: String = ""
        var cellIdentifier: NSUserInterfaceItemIdentifier?
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        guard let item = buckets?[row] else {
            return nil
        }
        
        if tableColumn == tableView.tableColumns[0] {
            image = bucketIcon
            text = item.name!
            cellIdentifier = NSUserInterfaceItemIdentifier(CellIdentifiers.FilenameCell)
        } else if tableColumn == tableView.tableColumns[1] {
            text = dateFormatter.string(from: item.creationDate!)
            cellIdentifier = NSUserInterfaceItemIdentifier(CellIdentifiers.CreatedAtCell)
        }
        
        if let ci = cellIdentifier, let cell = tableView.makeView(withIdentifier: ci, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.imageView?.image = image ?? nil
            return cell
        }
        
        return nil
    }
    
}

extension BucketsListViewController {
    static func initiate() -> BucketsListViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("BucketsListViewController")
        guard let vc = storyboard.instantiateController(withIdentifier: identifier) as? BucketsListViewController else {
            fatalError("BucketsListViewController is not found in Main.storyboard")
        }
        return vc
    }
}
