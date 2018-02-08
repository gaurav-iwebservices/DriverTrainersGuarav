//
//  LearnerList.swift
//  Driving Trainers
//
//  Created by iws on 1/15/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import Foundation

class LearnerList: NSObject {
  
    init(id:String,package:String,instructorId:String,instructorName:String,lessionName:String,streetNo:String,address:String,status:String,paymentMode:String,requiredInstructorDate:String,time:String,streetName:String,totalLession:String,completedLession:String,referedPersonName:String,remainingLession:String,bookingId:String,referedPersonId:String,duration:String,requiredInstructorTime:String,suburbPostCode:String,amount:String,subrub:String,requestAcceptDate:String,paymentId:String,postalCode:String,bookingDate:String,instructorEmail:String,state:String,studentName:String,studentId:String,studentEmail:String,imgPath:String) {
        
        self.id = id
        self.package = package
        self.instructorId = instructorId
        self.instructorName = instructorName
        self.lessionName = lessionName
        self.streetNo = streetNo
        self.address = address
        self.status = status
        self.paymentMode = paymentMode
        self.requiredInstructorDate = requiredInstructorDate
        self.time = time
        self.streetName = streetName
        self.totalLession = totalLession
        self.completedLession = completedLession
        self.referedPersonName = referedPersonName
        self.remainingLession = remainingLession
        self.bookingId = bookingId
        self.referedPersonId = referedPersonId
        self.duration = duration
        self.requiredInstructorTime = requiredInstructorTime
        self.suburbPostCode = suburbPostCode
        self.amount = amount
        self.subrub = subrub
        self.requestAcceptDate = requestAcceptDate
        self.paymentId = paymentId
        self.postalCode = postalCode
        self.bookingDate = bookingDate
        self.instructorEmail = instructorEmail
        self.state = state
        self.studentName = studentName
        self.studentId = studentId
        self.studentEmail = studentEmail
        self.imgPath = imgPath
        
    }
    
    var id:String!
    var package:String!
    var instructorId:String!
    var instructorName:String!
    var lessionName:String!
    var streetNo:String!
    var address:String!
    var status:String!
    var paymentMode:String!
    var requiredInstructorDate:String!
    var time:String!
    var streetName:String!
    var totalLession:String!
    var completedLession:String!
    var referedPersonName:String!
    var remainingLession:String!
    var bookingId:String!
    var referedPersonId:String!
    var duration:String!
    var requiredInstructorTime:String!
    var suburbPostCode:String!
    var amount:String!
    var subrub:String!
    var requestAcceptDate:String!
    var paymentId:String!
    var postalCode:String!
    var bookingDate:String!
    var instructorEmail:String!
    var state:String!
    var studentName:String!
    var studentId:String!
    var studentEmail:String!
    var imgPath:String!
}
