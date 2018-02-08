//
//  DataParser.swift
//  NicoBeacon
//
//  Created by Vinay on 21/08/17.
//  Copyright © 2017 iWeb. All rights reserved.
//

import UIKit


class DataParser: NSObject
{
    
    class func trainerListAPIDetils(_ details: [AnyHashable: Any],_ apiname: String, withCompletionHandler handler: @escaping (_ array:NSArray?, _ isSuccessful: Bool) -> Void)
    {
        
        let request: URLRequest? = WebServiceManager.postRequest(withService: Defines.TrainerListAPI, withDictionary: details)
        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
            if ((result == nil) || (error != nil))
            {
                print(result ?? 0)
                handler(nil,false)
            }
            else
            {
                do
                {
                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
                    print(jsonResult ?? 0)
                    
                    if jsonResult != nil
                    {
                        let status:String = jsonResult?["status"] as! String
                        
                        if (status == "True")
                        {
                            let itemArr: [Any]? = (jsonResult?["data"] as? [Any])
                            var dataList = [Any]()
                            DataManger._gDataManager.profileImageUrl = jsonResult?["imgpath"] as! String
                            
                            for items in itemArr!
                            {
                                let question = TrainerListModel.initWithDictionary(dictionary: items as! NSDictionary)
                                dataList.append(question)
                            }
                            handler(dataList as NSArray?,true)
                        }
                        else
                        {
                            handler(nil,false)
                        }
                    }
                    else
                    {
                        handler(nil,false)
                    }
                }
                catch let error
                {
                    print(error.localizedDescription)
                    handler(nil,false)
                }
            }
        }
    }
    
    
    
    class func invoiceListAPIDetils(_ details: [AnyHashable: Any],_ apiname: String, withCompletionHandler handler: @escaping (_ array:NSArray?, _ isSuccessful: Bool) -> Void)
    {
        
        let request: URLRequest? = WebServiceManager.postRequest(withService: Defines.myInvoiceListAPI, withDictionary: details)
        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
            if ((result == nil) || (error != nil))
            {
                print(result ?? 0)
                handler(nil,false)
            }
            else
            {
                do
                {
                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
                    print(jsonResult ?? 0)
                    
                    if jsonResult != nil
                    {
                        let status:String = jsonResult?["status"] as! String
                        
                        if (status == "True")
                        {
                            let itemArr: [Any]? = (jsonResult?["invoice"] as? [Any])
                            var dataList = [Any]()
                            
                            
                            for items in itemArr!
                            {
                                let question = InvoiceModel.initWithDictionary(dictionary: items as! NSDictionary)
                                dataList.append(question)
                                
                            }
                            handler(dataList as NSArray?,true)
                        }
                        else
                        {
                            handler(nil,false)
                        }
                    }
                    else
                    {
                        handler(nil,false)
                    }
                }
                catch let error
                {
                    print(error.localizedDescription)
                    handler(nil,false)
                }
            }
        }
        
        
    }
    
    class func myAppoinmentAPIDetils(_ details: [AnyHashable: Any],_ apiname: String, withCompletionHandler handler: @escaping (_ array:NSArray?,_ dic:NSDictionary?, _ isSuccessful: Bool) -> Void)
    {
        let request: URLRequest? = WebServiceManager.postRequest(withService: Defines.myAppoinmentListAPI, withDictionary: details)
        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
            if ((result == nil) || (error != nil))
            {
                print(result ?? 0)
                handler(nil,nil,false)
            }
            else
            {
                do
                {
                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
                    print(jsonResult ?? 0)
                    
                    if jsonResult != nil
                    {
                        let status:String = jsonResult?["status"] as! String
                        DataManger._gDataManager.profileImageUrl = jsonResult?["imgpath"] as! String
                        
                        let locDic:NSDictionary = jsonResult?["trainer"] as! NSDictionary
                        DataManger._gDataManager.imageProgressUrl = locDic["profile_pic"] as! String
                        
                        if (status == "True"){
                            let itemArr: [Any]? = (jsonResult?["lesson"] as? [Any])
                            var myappointmentList = [Any]()
                            
                            for items in itemArr!
                            {
                                
                                let locObj = LearnerMyAppointmentModel.initWithDictionary(dictionary: items as! NSDictionary)
                                if(DataManger._gDataManager.isFromProgress){

                                    if locObj.lesson_status == "4"{
                                        myappointmentList.append(locObj)
                                    }
                                }
                                else
                                {
                                    myappointmentList.append(locObj)
                                }
                                
                            }
                            let trainerDic: NSDictionary = jsonResult?["trainer"] as! NSDictionary
                            handler(myappointmentList as NSArray?,trainerDic as NSDictionary?,true)
                        }
                        else
                        {
                            handler(nil,nil,false)
                        }
                    }
                    else
                    {
                        handler(nil,nil,false)
                    }
                }
                catch let error
                {
                    print(error.localizedDescription)
                    handler(nil,nil,false)
                }
            }
        }
        
        
    }
    
    class func mybookingListAPIDetils(_ details: [AnyHashable: Any],_ apiname: String, withCompletionHandler handler: @escaping (_ array:NSArray?, _ isSuccessful: Bool) -> Void)
    {
        
        let request: URLRequest? = WebServiceManager.postRequest(withService: Defines.myBookingListAPI, withDictionary: details)
        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
            if ((result == nil) || (error != nil))
            {
                print(result ?? 0)
                handler(nil,false)
            }
            else
            {
                do
                {
                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
                    print(jsonResult ?? 0)
                    
                    if jsonResult != nil
                    {
                        let status:String = jsonResult?["status"] as! String
                        
                        if (status == "True")
                        {
                            let itemArr: [Any]? = (jsonResult?["booking"] as? [Any])
                            var mybookingList = [Any]()
                           
                            
                            for items in itemArr!
                            {
                                let question = LearnerMybookModel.initWithDictionary(dictionary: items as! NSDictionary)
                                if(DataManger._gDataManager.isFromProgress){
                                    if question.status == "1"{
                                        mybookingList.append(question)
                                        }
                                }
                                else
                                {
                                    mybookingList.append(question)

                                }
                                
                            }
                            handler(mybookingList as NSArray?,true)
                        }
                        else
                        {
                            handler(nil,false)
                        }
                    }
                    else
                    {
                        handler(nil,false)
                    }
                }
                catch let error
                {
                    print(error.localizedDescription)
                    handler(nil,false)
                }
            }
        }
        
        
    }
    
    
    class func packagesLessonsAPIDetils(_ details: [AnyHashable: Any],_ apiname: String, withCompletionHandler handler: @escaping (_ array:NSArray?,_ array2:NSArray?, _ isSuccessful: Bool) -> Void)
    {
        
        
        
        let request: URLRequest? = WebServiceManager.postRequest(withService: Defines.packagesLessonsAPI, withDictionary: details)
        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
            if ((result == nil) || (error != nil))
            {
                print(result ?? 0)
                handler(nil,nil,false)
            }
            else
            {
                do
                {
                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
                    print(jsonResult ?? 0)
                    
                    if jsonResult != nil
                    {
                        let status:String = jsonResult?["status"] as! String
                        
                        if (status == "True")
                        {
                            let itemArr: [Any]? = (jsonResult?["data"] as? [Any])
                            var lessionList = [Any]()
                            var lessionName:[String] = []

                            for items in itemArr!
                            {
                                let question = LessonPackeageModel.initWithDictionary(dictionary: items as! NSDictionary)
                                lessionList.append(question)
                                let package_nameDic = items as! NSDictionary

                                let package_name = package_nameDic["package_name"] as? String ?? ""
                                lessionName.append(package_name)

                            }
                            handler(lessionList as NSArray?,lessionName as NSArray?,true)
                        }
                        else
                        {
                            handler(nil,nil,false)
                        }
                    }
                    else
                    {
                        handler(nil,nil,false)
                    }
                }
                catch let error
                {
                    print(error.localizedDescription)
                    handler(nil,nil,false)
                }
            }
        }
      
        
    }
    class func stateAPIDetils(_ details: [AnyHashable: Any],_ apiname: String, withCompletionHandler handler: @escaping (_ array:NSArray?, _ isSuccessful: Bool) -> Void)
    {
        let request: URLRequest? = WebServiceManager.postRequest(withService: apiname, withDictionary: details)
        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
            if ((result == nil) || (error != nil))
            {
                print(result ?? 0)
                handler(nil,false)
            }
            else
            {
                do
                {
                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
                   // print("Return Data=")
                    print(jsonResult ?? 0)
                    
                    if jsonResult != nil
                    {
                        let status:String = jsonResult?["status"] as! String
                        
                        if (status == "True")
                        {
                            let itemArr: [Any]? = (jsonResult?["data"] as? [Any])
                            var stateList = [Any]()
                            for items in itemArr!
                            {
                                let question = StateModel.initWithDictionary(dictionary: items as! NSDictionary)
                                stateList.append(question)
                            }
                            handler(stateList as NSArray?,true)
                        }
                        else
                        {
                            handler(nil,false)
                        }
                    }
                    else
                    {
                        handler(nil,false)
                    }
                }
                catch let error
                {
                    print(error.localizedDescription)
                    handler(nil,false)
                }
            }
        }
    }
    class func globalAPIDetils(_ details: [AnyHashable: Any],_ apiname: String, withCompletionHandler handler: @escaping (_ dict:NSDictionary?, _ isSuccessful: Bool) -> Void)
    {
        let request: URLRequest? = WebServiceManager.postRequest(withService: apiname, withDictionary: details)
        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
            if ((result == nil) || (error != nil))
            {
                print(result ?? 0)
                handler([:],false)
            }
            else
            {
                do
                {
                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
                   //  print("Return Data=")
                    print(jsonResult ?? 0)
                    
                    if jsonResult != nil {
                        handler(jsonResult!,true)
                    } else {
                        handler(jsonResult!,false)
                    }
                }
                catch let error
                {
                    print(error.localizedDescription)
                    handler([:],false)
                }
            }
        }
    }
    // Login API
    class func loginUserDetils(_ details: [AnyHashable: Any], withCompletionHandler handler: @escaping (_ dict:NSDictionary?, _ isSuccessful: Bool) -> Void)
    {
        let request: URLRequest? = WebServiceManager.postRequest(withService: Defines.loginAPI, withDictionary: details)
        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
            if ((result == nil) || (error != nil))
            {
                print(result ?? 0)
                handler([:],false)
            }
            else
            {
                do
                {
                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
                    
                    print(jsonResult ?? 0)
                    var status:String
                    status = jsonResult?["status"] as! String
                    if (status == "True")
                    {
//                        DataManger._gDataManager.profileImageUrl = jsonResult?["image_url"] as! String
                        let userModel = LoginModel.initWithDictionary(dictionary: jsonResult?["data"] as! NSDictionary)
                        let sharedUser = DataManger._gDataManager
                        sharedUser.loginObj = userModel
                    }
                    
                  
                    print(jsonResult ?? 0)
                    
                    if jsonResult != nil
                    {
                        handler(jsonResult!,true)
                    }
                    else
                    {
                        handler(jsonResult!,false)
                    }
                }
                catch let error
                {
                    print(error.localizedDescription)
                    handler([:],false)
                }
            }
        }
    }
    
//
    // Sign Up
//    class func signUpForUserDeatils(_ details: String, withCompletionHandler handler: @escaping (_ dict: NSDictionary?, _ isSuccessful: Bool) -> Void)
//    {
//        let request: URLRequest? = WebServiceManager.postRequest(withService: Defines.signUpAPI, withDictionary: details)
//        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
//            if ((result == nil) || (error != nil))
//            {
//                print(result ?? 0)
//                handler([:],false)
//            }
//            else
//            {
//                do
//                {
//                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
//                    //print(jsonResult ?? 0)
//                    handler(jsonResult!,true)
//                }
//                catch let error
//                {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
    
    //Forgot Password
//    class func forgotPasswordForUserDeatils(_ details: String, withCompletionHandler handler: @escaping (_ dict: NSDictionary, _ isSuccessful: Bool) -> Void)
//    {
//        let request: URLRequest? = WebServiceManager.postRequest(withService: Defines.forgotPasswordAPI, withDictionary: details)
//        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
//            if ((result == nil) || (error != nil))
//            {
//                print(result ?? 0)
//                handler([:],false)
//            }
//            else
//            {
//                do
//                {
//                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
//                    print(jsonResult ?? 0)
//                    handler(jsonResult!,true)
//                }
//                catch let error
//                {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
//
//     //Configure device
//    class func configureNewDevice(_ details: String, withCompletionHandler handler: @escaping (_ dict:NSDictionary?, _ isSuccessful: Bool) -> Void)
//    {
//        let request: URLRequest? = WebServiceManager.postRequest(withService: Defines.configureDeviceAPI, withDictionary: details)
//        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
//            if ((result == nil) || (error != nil))
//            {
//                print(result ?? 0)
//                handler([:],false)
//            }
//            else
//            {
//                do
//                {
//                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
//                    print(jsonResult ?? 0)
//
//                    if jsonResult != nil
//                    {
//                        handler(jsonResult!,true)
//                    }
//                }
//                catch let error
//                {
//                    print(error.localizedDescription)
//                    handler([:],false)
//                }
//            }
//        }
//    }
//
//     // Update configure device
//    class func updateConfiguredDevice(_ details: String, withCompletionHandler handler: @escaping (_ dict:NSDictionary?, _ isSuccessful: Bool) -> Void)
//    {
//        let request: URLRequest? = WebServiceManager.postRequest(withService: Defines.configureDeviceUpdateAPI, withDictionary: details)
//        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
//            if ((result == nil) || (error != nil))
//            {
//                print(result ?? 0)
//                handler([:],false)
//            }
//            else
//            {
//                do
//                {
//                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
//                    print(jsonResult ?? 0)
//
//                    if jsonResult != nil
//                    {
//                        handler(jsonResult!,true)
//                    }
//                }
//                catch let error
//                {
//                    print(error.localizedDescription)
//                    handler([:],false)
//                }
//            }
//        }
//    }
//
//    // Update user profile
//
//    class func updateUserProfile(_ details: String, withCompletionHandler handler: @escaping (_ dict:NSDictionary?, _ isSuccessful: Bool) -> Void)
//    {
//        let request: URLRequest? = WebServiceManager.postRequest(withService: Defines.updateUserProfileAPI, withDictionary: details)
//        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
//            if ((result == nil) || (error != nil))
//            {
//                print(result ?? 0)
//                handler([:],false)
//            }
//            else
//            {
//                do
//                {
//                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
////                    let userModel = UserModel.initWithDictionary(dictionary: jsonResult!)
////                    let sharedUser = DataManger._gDataManager
////                    sharedUser.loginObj = userModel
//
//                    print(jsonResult ?? 0)
//
//                    if jsonResult != nil
//                    {
//                        handler(jsonResult!,true)
//                    }
//                }
//                catch let error
//                {
//                    print(error.localizedDescription)
//                    handler([:],false)
//                }
//            }
//        }
//    }
//
//    // Get Configurte device list
//    class func getDeviceList(_ details: String, completion handler: @escaping (_ array:NSArray?, _ isSuccessful: Bool) -> Void)
//    {
//        let request: URLRequest? = WebServiceManager.postRequest(withService: Defines.configureDeviceListAPI, withDictionary: details)
//        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
//            if ((result == nil) || (error != nil))
//            {
//                print(result ?? 0)
//                handler(nil,false)
//            }
//            else
//            {
//                do
//                {
//                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
//
//                    print(jsonResult ?? 0)
//
//                    if let status = jsonResult?["status"] as? String
//                    {
//                        if status == "fail"
//                        {
//                            handler(nil,true)
//                        }
//                        else
//                        {
//                            let itemArr: [Any]? = (jsonResult?["msg"] as? [Any])
//                            var deviceList = [Any]()
//                            for items in itemArr!
//                            {
//                                let device = DeviceModel.initWithDictionary(dictionary: items as! NSDictionary)
//                                deviceList.append(device)
//                            }
//                            handler(deviceList as NSArray?,true)
//                        }
//                    }
//                }
//                catch let error
//                {
//                    print(error.localizedDescription)
//                    handler(nil,false)
//                }
//            }
//        }
//
//    }
//
//
//
//
//    // Get Track History list
//
//    class func getTrackHistoryList(_ details: String, completion handler: @escaping (_ array:NSArray?, _ isSuccessful: Bool) -> Void)
//    {
//        let request: URLRequest? = WebServiceManager.postRequest(withService: Defines.trackHistory, withDictionary: details)
//        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
//            if ((result == nil) || (error != nil))
//            {
//                print(result ?? 0)
//                handler(nil,false)
//            }
//            else
//            {
//                do
//                {
//                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
//
//                    print(jsonResult ?? 0)
//
//                    if let status = jsonResult?["status"] as? String
//                    {
//                        if status == "fail"
//                        {
//                            handler(nil,true)
//                        }
//                        else
//                        {
//                            let itemArr: [Any]? = (jsonResult?["msg"] as? [Any])
//                            var trackList = [Any]()
//                            for items in itemArr!
//                            {
//                                let device = TrackModel.initWithDictionary(dictionary: items as! NSDictionary)
//                                trackList.append(device)
//                            }
//                            handler(trackList as NSArray?,true)
//                        }
//                    }
//                }
//                catch let error
//                {
//                    print(error.localizedDescription)
//                    handler(nil,false)
//                }
//            }
//        }
//
//    }
//
//
//
//    // Get product list
//
//    class func getProductList(_ details: String, completion handler: @escaping (_ array:NSArray?, _ isSuccessful: Bool) -> Void)
//    {
//        let request: URLRequest? = WebServiceManager.postRequest(withService: Defines.myProductList, withDictionary: details)
//        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
//            if ((result == nil) || (error != nil))
//            {
//                print(result ?? 0)
//                handler(nil,false)
//            }
//            else
//            {
//                do
//                {
//                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
//
//                    print(jsonResult ?? 0)
//
//                    if let status = jsonResult?["status"] as? String
//                    {
//                        if status == "fail"
//                        {
//                            handler(nil,true)
//                        }
//                        else
//                        {
//                           /* let itemArr: [Any]? = (jsonResult?["message"] as? [Any])
//
//                            let itemArr1: [Any]? = (itemArr?[0] as? [Any])
//
//
//                            var deviceList = [Any]()
//                            for items in itemArr1!
//                            {
//                              //  let itemArr1 = items[0]
//
//                                let device = MyProductModel.initWithDictionary(dictionary: items as! NSDictionary)
//                                deviceList.append(device)
//                            }*/
//
//                            let itemArr: [Any]? = (jsonResult?["message"] as? [Any])
//
//
//                            var i: Int = 0
//
//
//                            var deviceList = [Any]()
//                            for items in itemArr!
//                            {
//                                let itemArr1: [Any]? = (itemArr?[i] as? [Any])
//                                i += 1
//                                for items1 in itemArr1!
//                                {
//                                    let device = MyProductModel.initWithDictionary(dictionary: items1 as! NSDictionary)
//                                    let ststus = device.config_status
//
//                                    let data: MyProductModel? = (device as? MyProductModel)
//                                    let major = (data?.config_statusint)!
//                                    print("Status")
//                                    print(major)
//
//                                    print(data?.config_statusint ?? "0")
//                                    if major == 0
//                                    {
//                                        deviceList.append(device)
//                                    }
//
//
//                                }
//                            }
//
//
//
//                            handler(deviceList as NSArray?,true)
//                        }
//                    }
//                }
//                catch let error
//                {
//                    print(error.localizedDescription)
//                    handler(nil,false)
//                }
//            }
//        }
//
//    }
//
//
//
//    // Help API
//    class func helpAPICall(withCompletionHandler handler: @escaping (_ dict: NSDictionary, _ isSuccessful: Bool) -> Void)
//    {
//        let request: URLRequest? = WebServiceManager.request(withService: Defines.helpAPI)
//
//
//        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
//            if ((result == nil) || (error != nil))
//            {
//                print(result ?? 0)
//                handler([:],false)
//            }
//            else
//            {
//                do
//                {
//                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
//                    print(jsonResult ?? 0)
//                    handler(jsonResult!,true)
//                }
//                catch let error
//                {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
//
//    // Settings API
//
//    class func settingsAPICall(_ details: String,withCompletionHandler handler: @escaping (_ dict: NSDictionary?, _ isSuccessful: Bool) -> Void)
//    {
//        let request: URLRequest? = WebServiceManager.postRequest(withService: Defines.settingAPI, withDictionary: details)
//        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
//            if ((result == nil) || (error != nil))
//            {
//                print(result ?? 0)
//                handler([:],false)
//            }
//            else
//            {
//                do
//                {
//                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
//                    print(jsonResult ?? 0)
//                    handler(jsonResult!,true)
//                }
//                catch let error
//                {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
//
//    // Delete device API
//
//    class func deleteDeviceAPICall(_ details: String,withCompletionHandler handler: @escaping (_ dict: NSDictionary?, _ isSuccessful: Bool) -> Void)
//    {
//        let request: URLRequest? = WebServiceManager.postRequest(withService: Defines.deleteDeviceAPI, withDictionary: details)
//        WebServiceManager.send(request!) { ( _ result: NSData?, _ error: NSError?) in
//            if ((result == nil) || (error != nil))
//            {
//                print(result ?? 0)
//                handler([:],false)
//            }
//            else
//            {
//                do
//                {
//                    let jsonResult = try JSONSerialization.jsonObject(with: result! as Data, options: []) as? NSDictionary
//                    print(jsonResult ?? 0)
//                    handler(jsonResult!,true)
//                }
//                catch let error
//                {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }

    

    
}
