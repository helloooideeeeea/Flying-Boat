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
    
    private static func s3Credential() -> (client:AWSClient?, region:String?, err:Error?) {
        
        // TODO Persist Managerで書き直す
        let keyPass: [String:String] = UserDefaults.standard.value(forKey: "keyPass") as! [String : String]
        guard let key = keyPass["key"], let pass = keyPass["securet"], let region = keyPass["region"] else {
            return (nil, nil, RestfulAPIError.CredentialNotFound)
        }

        return (
            AWSClient(
                credentialProvider: .static(accessKeyId: key, secretAccessKey: pass),
                httpClientProvider: .createNew
            ),
            region,
            nil
        )
    }
    
    static func s3listBuckets(onSuccess: @escaping(S3.ListBucketsOutput) -> Void, onFailure: @escaping(Error?) -> Void) -> Void {
        
        let credential = s3Credential()
        guard let client = credential.client, let region = credential.region else {
            if let err = credential.err {
                onFailure(err)
                return
            } else {
                fatalError()
            }
        }
        
        let s3 = S3(client: client, region: Region.init(rawValue: region))
        let futureResponse = s3.listBuckets()
        futureResponse.whenComplete { result in
            switch result {
            case .failure(let err):
                onFailure(err)
            case .success:
                do {
                    let res = try result.get().self
                    onSuccess(res)
                } catch let err {
                    onFailure(err)
                }
            }
        }
    }
    
}
