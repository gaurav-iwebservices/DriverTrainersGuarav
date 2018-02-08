//
//  Networking.swift
//  Driving Trainers
//
//  Created by iws on 1/12/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SystemConfiguration

open class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
        
    }
}

class DataProvider:NSObject {
    
    class var sharedInstance:DataProvider {
        struct Singleton {
            static let instance = DataProvider()
        }
        return Singleton.instance
    }
    
    func getDataUsingPost(path:String , dataDict:[String:Any], _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        print(path)
        Alamofire.request(path, method: .post, parameters: dataDict, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    successBlock(json)
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        }
        
    }
    
    func getDataUsingGet(path:String , _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        Alamofire.request(path, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    successBlock(json)
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        }
        
    }
    
}
