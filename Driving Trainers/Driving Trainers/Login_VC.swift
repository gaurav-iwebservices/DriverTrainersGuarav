//
//  Login_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 12/18/17.
//  Copyright © 2017 iWeb. All rights reserved.
//

import UIKit
import SwiftyJSON
import NVActivityIndicatorView
import FacebookLogin
import FacebookCore
import NotificationBannerSwift


class Login_VC: UIViewController,GIDSignInUIDelegate {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var logoImage: UIImageView!

    
    @IBOutlet weak var subView_1: UIView!
    @IBOutlet weak var subViewTop: UIView!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_pass: UITextField!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var btn_facebook: UIButton!
    @IBOutlet weak var btn_gmail: UIButton!
    var userType:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
        logoImage.layer.cornerRadius = 5
        logoImage.layer.masksToBounds = true
        logoImage.layer.shadowColor = UIColor.black.cgColor
        logoImage.layer.shadowOpacity = 0.3
        logoImage.layer.shadowOffset = CGSize.zero
        logoImage.layer.shadowRadius = 10
        GIDSignIn.sharedInstance().uiDelegate = self
        print(UserData.role)
    }
    func createUI() {
        
        btn_login.layer.cornerRadius = btn_login.frame.size.height/2
        Utility.shadowInView(view: shadowView)
        Utility.viewGradient(view: gradientView)
        Utility.underLine(txt: txt_email)
        Utility.underLine(txt: txt_pass)
        Utility.buttonGradient(button: btn_login)
        
        txt_email.text! = "jhon@gmail.com"
        txt_pass.text! = "12345678"
        
        
    }
    
    @IBAction func touch_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func touch_forget(_ sender: Any) {
        let storyBoardid = UIStoryboard(name: "Main", bundle: nil)
        let destVC: Forgetpassword_VC? = storyBoardid.instantiateViewController(withIdentifier: "Forgetpassword_VC_id") as? Forgetpassword_VC
        navigationController?.pushViewController(destVC!, animated: true)
        
    }
    @IBAction func touch_login(_ sender: Any) {
        if (userInputValue())
        {
            self.hitloginAPI()
        }
    }
     func hitloginAPI() {
        
        if (userInputValue())
        {
            let username = txt_email.text!
            let password = txt_pass.text!
            
            let postPayLoad: String = "username="+username+"&"+"password="+password+"role=2"
            
            
            var loginDictionary = [String: Any]()
            loginDictionary["username"] = txt_email.text!
            loginDictionary["password"] = txt_pass.text!
            loginDictionary["role"] = userType
            loginDictionary["device_type"] = "iOS"
            loginDictionary["device_token"] = "dgavdagdf6q3req254fsgfhpfjsf"
            
          //  NVActivityIndicatorView.DEFAULT_TYPE = .orbit
            let activityData = ActivityData()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
            
            DataParser.loginUserDetils(loginDictionary, withCompletionHandler: { (dict, isSuccessfull) in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                if(isSuccessfull)
                {
                    
                    let json = JSON(dict)
                    //self.afterLoginAction(json:json)
                    
                    if json["status"].stringValue == "True" {
                        UserData.firstName = json["data"]["fname"].stringValue
                        UserData.lastName = json["data"]["lname"].stringValue
                        UserData.email = json["data"]["email"].stringValue
                        UserData.Id = json["data"]["id"].stringValue
                        UserData.role = json["data"]["role"].stringValue
                        UserData.socialId = json["data"]["social_id"].stringValue
                        UserData.socialKey = json["data"]["social_key"].stringValue
                        UserData.userStatus = json["data"]["status"].stringValue
                        UserData.userName = json["data"]["username"].stringValue
                        
                        UserDefaults.standard.setValue(UserData.firstName, forKey: "firstName")
                        UserDefaults.standard.setValue(UserData.lastName, forKey: "lastName")
                        UserDefaults.standard.setValue(UserData.email, forKey: "email")
                        UserDefaults.standard.setValue(UserData.Id, forKey: "Id")
                        UserDefaults.standard.setValue(UserData.role, forKey: "role")
                        UserDefaults.standard.setValue(UserData.socialId, forKey: "socialId")
                        UserDefaults.standard.setValue(UserData.socialKey, forKey: "socialKey")
                        UserDefaults.standard.setValue(UserData.userStatus, forKey: "userStatus")
                        UserDefaults.standard.setValue(UserData.userName, forKey: "userName")
                        UserDefaults.standard.setValue("", forKey: "ImgPath")
                        UserDefaults.standard.setValue("yes", forKey: "login")
                        
                        // if UserData.userStatus == "1" {
                        
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
                        //   }
                    }else if json["status"].stringValue == "False"  {
                        let banner = NotificationBanner(title: "Alert", subtitle: json["message"].stringValue, style: .danger)
                        banner.show(queuePosition: .front)
                    }
                    
                   /* let status:String = dict?["status"] as! String
                   print(dict)
                    if (status == "True")
                    {
                        
                        Utility.showAlertMessage(vc: self, titleStr: Defines.alterTitle, messageStr: "Authorised user")
                        

                    }
                    else
                    {
                        Utility.showAlertMessage(vc: self, titleStr: Defines.alterTitle, messageStr: "Un-uthorised user")
                        print(dict!)


                    }*/
                    
                }
                else
                {
                    Utility.showAlertMessage(vc: self, titleStr: Defines.alterTitle, messageStr: Defines.loginErrorMessage)
                }
                
            })
        }
        
    }

    func afterLoginAction(json:JSON){
        
        if json["status"].stringValue == "True" {
            UserData.firstName = json["data"][0]["fname"].stringValue
            UserData.lastName = json["data"][0]["lname"].stringValue
            UserData.email = json["data"][0]["email"].stringValue
            UserData.Id = json["data"][0]["id"].stringValue
            UserData.role = json["data"][0]["role"].stringValue
            UserData.socialId = json["data"][0]["social_id"].stringValue
            UserData.socialKey = json["data"][0]["social_key"].stringValue
            UserData.userStatus = json["data"][0]["status"].stringValue
            UserData.userName = json["data"][0]["username"].stringValue
            
            UserDefaults.standard.setValue(UserData.firstName, forKey: "firstName")
            UserDefaults.standard.setValue(UserData.lastName, forKey: "lastName")
            UserDefaults.standard.setValue(UserData.email, forKey: "email")
            UserDefaults.standard.setValue(UserData.Id, forKey: "Id")
            UserDefaults.standard.setValue(UserData.role, forKey: "role")
            UserDefaults.standard.setValue(UserData.socialId, forKey: "socialId")
            UserDefaults.standard.setValue(UserData.socialKey, forKey: "socialKey")
            UserDefaults.standard.setValue(UserData.userStatus, forKey: "userStatus")
            UserDefaults.standard.setValue(UserData.userName, forKey: "userName")
            UserDefaults.standard.setValue("", forKey: "ImgPath")
            UserDefaults.standard.setValue("yes", forKey: "login")
            
           // if UserData.userStatus == "1" {
            
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
         //   }
        }
    }
    
    @IBAction func touch_facebook(_ sender: Any) {
        
       // loginWithFBbtn.addTarget(self, action: #selector(self.loginButtonClicked), for: UIControlEvents.touchUpInside)
        
        let loginManager = LoginManager()
        loginManager.loginBehavior = LoginBehavior.web
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                
                
                print("Logged in!")
                self.getFBUser()
            }
        }
    }
    
    
    
    func getFBUser() {
        if AccessToken.current != nil {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"], accessToken: AccessToken.current, httpMethod: .POST, apiVersion: GraphAPIVersion.defaultVersion).start({ (response, result) in
                
                print(response as Any)
                print(result)
                
                switch result {
                case .failed(let error):
                    print("error in graph request:", error)
                    break
                case .success(let graphResponse):
                    if let responseDictionary = graphResponse.dictionaryValue {
                        
                        print(JSON(responseDictionary))
                        let valData = JSON(responseDictionary)
                        /*print(responseDictionary["name"] as! String)
                         print(responseDictionary["email"] as! String)
                         print(responseDictionary["picture"]!["data"]["url"] as! String)
                         print(responseDictionary["id"] as! String)*/
                        
                        
                        //var dict: NSDictionary!
                        
                        //dict = responseDictionary["data"] as! NSDictionary
                        //print(dict)
                        //print(dict["url"])
                        UserDefaults.standard.setValue(valData["picture"]["data"]["url"].stringValue, forKey: "ImgPath")
                        let dataDict:[String:String] =  [
                            "firstname": valData["first_name"].stringValue,
                            "lastname": valData["last_name"].stringValue,
                            "email": valData["email"].stringValue,
                            "socialkey":"2", // [1=google,2=facebook]":""
                            "socialid": valData["id"].stringValue,
                            "role":self.userType // [2=trainer,3=learner]
                        ]
                        self.socialAction(data: dataDict)
                        
                    }
                }
            })
        }
    }
    
    func socialAction(data:[String:String]) {
        
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        print(data)
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.socialLoginAPI, dataDict: data, { (json) in
            print(json)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            
            if json["status"].stringValue == "True" {
                self.afterLoginAction(json:json)
                let banner = NotificationBanner(title: "Confirmation", subtitle: json["message"].stringValue , style: .success)
                banner.show(queuePosition: .front)
            }else if json["status"].stringValue == "False" {
                let banner = NotificationBanner(title: "Alert", subtitle: json["message"].stringValue , style: .danger)
                banner.show(queuePosition: .front)
            }
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(error)
        }
        
    }
    
    
    //Google Login
    
    func googleSignIn(){
        TrainerProfile.UserType = self.userType
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    
    @IBAction func touch_gmail(_ sender: Any) {
        self.googleSignIn()
    }
    
    @IBAction func touch_signin(_ sender: Any) {
        let storyBoardid = UIStoryboard(name: "Main", bundle: nil)
        let destVC: Signup_VC? = storyBoardid.instantiateViewController(withIdentifier: "Signup_VC_id") as? Signup_VC
        destVC?.userType = userType
        navigationController?.pushViewController(destVC!, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func userInputValue() -> Bool
    {
        
        
       if (txt_email.text == "")
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Oops! We still need your Email Address.")
            return false
        }
        else if !Utility.emailValidation(txt_email.text!)
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Oops! We still need your valid Email Address.")
            return false
            
        }
        else if (txt_pass.text == "")
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Oops! We still need your Password.")
            return false
        }
        else if ((txt_pass.text?.characters.count)! < 6)
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Password must be more than 6 character")
            return false
        }
            
        
        
        
        
        
        return true
    }


}
