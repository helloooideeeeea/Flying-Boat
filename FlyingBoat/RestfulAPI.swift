//
//  RestfulAPI.swift
//  FlyingBoat
//
//  Created by Yasushi Sakita on 2021/11/12.
//

import SotoS3
import AppKit

enum RestfulAPIError: Error {
    case CredentialNotFound
}

class RestfulAPI {
    
    private static func s3Credential() -> (client:AWSClient?, err:Error?) {
        
        // TODO Persist Managerで書き直す
        let keyPass: [String:String] = UserDefaults.standard.value(forKey: "keyPass") as! [String : String]
        guard let key = keyPass["key"], let pass = keyPass["securet"] else {
            return (nil, RestfulAPIError.CredentialNotFound)
        }

        return (
            AWSClient(
                credentialProvider: .static(accessKeyId: key, secretAccessKey: pass),
                httpClientProvider: .createNew
            ),nil
        )
    }
    
    static func s3listBuckets(onSuccess: @escaping() -> Void, onFailure: @escaping(Error?) -> Void) -> Void {
        
        let credential = s3Credential()
        if let err = credential.err {
            onFailure(err)
            return
        }
        
        if let client = credential.client {
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
    
}
