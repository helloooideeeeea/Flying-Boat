//
//  ViewController.swift
//  FlyingBoat
//
//  Created by Yasushi Sakita on 2021/11/16.
//

import AppKit

extension NSViewController {
    
    func present(toVC: NSViewController) {
        guard let splitVC = self.parent as? NSSplitViewController else {
            return
        }
        
        let item = NSSplitViewItem(viewController: toVC)
        splitVC.removeSplitViewItem(splitVC.splitViewItems[1])
        splitVC.addSplitViewItem(item)
        
    }
}
