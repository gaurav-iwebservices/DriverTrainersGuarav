//
//  StateModel.swift
//  Driving Trainers
//
//  Created by iWeb on 1/11/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class StateModel: NSObject {
    var name: String = ""
    var state: String = ""
    var state_code: String = ""
    var postcode: String = ""
    var type: String = ""
    
    
    class func initWithDictionary(dictionary:NSDictionary) -> StateModel
    {
        let result = StateModel()
        result.setDataInDictionary(dictionary: dictionary)
        return result
    }
    
    func setDataInDictionary(dictionary:NSDictionary)
    {
      
        name = dictionary["name"] as? String ?? ""
        state = dictionary["state"] as? String ?? ""
        state_code = dictionary["state_code"] as? String ?? ""
        postcode = dictionary["postcode"] as? String ?? ""
        type = dictionary["type"] as? String ?? ""
     
    }

}

class State: NSObject {
    var name:String!
    var state:String!
    var postCode:String!
    var stateCode:String!
    var id:String!
    
    init(name:String,state:String,postCode:String,stateCode:String,id:String) {
        self.name = name
        self.state = state
        self.postCode = postCode
        self.stateCode = stateCode
        self.id = id
    }
    
}

class Suburb: NSObject {
    var name:String!
    var stateCode:String!
    var type:String!
    var postCode:String!
    var id:String!
    
    init(name:String,stateCode:String,type:String,postCode:String,id:String) {
        self.name = name
        self.stateCode = stateCode
        self.type = type
        self.postCode = postCode
        self.id = id
    }
}

