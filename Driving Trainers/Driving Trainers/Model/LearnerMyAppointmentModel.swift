//
//  LearnerMyAppointmentModel.swift
//  Driving Trainers
//
//  Created by iWeb on 1/23/18.
//  Copyright © 2018 iWeb. All rights reserved.
//



import UIKit

class LearnerMyAppointmentModel: NSObject {
    
    var data_id: String = ""
    
    var booking_id: String = ""
    var package_id: String = ""
    var package_name: String = ""
    var package_amount: String = ""
    var lesson_id: String = ""
    var lesson_name: String = ""
    
    var duration: String = ""
    var lesson_amt: String = ""
    var lesson_status: String = ""
    var student_id: String = ""
    
    var schedule_date: String = ""
    
    var schedule_time: String = ""
    
    var appoint_date: String = ""
    var appoint_time: String = ""
    var date: String = ""
    var update_on: String = ""
    var re_schedule_status: String = ""
    var payment_status: String = ""
    var payment_date: String = ""
    var payment_id: String = ""
    var book_status: String = ""
    
    var referred_person_name: String = ""

    var referred_person_id: String = ""
    var trainer_amt:String = ""
      var school_amt:String = ""
      var referred_amt:String = ""
    var profile_pic:String = ""

    class func initWithDictionary(dictionary:NSDictionary) -> LearnerMyAppointmentModel
    {
        let result = LearnerMyAppointmentModel()
        result.setDataInDictionary(dictionary: dictionary)
        return result
    }
    
    func setDataInDictionary(dictionary:NSDictionary)
    {
        
        data_id = String(dictionary["id"] as? Int ?? 0)
        booking_id = dictionary["booking_id"] as? String ?? ""
        package_id = dictionary["package_id"] as? String ?? ""
        package_name = dictionary["package_name"] as? String ?? ""
        package_amount = dictionary["package_amount"] as? String ?? ""
        lesson_id = dictionary["lesson_id"] as? String ?? ""
        lesson_name = dictionary["lesson_name"] as? String ?? ""
        profile_pic = dictionary["profile_pic"] as? String ?? ""
        duration = dictionary["duration"] as? String ?? ""
        lesson_amt = dictionary["lesson_amt"] as? String ?? ""
        lesson_status = String(dictionary["lesson_status"] as? Int ?? 0)
        student_id = dictionary["student_id"] as? String ?? ""
        
        schedule_date = dictionary["schedule_date"] as? String ?? ""
        
        schedule_time = dictionary["schedule_time"] as? String ?? ""
        
        re_schedule_status = String(dictionary["re_schedule_status"] as? Int ?? 0)
        
        appoint_date = dictionary["appoint_date"] as? String ?? ""
        appoint_time = dictionary["appoint_time"] as? String ?? ""
        date = dictionary["date"] as? String ?? ""
        update_on = dictionary["update_on"] as? String ?? ""
        payment_status = String(dictionary["payment_status"] as? Int ?? 0)
        payment_date = dictionary["payment_date"] as? String ?? ""
        payment_id = dictionary["payment_id"] as? String ?? ""
        book_status = String(dictionary["book_status"] as? Int ?? 0)
        referred_person_name = dictionary["referred_person_name"] as? String ?? ""
        referred_person_id = dictionary["referred_person_id"] as? String ?? ""
        trainer_amt = dictionary["trainer_amt"] as? String ?? ""
        school_amt = dictionary["school_amt"] as? String ?? ""
        referred_amt = dictionary["referred_amt"] as? String ?? ""

        
        
    }
}

