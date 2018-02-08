//
//  DataManger.swift
//  NicoBeacon
//
//  Created by Vinay on 22/08/17.
//  Copyright © 2017 iWeb. All rights reserved.
//

import UIKit

class DataManger: NSObject
{
    var loginObj: LoginModel?
    
    var database: OpaquePointer?
    
    var isFromLessonPackage: Bool = false
    
    var isFromProgress: Bool = false

    
    var isFromLearnerShedule: Bool = false


    
    var  currentDate: String = ""
    var  todaysDate: String = ""
    
    var  profileImageUrl: String = ""
    var  profileImageName: String = ""
    var postal_Code: String = ""

    var  profileFname: String = ""
    var  profileLname: String = ""

    var  imageProgressUrl: String = ""

    
    var serverDate: String = ""
    var totalAanwers: Int = 0
    var totalCompletedTasks: Int = 0
    
    
    var user_has_find_job: String = ""
    
    var visitedMyTasks: Bool = false
    
    var isFromProceedBtn: Bool = false
    
    var isNotificationRecived: Bool = false
    
    var deviceToken: String = ""
    
    
    static let _gDataManager = DataManger.sharedInstance
    static let sharedInstance: DataManger =
    {
        let instance = DataManger()
            // setup code
         return instance
    }()
   
}
