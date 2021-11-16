//
//  RegisterCloudStorage.swift
//  FlyingBoat
//
//  Created by Yasushi Sakita on 2021/11/11.
//

import AppKit
import SotoS3

protocol CloudStrageDelegate {
    func fetchedS3Buckets(buckts: S3.ListBucketsOutput?, error: Error?)
}

final class RegisterCloudStorage: NSView, NibLoadable {
    
    @IBOutlet weak var s3AccessKeyInput: NSTextField!
    
    @IBOutlet weak var s3SecretKeyInput: NSSecureTextField!
    
    @IBOutlet weak var s3SubmitBtn: NSButton!
    
    var delegate: CloudStrageDelegate?
    
    @IBOutlet weak var indicator: NSProgressIndicator!
    
    @IBOutlet weak var regionCombo: NSPopUpButton!
    
    override func viewWillDraw() {
        for region in [Region.afsouth1, Region.apeast1] {
            regionCombo.menu?.addItem(NSMenuItem(title: region.rawValue, action: nil, keyEquivalent: ""))
        }
    }
    
    @IBAction func s3SubmitClicked(_ sender: Any) {
        
        let key = s3AccessKeyInput.stringValue
        let pass = s3SecretKeyInput.stringValue
        
        // key pass 保存
        UserDefaults.standard.set(["key":key, "securet":pass], forKey: "keyPass")
        
        indicator.isHidden = false
        
        RestfulAPI.s3listBuckets(
            onSuccess: { res in
                self.delegate?.fetchedS3Buckets(buckts: res, error: nil)
            },
            onFailure: { error in
                self.delegate?.fetchedS3Buckets(buckts: nil, error: error)
            }
        )
    }
}

