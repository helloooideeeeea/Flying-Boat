//
//  MainViewController.swift
//  FlyingBoat
//
//  Created by Yasushi Sakita on 2021/11/09.
//

import AppKit
import SotoS3

class MainViewController:NSViewController {
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(testUpdate),
                                               name: .StatusBarNotification,
                                               object: nil)
        
    }
    
    @objc func testUpdate() {
        
        let keyPass: [String:String] = UserDefaults.standard.value(forKey: "keyPass") as! [String : String]
        guard let key = keyPass["key"], let pass = keyPass["securet"] else {
            return
        }
        
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
    }
}
