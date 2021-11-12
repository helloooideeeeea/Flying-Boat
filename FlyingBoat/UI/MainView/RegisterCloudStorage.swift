//
//  RegisterCloudStorage.swift
//  FlyingBoat
//
//  Created by Yasushi Sakita on 2021/11/11.
//

import AppKit
import SotoS3

protocol CloudStrageDelegate {
    func s3Buckets()
}

final class RegisterCloudStorage: NSView, NibLoadable {
    
    @IBOutlet weak var s3AccessKeyInput: NSTextField!
    
    @IBOutlet weak var s3SecretKeyInput: NSSecureTextField!
    
    @IBOutlet weak var s3SubmitBtn: NSButton!
    
    var delegate: CloudStrageDelegate?
    
    @IBOutlet weak var indicator: NSProgressIndicator!
    
    @IBAction func s3SubmitClicked(_ sender: Any) {
        
        let key = s3AccessKeyInput.stringValue
        let pass = s3SecretKeyInput.stringValue
        
        // key pass 保存
        UserDefaults.standard.set(["key":key, "securet":pass], forKey: "keyPass")
        
        indicator.isHidden = false
        
        
        let client = AWSClient(
            credentialProvider: .static(accessKeyId: key, secretAccessKey: pass),
            httpClientProvider: .createNew
        )

        let s3 = S3(client: client, region: .apnortheast1)
        s3.listBuckets()
            .whenSuccess{
                response in
                if let buckets = response.buckets {
                    print("buckets:\(buckets)")
                }

                do {
                    try s3.client.syncShutdown()
                } catch let error {
                    print(error)
                }
            }
        
//            .whenFailure{
//                error in
//                    print("error:\(error)")
//        }
        
        
        self.delegate?.s3Buckets()
    }
}

