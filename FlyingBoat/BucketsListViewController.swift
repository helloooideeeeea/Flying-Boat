//
//  BucketsListViewController.swift
//  FlyingBoat
//
//  Created by Yasushi Sakita on 2021/11/16.
//

import AppKit
import SotoS3

class BucketsListViewController: NSViewController {
    
    let bucketIcon: NSImage = NSImage(named:NSImage.Name("StatusBarButtonImage"))!
    var buckets:[S3.Bucket]?
    
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
