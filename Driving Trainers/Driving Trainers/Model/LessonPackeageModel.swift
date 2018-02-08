//
//  LessonPackeageModel.swift
//  Driving Trainers
//
//  Created by iWeb on 1/19/18.
//  Copyright © 2018 iWeb. All rights reserved.
//



import UIKit

class LessonPackeageModel: NSObject {
    var package_id: Int = 0
    var package_name: String = ""
 
    // var lessons_details: Array<AnyObject> = []
   // var lessons_details = [[String : AnyObject]]()
    
    var lessons_details = [Any]()

  
    class func initWithDictionary(dictionary:NSDictionary) -> LessonPackeageModel
    {
        let result = LessonPackeageModel()
        result.setDataInDictionary(dictionary: dictionary)
        return result
    }
    
    func setDataInDictionary(dictionary:NSDictionary)
    {
        package_id = dictionary["package_id"] as? Int ?? 0
        package_name = dictionary["package_name"] as? String ?? ""
        print("package name")
        
        lessons_details = (dictionary["lessons_details"] as? [Any])!

        print(lessons_details.count)
      
        
    }
    
}

