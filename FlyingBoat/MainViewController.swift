//
//  MainViewController.swift
//  FlyingBoat
//
//  Created by Yasushi Sakita on 2021/11/09.
//

import AppKit

class MainViewController:NSViewController, NSWindowDelegate {
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(testUpdate),
                                               name: .StatusBarNotification,
                                               object: nil)
        
    }
    
    @objc func testUpdate() {
        
    }
    
    override func viewDidAppear() {
        view.window?.delegate = self
        present(toVC: authKeyPassVC())
    }
    
    func windowDidResize(_ notification: Notification) {
    }
    
    func authKeyPassVC() -> AuthKeyPassRegisterViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("AuthKeyPassRegisterViewController")
        guard let vc = storyboard.instantiateController(withIdentifier: identifier) as? AuthKeyPassRegisterViewController else {
            fatalError("AuthKeyPassRegisterViewController is not found in Main.storyboard")
        }
        return vc
    }
}

