//
//  TrainerListModel.swift
//  Driving Trainers
//
//  Created by iWeb on 1/30/18.
//  Copyright © 2018 iWeb. All rights reserved.
//



import UIKit

class TrainerListModel: NSObject {
    
//    var data_id: String = ""
//    var instructor_name: String = ""
//    var booking_id: String = ""
//    var package_id: String = ""
//    var package_name: String = ""
//    var package_amount: String = ""
//    var lesson_id: String = ""
//    var lesson_name: String = ""
//
//    var duration: String = ""
//    var lesson_amt: String = ""
//    var lesson_status: String = ""
//    var student_id: String = ""
//
//    var schedule_date: String = ""
//
//    var schedule_time: String = ""
//
//    var appoint_date: String = ""
//    var appoint_time: String = ""
//    var date: String = ""
//    var update_on: String = ""
//    var re_schedule_status: String = ""
//    var payment_status: String = ""
//    var payment_date: String = ""
//    var payment_id: String = ""
//    var book_status: String = ""
//
//    var referred_person_name: String = ""
//
//    var referred_person_id: String = ""
//    var trainer_amt:String = ""
//    var school_amt:String = ""
//    var referred_amt:String = ""
//
//
//    var trainerDic:NSDictionary?
    
    
    var trainer_data_id:String = ""
    var trainer_instructor_id:String = ""
    var trainer_fname:String = ""
    var trainer_lname:String = ""
    var trainer_dob:String = ""
    var trainer_gender:String = ""
    var trainer_state:String = ""
    var trainer_state_code:String = ""
    var trainer_subrub:String = ""
    var trainer_suburb_post_code:String = ""
    var trainer_street_no:String = ""
    var trainer_street_name:String = ""
    var trainer_postal_code:String = ""
    var trainer_address:String = ""
    var trainer_mobile:String = ""
    var trainer_email:String = ""
    var trainer_description:String = ""
    var trainer_driving_license:String = ""
    var trainer_license_state:String = ""
    var trainer_expiration_date:String = ""
    var trainer_vehicle_type:String = ""
    var trainer_vehicle_model:String = ""
    var trainer_profile_pic:String = ""
    var trainer_star_rating:String = ""
    var trainer_rating_status:String = ""
    var trainer_refral_code:String = ""
    var trainer_priority:String = ""
    var trainer_creation_date:String = ""
    
    var trainer_min_fee:String = ""
    var trainer_driving_school_name:String = ""
    var trainer_pyement_mode_accepting:String = ""
    
    var trainer_bank_account_name:String = ""
    var trainer_hours_from:String = ""
    var trainer_hours_to:String = ""
    var trainer_bank_account_ssb:String = ""
    var trainer_account_no:String = ""
    
    var trainer_experience_year:String = ""
    var trainer_status:String = ""
    var trainer_availability:String = ""
    
    
    
    class func initWithDictionary(dictionary:NSDictionary) -> TrainerListModel
    {
        let result = TrainerListModel()
        result.setDataInDictionary(dictionary: dictionary)
        return result
    }
    
    func setDataInDictionary(dictionary:NSDictionary)
    {
//        data_id = String(dictionary["id"] as? Int ?? 0)
//        booking_id = dictionary["booking_id"] as? String ?? ""
//        package_id = dictionary["package_id"] as? String ?? ""
//        package_name = dictionary["package_name"] as? String ?? ""
//        package_amount = dictionary["package_amount"] as? String ?? ""
//        lesson_id = dictionary["lesson_id"] as? String ?? ""
//        lesson_name = dictionary["lesson_name"] as? String ?? ""
//
//        duration = dictionary["duration"] as? String ?? ""
//        lesson_amt = dictionary["lesson_amt"] as? String ?? ""
//        lesson_status = String(dictionary["lesson_status"] as? Int ?? 0)
//        student_id = dictionary["student_id"] as? String ?? ""
//
//        schedule_date = dictionary["schedule_date"] as? String ?? ""
//
//        schedule_time = dictionary["schedule_time"] as? String ?? ""
//
//        re_schedule_status = String(dictionary["re_schedule_status"] as? Int ?? 0)
//
//        appoint_date = dictionary["appoint_date"] as? String ?? ""
//        appoint_time = dictionary["appoint_time"] as? String ?? ""
//        date = dictionary["date"] as? String ?? ""
//        update_on = dictionary["update_on"] as? String ?? ""
//        payment_status = String(dictionary["payment_status"] as? Int ?? 0)
//        payment_date = dictionary["payment_date"] as? String ?? ""
//        payment_id = dictionary["payment_id"] as? String ?? ""
//        book_status = String(dictionary["book_status"] as? Int ?? 0)
//        referred_person_name = dictionary["referred_person_name"] as? String ?? ""
//        referred_person_id = dictionary["referred_person_id"] as? String ?? ""
//        trainer_amt = dictionary["trainer_amt"] as? String ?? ""
//        school_amt = dictionary["school_amt"] as? String ?? ""
//        referred_amt = dictionary["referred_amt"] as? String ?? ""
        
//        trainerDic = dictionary["trainer"] as? NSDictionary
        
        trainer_data_id = String(dictionary["id"] as? Int ?? 0)
        trainer_instructor_id =  dictionary["instructor_id"] as? String ?? ""
        
        trainer_fname =  dictionary["fname"] as? String ?? ""
        trainer_lname =  dictionary["lname"] as? String ?? ""
        trainer_dob =  dictionary["dob"] as? String ?? ""
        trainer_gender =  dictionary["gender"] as? String ?? ""
        trainer_state =  dictionary["state"] as? String ?? ""
        trainer_state_code =  dictionary["state_code"] as? String ?? ""
        trainer_subrub =  dictionary["subrub"] as? String ?? ""
        trainer_suburb_post_code =  dictionary["suburb_post_code"] as? String ?? ""
        trainer_street_no =  dictionary["street_no"] as? String ?? ""
        trainer_street_name =  dictionary["street_name"] as? String ?? ""
        trainer_postal_code =  dictionary["postal_code"] as? String ?? ""
        trainer_address =  dictionary["address"] as? String ?? ""
        trainer_mobile =  dictionary["mobile"] as? String ?? ""
        trainer_email =  dictionary["email"] as? String ?? ""
        trainer_description =  dictionary["description"] as? String ?? ""
        trainer_driving_license =  dictionary["driving_license"] as? String ?? ""
        trainer_license_state =  dictionary["license_state"] as? String ?? ""
      //  trainer_expiration_date =  dictionay["expiration_date"] as? String ?? ""
        trainer_vehicle_type =  dictionary["vehicle_type"] as? String ?? ""
        trainer_vehicle_model =  dictionary["vehicle_model"] as? String ?? ""
        trainer_profile_pic =  dictionary["profile_pic"] as? String ?? ""
        trainer_star_rating =  dictionary["star_rating"] as? String ?? ""
        trainer_rating_status =  dictionary["rating_status"] as? String ?? ""
        trainer_refral_code =  dictionary["refral_code"] as? String ?? ""
        trainer_priority =  dictionary["priority"] as? String ?? ""
        trainer_creation_date =  dictionary["creation_date"] as? String ?? ""
        trainer_min_fee =  dictionary["min_fee"] as? String ?? ""
        trainer_driving_school_name =  dictionary["driving_school_name"] as? String ?? ""
        trainer_pyement_mode_accepting =  dictionary["pyement_mode_accepting"] as? String ?? ""
        trainer_bank_account_name =  dictionary["bank_account_name"] as? String ?? ""
        trainer_hours_from =  dictionary["hours_from"] as? String ?? ""
        trainer_bank_account_ssb =  dictionary["bank_account_ssb"] as? String ?? ""
        trainer_hours_to =  dictionary["hours_to"] as? String ?? ""
        trainer_account_no =  dictionary["account_no"] as? String ?? ""
        
        
        trainer_experience_year = String(dictionary["experience_year"] as? Int ?? 0)
        trainer_status = String(dictionary["status"] as? Int ?? 0)
        trainer_availability = String(dictionary["availability"] as? Int ?? 0)
    }
}

