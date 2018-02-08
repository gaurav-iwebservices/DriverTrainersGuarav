//
//  ModelClass.swift
//  Driving Trainers
//
//  Created by iws on 1/13/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import Foundation

class TrainerProfile: NSObject {
    
    static var firstName:String = ""
    static var lastName:String = ""
    static var dob:String!
    static var gender:String!
    static var state:String!
    static var stateCode:String!
    static var subrub:String!
    static var streetNo:String!
    static var streetName:String!
    static var postalCode:String!
    static var mobile:String!
    static var drivingLicense:String!
    static var licenseState:String!
    static var expirationDate:String!
    static var vichleType:String!
    static var vichleModel:String!
    static var experienceYear:String!
    static var drivingSchoolName:String!
    static var address:String!
    static var abn:String!
    static var avaliablity:String!
    static var imagePath :String!
    
    //Bank Information
    static var bankAccName:String!
    static var AccSSB:String!
    static var AccNumber:String!
    
    //Fee Information
    static var feeInfo:String!
    
    //Professional Information
    static var paymentModeAccepting:String!
    static var DiaNumber:String!
    static var DiaExpertationRate:String!
    static var vichleTramissionType:String!
    
    //Description
    static var descriptionStr:String!
    
    //available Info
    static var fromHour:String!
    static var fromTime:String!
    static var toHour:String!
    static var toTime:String!
    static var mon:Int!
    static var tue:Int!
    static var wed:Int!
    static var thu:Int!
    static var fri:Int!
    static var sat:Int!
    static var sun:Int!
    static var all:Int!
    
    
    //Learner List
     static var dataArr:[LearnerList] = []
    
    //Appointment Request Array for appointmentRequest_VC
    static var ARDataArr:[AppointmentRequest] = []
    
    //My Appointment Array for Myappointment if lession Status is  0,1,2
    static var MADataArr:[MyAppointment] = []
    //if lession Status is  3
    static var MACancelledData:[MyAppointment] = []
    //if lession Status is  4
    static var MACompletedData:[MyAppointment] = []
    
    static var UserType:String!
}

class AppointmentRequest: NSObject {
    
    var name:String!
    var date:String!
    var status:String!
    var address:String!
    var student_id:String!
    var lession:String!
    var instructorId:String!
    var bookingId:String!
    init(name:String,date:String,status:String,address:String,student_id:String,lession:String,instructorId:String,bookingId:String) {
        self.name = name
        self.date = date
        self.status = status
        self.address = address
        self.student_id = student_id
        self.lession = lession
        self.instructorId = instructorId
        self.bookingId = bookingId
        
    }
}

class MyAppointment: NSObject {
    
    var name:String!
    var createdDate:String!
    var LessionStatus:String!
    var lessionName:String!
    var student_id:String!
    var bookingId:String!
    var lessionId:String!
    var Id:String!
    init(name:String,createdDate:String,LessionStatus:String,lessionName:String,student_id:String,bookingId:String,lessionId:String,Id:String) {
        self.name = name
        self.createdDate = createdDate
        self.LessionStatus = LessionStatus
        self.lessionName = lessionName
        self.student_id = student_id
        self.bookingId = bookingId
        self.lessionId = lessionId
        self.Id = Id
        
    }
}

class Account:NSObject {
    var name:String!
    var paymentStatus:String!
    var bookingId:String!
    var trainerAmt:String!
    var paymentMode:String!
    var lessionName:String!
    var referredBy:String!
    
    init(name:String,paymentStatus:String,bookingId:String,trainerAmt:String,paymentMode:String,lessionName:String,referredBy:String ) {
        self.name = name
        self.paymentMode = paymentMode
        self.paymentStatus = paymentStatus
        self.bookingId = bookingId
        self.trainerAmt = trainerAmt
        self.lessionName = lessionName
        self.referredBy = referredBy
    }
}

class Task: NSObject {
    var taskName:String!
    var taskId:String!
    var taskScore:String!
    
    init(taskName:String,taskId:String,taskScore:String) {
        self.taskId = taskId
        self.taskName = taskName
        self.taskScore = taskScore
    }
}


class UserData: NSObject {
    static var email:String!
    static var firstName:String!
    static var lastName:String!
    static var Id:String!
    static var role:String! // 2- trainer and 3 learner
    static var userStatus:String!
    static var socialId:String!
    static var socialKey:String!
    static var userName:String!
    static var imgPath:String!
    static var stateList:[State] = []
    static var suburbList:[Suburb] = []
}

class General: NSObject {
    static var myProfileEdit:Bool = false //Used for my Profile
}

