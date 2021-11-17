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
        
        // key pass 保存
        UserDefaults.standard.set(["key":key, "securet":pass, "region":region], forKey: "keyPass")
        
        indicator.isHidden = false
        
        RestfulAPI.s3listBuckets(
            onSuccess: { res in
                DispatchQueue.main.sync {
                    let vc = self.bucketsListVC()
                    vc.buckets = res.buckets
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
    
    override func viewDidAppear() {
        for region in [Region.apnortheast1, Region.afsouth1, Region.apeast1] {
            regionCombo.menu?.addItem(NSMenuItem(title: region.rawValue, action: nil, keyEquivalent: ""))
        }
    }
    
    func bucketsListVC() -> BucketsListViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("BucketsListViewController")
        guard let vc = storyboard.instantiateController(withIdentifier: identifier) as? BucketsListViewController else {
            fatalError("BucketsListViewController is not found in Main.storyboard")
        }
        return vc
    }
}
