//
//  LoginModel.swift
//  sixtyinsixty
//
//  Created by Vinay Kumar on 21/09/17.
//  Copyright © 2017 I-WebServices. All rights reserved.
//

import UIKit

class LoginModel: NSObject
{
   
    var userId: String = ""
    var fname: String = ""
    var lname: String = ""
    var email: String = ""
    var role: String = ""
    var created: String = ""
    var admin_profile: String = ""
    var social_key: String = ""
    var social_id: String = ""
    
    class func initWithDictionary(dictionary:NSDictionary) -> LoginModel
    {
        let result = LoginModel()
        result.setDataInDictionary(dictionary: dictionary)
        return result
    }
    
    func setDataInDictionary(dictionary:NSDictionary)
    {
        
        userId = String(dictionary["id"] as! Int)
        fname = dictionary["fname"] as? String ?? ""
        lname = dictionary["lname"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        role = dictionary["role"] as? String ?? ""
        created = dictionary["created"] as? String ?? ""
        admin_profile = dictionary["admin_profile"] as? String ?? ""
        social_key = dictionary["social_key"] as? String ?? ""
        social_id = dictionary["social_id"] as? String ?? ""
    }

}
