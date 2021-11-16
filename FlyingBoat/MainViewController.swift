//
//  MainViewController.swift
//  FlyingBoat
//
//  Created by Yasushi Sakita on 2021/11/09.
//

import AppKit
import SotoS3

class MainViewController:NSViewController, NSWindowDelegate {
    
    var subView: NSView?
        
    override func viewDidLoad() {
        
        // 表示するViewControllerを選ぶ
        subView = RegisterCloudStorage.createFromNib()! as NSView
        view.addSubview(subView!)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(testUpdate),
                                               name: .StatusBarNotification,
                                               object: nil)
    }
    
    override func viewDidAppear() {
        view.window?.delegate = self
        resizeView()
    }
        
    func windowDidResize(_ notification: Notification) {
        resizeView()
    }
    
    func resizeView() {
        guard let v = subView else {
            fatalError()
        }
        v.frame.origin = view.center(child: v)
    }
    
    
    @objc func testUpdate() {
        
    }
}

extension MainViewController: CloudStrageDelegate {
    
    func fetchedS3Buckets(buckts: S3.ListBucketsOutput?, error: Error?) {
        
        // Viewの切り替え
        
        
    }
}
