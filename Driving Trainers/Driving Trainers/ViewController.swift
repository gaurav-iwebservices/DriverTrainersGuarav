//
//  ViewController.swift
//  Driving Trainers
//
//  Created by iWeb on 12/18/17.
//  Copyright © 2017 iWeb. All rights reserved.
//

import UIKit
import SQLite3
import NVActivityIndicatorView

//internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
//internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

class ViewController: UIViewController {
    var stateListArray:[Any] = []

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var btn_trainer: UIButton!
    
    @IBOutlet weak var btn_learner: UIButton!
   
    
    override func viewDidLoad() {
        
       // self.getSuburbData()
       // self.getStateData()
        
        super.viewDidLoad()
        self.getBaseUrl()
        
       
        self.navigationController?.navigationBar.isHidden = true
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        logoImage.layer.cornerRadius = 5
        logoImage.layer.masksToBounds = true
        logoImage.layer.shadowColor = UIColor.black.cgColor
        logoImage.layer.shadowOpacity = 0.3
        logoImage.layer.shadowOffset = CGSize.zero
        logoImage.layer.shadowRadius = 10
        
        
        
        //Utility.CreateTable()
    }
    
    func getBaseUrl() {
        
        if Reachability.isConnectedToNetwork() == false {
            
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataProvider.sharedInstance.getDataUsingGet(path: "http://cmsbox.in/master/drivingschool.php", { (json) in
            print(json)
            
            
            
            Defines.ServerUrl = json["baseurl"].stringValue
            self.checkAlreadyLogin()
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            
           /* var stateApi:String = ""
            if let temp  = UserDefaults.standard.string(forKey: "stateApi") {
                stateApi = temp
            }
            
            if stateApi != "yes" {*/
                //self.getSuburbData()
                //self.getStateData()
            //}
            
            
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(error)
        }
    }
    
    
    func getSuburbData() {
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataProvider.sharedInstance.getDataUsingGet(path: Defines.ServerUrl + Defines.suburbAPI, { (json) in
            print(json)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
           UserData.suburbList = []
            if json["status"].stringValue == "True" {
                for i in 0 ..< json["data"].arrayValue.count {
                    if json["data"][i]["type"].stringValue == "Suburb" {
                        UserData.suburbList.append(Suburb.init(
                            name: json["data"][i]["name"].stringValue,
                            stateCode: json["data"][i]["state_code"].stringValue,
                            type: json["data"][i]["type"].stringValue,
                            postCode: json["data"][i]["postcode"].stringValue,
                            id: json["data"][i]["id"].stringValue
                        ))
                    }
                }
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            
         
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(error)
        }
    }
    
    func getStateData() {
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataProvider.sharedInstance.getDataUsingGet(path: Defines.ServerUrl + Defines.stateAPI, { (json) in
            print(json)
            
            if json["status"].stringValue == "True" {
                UserData.stateList = []
                    for i in 0 ..< json["data"].arrayValue.count {
                        UserData.stateList.append(State.init(
                            name: json["data"][i]["name"].stringValue,
                            state: json["data"][i]["state"].stringValue,
                            postCode: json["data"][i]["postcode"].stringValue,
                            stateCode: json["data"][i]["state_code"].stringValue,
                            id: json["data"][i]["id"].stringValue
                        ))
                    }
            }
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
          
            
        }) { (error) in
             NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(error)
        }
    }
    
    func checkAlreadyLogin() {
        
        var Login:String = ""
        if let temp  = UserDefaults.standard.string(forKey: "login") {
            Login = temp
        }
        // check user alerdy login or not
        
        if Login == "yes" {
            if let temp = UserDefaults.standard.string(forKey: "firstName") {
                UserData.firstName = temp
            }
            if let temp = UserDefaults.standard.string(forKey: "lastName") {
                UserData.lastName = temp
            }
            if let temp =  UserDefaults.standard.string(forKey: "email") {
                UserData.email = temp
            }
            if let temp = UserDefaults.standard.string(forKey: "Id") {
                UserData.Id = temp
            }
            
            if let temp = UserDefaults.standard.string(forKey: "role") {
                UserData.role = temp
            }
            if let temp = (UserDefaults.standard.string(forKey: "socialId"))  {
                UserData.socialId = temp
            }
            if let temp = UserDefaults.standard.string(forKey: "socialKey") {
                UserData.socialKey = temp
            }
            if let temp = UserDefaults.standard.string(forKey: "userStatus") {
                UserData.userStatus = temp
            }
            
            if let temp = UserDefaults.standard.string(forKey: "userName") {
                UserData.userName = temp
            }
            if let temp = UserDefaults.standard.string(forKey: "ImgPath") {
                UserData.imgPath = temp
            }
            
       
            if UserData.role == "2" {
                let storyBoard = UIStoryboard(name: "Trainer", bundle: nil) as UIStoryboard
                let mfSideMenuContainer = storyBoard.instantiateViewController(withIdentifier: "MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
                let dashboard = storyBoard.instantiateViewController(withIdentifier: "Dashboard_VC") as! UINavigationController
                let leftSideMenuController = storyBoard.instantiateViewController(withIdentifier: "TrainerRoot_VC_id") as! TrainerRoot_VC
                mfSideMenuContainer.leftMenuViewController = leftSideMenuController
                mfSideMenuContainer.centerViewController = dashboard
                let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = mfSideMenuContainer
                
            }else{
                
                
                let storyBoard = UIStoryboard(name: "Learner", bundle: nil) as UIStoryboard
                let storyBoard1 = UIStoryboard(name: "Trainer", bundle: nil) as UIStoryboard

                let mfSideMenuContainer = storyBoard1.instantiateViewController(withIdentifier: "MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
                let dashboard = storyBoard.instantiateViewController(withIdentifier: "LearnerRoot_id") as! UINavigationController
                let leftSideMenuController = storyBoard.instantiateViewController(withIdentifier: "LearnerRoot_VC_id") as! LearnerRoot_VC
                mfSideMenuContainer.leftMenuViewController = leftSideMenuController
                mfSideMenuContainer.centerViewController = dashboard
                let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = mfSideMenuContainer
                
                
                
            }
        }
    }
    
    
    @IBAction func trainerAction(_ sender: UIButton) {
        sender.setImage(UIImage(named:"trainner_red"), for: UIControlState.highlighted)
        let storyBoardid = UIStoryboard(name: "Main", bundle: nil)
        let destVC: Login_VC? = storyBoardid.instantiateViewController(withIdentifier: "Login_VC_id") as? Login_VC
        destVC?.userType = "2"
        UserData.role = "2"
        navigationController?.pushViewController(destVC!, animated: true)
    }
    
    @IBAction func learnerAction(_ sender: UIButton) {
        sender.setImage(UIImage(named:"driver-red"), for: UIControlState.highlighted)
        let storyBoardid = UIStoryboard(name: "Main", bundle: nil)
        let destVC: Login_VC? = storyBoardid.instantiateViewController(withIdentifier: "Login_VC_id") as? Login_VC
        destVC?.userType = "3"
        UserData.role = "3"
        navigationController?.pushViewController(destVC!, animated: true)
    }
    
  


}

