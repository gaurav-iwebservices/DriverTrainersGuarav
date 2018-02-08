//
//  WebServiceManager.swift
//  SwiftDemo
//
//  Created by Vinay on 03/05/17.
//  Copyright © 2017 I-WebServices. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
let kNetworkErrorMeassage = "internet not working"

class WebServiceManager: NSObject {
    
    class func request(withService service: String) -> URLRequest
    {
        let urlString: String = Defines.ServerUrl + (service)
        return WebServiceManager.request(withUrlString: urlString) as URLRequest
    }
    
    
    class func request(withUrlString urlString: String) -> NSMutableURLRequest
    {
        let request = NSMutableURLRequest(url:URL(string: urlString)!)
        request.addValue("application/json",forHTTPHeaderField:"Accept")
        request.httpMethod = "GET"
        request.timeoutInterval = 60
        return request
    }
    
    class func postRequest(withService service: String, withDictionary dict: [AnyHashable: Any]) -> URLRequest
    {
        let urlString: String = Defines.ServerUrl + (service)
        print("URL:" + urlString)
        print("Post Data:")
        print(dict)

        return WebServiceManager.postRequestWithUrlString(urlString: urlString, withDictionary: dict) as URLRequest
    }
    
    
    class func postRequestWithUrlString(urlString: String, withDictionary dict: [AnyHashable: Any]) -> NSMutableURLRequest
    {
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.timeoutInterval = 60
        let postData: Data? = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        request.httpBody = postData
        return request
    }

    class func send(_ request: URLRequest, completion callback: @escaping (_ result: NSData?, _ error: NSError?) -> Void)
    {
        if WebServiceManager.isInternetAvailable() == false
        {
            callback(nil, NSError(domain:kNetworkErrorMeassage, code:0, userInfo:nil))
            return
        }
        
//        print("Request# \n URL : \(request.url!.absoluteString) \n Headers : \(request.allHTTPHeaderFields?.description) \n Request Method : \(request.httpMethod) \n Post body : \(request.httpBody ? try? JSONSerialization.jsonObject(with: (request.httpBody)!, options: []) : request.httpBody)\n")
        
        //jsonObject(with data: Data, options opt: JSONSerialization.ReadingOptions = []) throws -> Any
        
//        print("Request# \n URL : \(String(describing: request.url?.absoluteString)) \n
//            Headers :  (request.allHTTPHeaderFields?.description)  Request Method :(request.httpMethod) Post body :  (request.httpBody ? try? JSONSerialization.jsonObject(with: (request.httpBody)!, options: []) : request.httpBody)")
        
//        print("Request# \n URL : \(request.url?.absoluteString) \n Headers : \(request.allHTTPHeaderFields!.description) \n Request Method : \(request.httpMethod) \n Post body : \(request.httpBody ? String(data: request.httpBody!, encoding: String.Encoding.ascii) : request.httpBody)\n")
        var err: NSError?
        
        let dataTask : URLSessionDataTask? = URLSession.shared.dataTask(with: request) { (responseData, response, error) in
            
            if error != nil
            {
                callback(nil, error as NSError?)
            }
            do
            {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                let httpResponce: HTTPURLResponse? = (response as? HTTPURLResponse)
                let responseStatusCode: Int? = httpResponce?.statusCode
                
                if responseStatusCode == 200 || responseStatusCode == 201 || responseStatusCode == 202
                {
                    //print("Success")
                    DispatchQueue.main.async
                    {
                        callback(responseData! as NSData?,nil)
                    }
                }
                else
                {
                    DispatchQueue.main.async(execute: {() -> Void in
                        callback(nil, error as NSError?)
                    })
                }
            }
        }
         dataTask?.resume()
    }
   
    class func isInternetAvailable() -> Bool
    {
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
