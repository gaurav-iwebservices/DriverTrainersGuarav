//
//  Defines.swift
//  NicoBeacon
//
//  Created by Vinay on 21/08/17.
//  Copyright © 2017 iWeb. All rights reserved.
//

import UIKit

class Defines: NSObject
{
    // MARK: Message
    
    
    static let kStartColor = UIColor(red: 179.0/255.0, green: 18.0/255.0, blue: 23.0/255.0, alpha: 1.0).cgColor
    static let kEndColor = UIColor(red: 246.0/255.0, green: 106.0/255.0, blue: 101.0/255.0, alpha: 1.0).cgColor
    
     static let kTextViewUnderLineColor = UIColor.gray.cgColor
    
    static let alterTitle = "Alert!"
    static let successTitle = "Success!"
    static let loginErrorMessage = "Please check your internet connection"
    static let underDevelopmentMessageMessage = "Underdevelopment"

    static let networkErrorMessage = "Please check your internet connection"
    static let deleteDeviceAlertMessage = "Are you sure to remove this device?"
    
    // MARK: API
    
    static var ServerUrl = "http://cmsbox.in/app/drivingschool/api/"
    //static var ServerUrl = "http://cmsbox.in/app/drivingschoolv2/"
    
    static let loginAPI = "webservices/login.json"
    static let forgotPasswordAPI = "webservices/forgetpass.json"
    static let packagesLessonsAPI = "webservices/packagesLessons.json"

    static let suburbAPI = "webservices/suburbList.json"
    static let aboutUsAPI = "webservices/aboutus.json"
    static let changePassword = "webservices/changepassword.json"
    static let stateAPI = "webservices/stateList.json"
    static let registrationAPI = "webservices/register.json"
    static let contactUsAPI = "webservices/contactus.json"
    static let socialLoginAPI = "webservices/socialLogin.json"

    //MARK: Trainer API
    
    static let dashboardTrainerAPI = "trainer/dashboard.json"
    static let addLearner = "Trainer/AddLerner.json"
    static let learnerList = "Trainer/lernerList.json"
    static let trainnerProfileAPI = "Trainer/profileView.json"
    static let appointmentRequest = "Trainer/appointmentRequest.json"
    static let ApptRequestAccept = "Trainer/requestAccept.json"
    static let trainerAppointmentList = "Trainer/myAppoinmentlist.json"
    static let appointmentScheduleReschedule = "webservices/schedule.json"
    static let accountAPI = "Trainer/myAccount.json"
    static let updateAPI = "Trainer/updateProfile.json"
    static let viewProgress = "Trainer/viewPrgress.json"
    static let addProgress = "trainer/addPrgress.json"
    
    //MARK: Learner API
    static let learnerProfile = "Lerner/viewProfile.json"
    static let bookingAPI = "Lerner/book_appoinment.json"
    static let myBookingListAPI = "Lerner/myBookingList.json"
    static let myAppoinmentListAPI = "Lerner/myAppoinment.json"
    static let myInvoiceListAPI = "Lerner/invoiceList.json"
    static let myViewPRofileLearnerAPI = "Lerner/viewProfile.json"
    static let updateProfileLearnerAPI = "Lerner/updateProfile.json"
    static let TrainerListAPI = "Lerner/trainerList.json"
    static let addFeedBack = "Lerner/addfeedback.json"

}
