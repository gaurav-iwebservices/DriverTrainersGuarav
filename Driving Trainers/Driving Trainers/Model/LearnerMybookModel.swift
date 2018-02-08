//
//  LearnerMybookModel.swift
//  Driving Trainers
//
//  Created by iWeb on 1/23/18.
//  Copyright © 2018 iWeb. All rights reserved.
//


import UIKit

class LearnerMybookModel: NSObject {
    
    var data_id: String = ""
    var booking_date: String = ""
    var student_id: String = ""
    var student_name: String = ""
    var package_id: String = ""
    var packagename: String = ""
    var lession_id: String = ""
    var lessionname: String = ""
    var duration: String = ""
    var amount: String = ""
    var payment_mode: String = ""
    var payment_date: String = ""
    var student_email: String = ""
    var status: String = ""
    var required_instructor_date: String = ""
    var required_instructor_time: String = ""
    var reffered_by: String = ""
    var instructor_id: String = ""
    var amt_per_lesson: String = ""
    var totallesson: String = ""
    var suburb: String = ""
    var date: String = ""
    var time: String = ""
    var postal: String = ""
    
    class func initWithDictionary(dictionary:NSDictionary) -> LearnerMybookModel
    {
        let result = LearnerMybookModel()
        result.setDataInDictionary(dictionary: dictionary)
        return result
    }
    
    func setDataInDictionary(dictionary:NSDictionary)
    {
      
        data_id = String(dictionary["id"] as? Int ?? 0)
        booking_date = dictionary["booking_date"] as? String ?? ""
        student_id = String(dictionary["student_id"] as? Int ?? 0)
        student_name = dictionary["student_name"] as? String ?? ""
        package_id = String(dictionary["package_id"] as? Int ?? 0)
        packagename = dictionary["packagename"] as? String ?? ""
        lession_id = String(dictionary["lession_id"] as? Int ?? 0)
        lessionname = dictionary["lessionname"] as? String ?? ""
        duration = dictionary["duration"] as? String ?? ""
        amount = dictionary["amount"] as? String ?? ""
        payment_mode = dictionary["payment_mode"] as? String ?? ""
        payment_date = dictionary["payment_date"] as? String ?? ""
        student_email = dictionary["student_email"] as? String ?? ""
        status = String(dictionary["status"] as? Int ?? 0)
        required_instructor_date = dictionary["required_instructor_date"] as? String ?? ""
        required_instructor_time = dictionary["required_instructor_time"] as? String ?? ""
        reffered_by = dictionary["reffered_by"] as? String ?? ""
        instructor_id = String(dictionary["instructor_id"] as? Int ?? 0)
        amt_per_lesson = dictionary["amt_per_lesson"] as? String ?? ""
        totallesson = dictionary["totallesson"] as? String ?? ""
        suburb = dictionary["suburb"] as? String ?? ""
        date = dictionary["date"] as? String ?? ""
        time = dictionary["time"] as? String ?? ""
        postal = dictionary["postal"] as? String ?? ""

        
    }
}
