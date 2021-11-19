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
    
    private static func s3Credential(accessKey: String, secureKey: String, region: String) -> (client:AWSClient, region:String) {
        return (
            AWSClient(
                credentialProvider: .static(accessKeyId: accessKey, secretAccessKey: secureKey),
                httpClientProvider: .createNew
            ),
            region
        )
    }
    
    static func s3listBuckets(accessKey: String, secureKey: String, region: String, onSuccess: @escaping(S3.ListBucketsOutput) -> Void, onFailure: @escaping(Error?) -> Void) -> Void {
        
        let credential = s3Credential(accessKey: accessKey, secureKey: secureKey, region: region)
        
        let s3 = S3(client: credential.client, region: Region.init(rawValue: credential.region))
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
            do {
                try? s3.client.syncShutdown()
            } catch let error {
                print(error)
            }
        }
    }
}
