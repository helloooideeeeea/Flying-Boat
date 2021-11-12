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
    
    override func viewDidAppear() {
        view.window?.delegate = self
    }
    override func viewDidLoad() {
                
        // 表示するViewを選ぶ
        subView = RegisterCloudStorage.createFromNib()! as NSView
        guard let v = subView else {
            fatalError()
        }
        
        v.frame.origin = view.center(child: v)
        view.addSubview(v)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(testUpdate),
                                               name: .StatusBarNotification,
                                               object: nil)
    }
        
    func windowDidResize(_ notification: Notification) {
        guard let v = subView else {
            fatalError()
        }
        v.frame.origin = view.center(child: v)
    }
    
    
    
    @objc func testUpdate() {
        let keyPass: [String:String] = UserDefaults.standard.value(forKey: "keyPass") as! [String : String]
    }
}
