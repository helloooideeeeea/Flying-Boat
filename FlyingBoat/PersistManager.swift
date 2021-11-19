//
//  PersistManager.swift
//  FlyingBoat
//
//  Created by Yasushi Sakita on 2021/11/09.
//

import Foundation
import CoreData

enum StorageType: Int16 {
    case s3 = 1
    case cloudStroge = 2
}

enum PersistError: Error {
    case InvalidPrameters
}

class PersistManager {
    
    static func fetchPath(context: NSManagedObjectContext?, _ callback: ((NSFetchRequest<NSFetchRequestResult>) -> Void)?) -> (cons:[Connections]?, error:Error?) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Connections")
        callback?(request)
        do {
            let cons = try context?.fetch(request) as? [Connections]
            return (cons, nil)
        } catch let error {
            return (nil, error)
        }
    }
    
    
    static func savePath(context: NSManagedObjectContext?, accessKey: String?, secureKey: String?, region: String?, storageType: Int16, srcPath: String?, dstPath:String?) -> Error? {
        
        guard let context = context, let ak = accessKey, let sk = secureKey, let rgn = region, let srcPath = srcPath else {
            return PersistError.InvalidPrameters
        }
        
        let conn = Connections(context: context)
        conn.uuid = UUID()
        conn.access_key = ak
        conn.secure_key = sk
        conn.region = rgn
        conn.src_path = srcPath
        conn.src_type = storageType
//        conn.dst_path = ""
        conn.priority = 0
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        conn.created_at = Int64(formatter.string(from: Date()))!
        
        do {
            try context.save()
        } catch let error {
            return error
        }
        return nil
    }
    
}
