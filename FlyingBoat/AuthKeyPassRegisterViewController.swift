//
//  AuthKeyPassRegisterViewController.swift
//  FlyingBoat
//
//  Created by Yasushi Sakita on 2021/11/16.
//

import AppKit
import SotoS3

class AuthKeyPassRegisterViewController: NSViewController {
    
    @IBOutlet weak var s3AccessKeyInput: NSTextField!
    
    @IBOutlet weak var s3SecretKeyInput: NSSecureTextField!
    
    @IBOutlet weak var regionCombo: NSPopUpButton!
    
    @IBOutlet weak var s3SubmitBtn: NSButton!
    
    @IBOutlet weak var indicator: NSProgressIndicator!
    
    @IBAction func s3SubmitClicked(_ sender: Any) {
        
        let key = s3AccessKeyInput.stringValue
        let pass = s3SecretKeyInput.stringValue
        let region = regionCombo.titleOfSelectedItem
        guard let rgn = region else {
            return
        }
        
        indicator.isHidden = false
        
        RestfulAPI.s3listBuckets(
            accessKey: key,
            secureKey: pass,
            region: rgn,
            onSuccess: { res in
                DispatchQueue.main.sync {
                    let vc = BucketsListViewController.initiate()
                    vc.buckets = res.buckets
                    vc.accessKey = key
                    vc.secureKey = pass
                    vc.region = rgn
                    self.present(toVC: vc)
                }
            },
            onFailure: { error in
                print(error)
                
                DispatchQueue.main.sync {
                    self.indicator.isHidden = true
                    guard let window = self.view.window else {
                        return
                    }
                    let alert = NSAlert()
                    alert.simpleWarningDialog(window: window, message: "エラー", onClick: {})
                }
            }
        )
    }
    
    override func viewDidLoad() {
        for region in [Region.apnortheast1, Region.afsouth1, Region.apeast1] {
            regionCombo.menu?.addItem(NSMenuItem(title: region.rawValue, action: nil, keyEquivalent: ""))
        }
        
    }
    
}

extension AuthKeyPassRegisterViewController {
    
    static func initiate() -> AuthKeyPassRegisterViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("AuthKeyPassRegisterViewController")
        guard let vc = storyboard.instantiateController(withIdentifier: identifier) as? AuthKeyPassRegisterViewController else {
            fatalError("AuthKeyPassRegisterViewController is not found in Main.storyboard")
        }
        return vc
    }
}
