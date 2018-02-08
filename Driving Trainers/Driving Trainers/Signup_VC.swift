//
//  Signup_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 12/18/17.
//  Copyright © 2017 iWeb. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SQLite3
import FacebookLogin
import FacebookCore
import SwiftyJSON
import GoogleSignIn
import NotificationBannerSwift



class Signup_VC: UIViewController ,GIDSignInUIDelegate{
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var txt_fName: UITextField!
    @IBOutlet weak var txt_lName: UITextField!
    @IBOutlet weak var txt_mobile: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_dob: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_sub: UITextField!
    
    @IBOutlet weak var txt_state: UITextField!
    @IBOutlet weak var subView_2: UIView!
    @IBOutlet weak var txt_gender: UITextField!
    @IBOutlet weak var btn_signup: UIButton!
    var userType:String!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    var postCode:[String] = []
    var postString = ""
    var stateCode = ""
    var tmpTextField:UITextField!
    var SuburbList:[Suburb] = []
    var agree = false
    override func viewDidLoad() {
        
    
        self.getStateData()
        super.viewDidLoad()
        self.createUI()
        /*if(Utility.openDataBase())
        {
            //self.seletDB()
        }*/

        // Do any additional setup after loading the view.
        txt_dob.addTarget(self, action: #selector(self.datePicker(_:)), for: UIControlEvents.editingDidBegin)
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    func createUI() {
        btn_signup.layer.cornerRadius = btn_signup.frame.size.height/2
        Utility.viewGradient(view: gradientView)
        Utility.shadowInView(view: subView_2)
        Utility.buttonGradient(button: btn_signup)

        Utility.underLine(txt: txt_fName)
        Utility.underLine(txt: txt_lName)
        Utility.underLine(txt: txt_email)
        Utility.underLine(txt: txt_mobile)
        Utility.underLine(txt: txt_dob)
        Utility.underLine(txt: txt_gender)
        Utility.underLine(txt: txt_sub)
        Utility.underLine(txt: txt_password)
        Utility.underLine(txt: txt_state)
        
        txt_fName.delegate = self
        txt_lName.delegate = self
        txt_email.delegate = self
        txt_mobile.delegate = self
        txt_gender.delegate = self
        txt_sub.delegate = self
        txt_password.delegate = self
        txt_state.delegate = self
        
        self.setImageInTextField(textField: txt_dob, image: "calender")
        self.setImageInTextField(textField: txt_gender, image: "dropdown")
        self.setImageInTextField(textField: txt_sub, image: "dropdown")
        self.setImageInTextField(textField: txt_state, image: "dropdown")
    }
    
    func  setImageInTextField(textField:UITextField, image:String) {
        textField.rightViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: image)
        imageView.image = image
        textField.rightView = imageView
    }
    
    @IBAction func agreeAction(_ sender: UIButton) {
        if agree == false {
            agree = true
            sender.setImage(UIImage(named:"checked"), for: UIControlState.normal)
        }else if agree == true {
            agree = false
            sender.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
        }
    }
    
    func getSuburbData() {
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let data = [ "state_code":stateCode]
        
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.suburbAPI, dataDict: data, { (json) in
            print(json)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if json["status"].stringValue == "True" {
                var suburbArr:[String] = []
                for i in 0 ..< json["data"].arrayValue.count {
                    if json["data"][i]["type"].stringValue == "suburb" {
                        self.SuburbList.append(Suburb.init(
                            name: json["data"][i]["name"].stringValue,
                            stateCode: json["data"][i]["state_code"].stringValue,
                            type: json["data"][i]["type"].stringValue,
                            postCode: json["data"][i]["postcode"].stringValue,
                            id: json["data"][i]["id"].stringValue
                        ))
                        
                        suburbArr.append(json["data"][i]["name"].stringValue)
                    }
                }
                
                if UserData.role == "2" {
                    self.dropDownForTrainer(self.txt_sub, selector:suburbArr)
                }else {
                    self.dropDown(self.txt_sub, selector: suburbArr)
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
                        name: json["data"][i]["state"].stringValue, // name
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
    
    
    @IBAction func back_Touch(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func datePicker(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        
            var minimumDate: Date {
                return (Calendar.current as NSCalendar).date(byAdding: .year, value: -15, to: Date(), options: [])!
            }
            
            var maximumDate: Date {
                return (Calendar.current as NSCalendar).date(byAdding: .year, value: -65, to: Date(), options: [])!
            }
            
            datePickerView.maximumDate = minimumDate
            datePickerView.minimumDate = maximumDate
            datePickerView.addTarget(self, action: #selector(handleDatePickerforDOB(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePickerforDOB(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        txt_dob.text = dateFormatter.string(from: sender.date)
    }
    
    
    
    @IBAction func signup_touch(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func facebook_touch(_ sender: Any) {
        
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
                            
                            var dataDict:[String:String] =  [
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
            
          //  if UserData.userStatus == "1" {
            
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
          //  }
        }
    }
    
  
    //Google Login
    
    func googleSignIn(){
        TrainerProfile.UserType = self.userType
        GIDSignIn.sharedInstance().signIn()
        
    }
    
   /* func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }*/

    
    
    
   
    
        
    @IBAction func gmail_touch(_ sender: Any) {
        /*let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
        let destVC: Dashboard_VC? = storyBoardid.instantiateViewController(withIdentifier: "Dashboard_VC_id") as? Dashboard_VC
        
        navigationController?.pushViewController(destVC!, animated: true)*/
        
        self.googleSignIn()
        
       /* let storyBoard = UIStoryboard(name: "Trainer", bundle: nil) as UIStoryboard
        let mfSideMenuContainer = storyBoard.instantiateViewController(withIdentifier: "MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
        let dashboard = storyBoard.instantiateViewController(withIdentifier: "Dashboard_VC") as! UINavigationController
        let leftSideMenuController = storyBoard.instantiateViewController(withIdentifier: "TrainerRoot_VC_id") as! TrainerRoot_VC
        mfSideMenuContainer.leftMenuViewController = leftSideMenuController
        mfSideMenuContainer.centerViewController = dashboard
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = mfSideMenuContainer*/
        
    }
    @IBAction func signin_touch(_ sender: Any) {
        if (userInputValue())
        {
            self.hitsighupAPI()
        }
    }
    
    
    @IBAction func signUpBtnAction(_ sender: UIButton) {
        self.signUpAction()
    }
    
    func signUpAction(){
        let dataDict:[String:String] = [
            "firstname":txt_fName.text!,
            "lastname":txt_lName.text!,
            "email": txt_email.text!,
            "mobile": txt_mobile.text!,
            "dateofbirth": txt_dob.text!,
            "gender": txt_gender.text!,
            "state": stateCode,
            "suburb": postString,
            "role": userType,
            "password": txt_password.text!
        ]
        print("Send Data")
        
        print(dataDict)

        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
 
        
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.registrationAPI, dataDict: dataDict, { (json) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(json)
            
            if json["status"].stringValue == "True" {
                
                /*UserData.firstName = self.txt_fName.text!
                UserData.lastName = self.txt_lName.text!
                UserData.email = self.txt_email.text!
                UserData.role = self.userType
              
                
                UserDefaults.standard.setValue(UserData.firstName, forKey: "firstName")
                UserDefaults.standard.setValue(UserData.lastName, forKey: "lastName")
                UserDefaults.standard.setValue(UserData.email, forKey: "email")
                UserDefaults.standard.setValue(UserData.Id, forKey: "Id")
                UserDefaults.standard.setValue(UserData.role, forKey: "role")
                UserDefaults.standard.setValue(UserData.socialId, forKey: "socialId")
                UserDefaults.standard.setValue(UserData.socialKey, forKey: "socialKey")
                UserDefaults.standard.setValue(UserData.userStatus, forKey: "userStatus")
                UserDefaults.standard.setValue(UserData.userName, forKey: "userName")
                UserDefaults.standard.setValue("yes", forKey: "login")*/
                let banner = NotificationBanner(title: "Confirmation", subtitle: json["message"].stringValue , style: .success)
                banner.show(queuePosition: .front)
                
            }else{
                
                
                
                    let banner = NotificationBanner(title: "Alert", subtitle: json["message"].stringValue , style: .danger)
                    banner.show(queuePosition: .front)
            }
            
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(error)
        }
        
    }
    
    
    func hitsighupAPI() {
        
//        let firstName = txt_fName.text
//        let lastName = txt_lName.text
//         let email = txt_email.text
//        let telephone = txt_mobile.text
//        let dob = txt_dob.text
//        let password = txt_password.text
//
//
//        NVActivityIndicatorView.DEFAULT_TYPE = .orbit
//        let activityData = ActivityData()
//        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
//        let postPayLoad: String = "name="+userName!+"&"+"email="+email!+"&"+"telephone="+telephone!+"&"+"DOB="+dob!+"&"+"password="+password!+"&"+"confirm="+password!+"&"+"agree=1"+"&"+"image="+imageString
//
//            print(postPayLoad)
//
//            DataParser.signUpForUserDeatils(postPayLoad, withCompletionHandler: { (dict, isSuccessfull) in
//
//                if isSuccessfull
//                {
//                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
//                    if let status = dict?["status"] as? String
//                    {
//                        if(status=="success")
//                        {
//                            self.showAlert(string: (dict?["msg"] as? String)!)
//                        }
//                        else
//                        {
//                            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: (dict?["msg"] as? String)!)
//                        }
//                    }
//                }
//                else
//                {
//                    MyLoader.hideLoadingView()
//                    Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Sorry! you required Internet Connection.")
//                }
//
//            })
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func seletDB()
        
    {
        let queryStatementString = "SELECT * FROM StateList"
        
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(DataManger._gDataManager.database, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    let queryResultCol0 = sqlite3_column_text(queryStatement, 1)
                    let statename = String(cString: queryResultCol0!)
                    
                    let queryResultCol1 = sqlite3_column_text(queryStatement, 3)
                    let urnbaname = String(cString: queryResultCol1!)
                    
                    // 5
                    print("state Name from DB")
                    print("\(statename) | \(urnbaname)")
                    
                }
                
            } else {
                print("Query returned no results")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
    }
    

    
    func userInputValue() -> Bool
    {
        
        
        if (txt_fName.text == "")
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Oops! We still need your First Name.")
            return false
        }
        else if (txt_lName.text == "")
        {
           Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Oops! We still need your Last Name.")
            return false
        }
        else if (txt_email.text == "")
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Oops! We still need your Email Address.")
            return false
        }
        else if !Utility.emailValidation(txt_email.text!)
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Oops! We still need your valid Email Address.")
            return false
            
        }
        else if (txt_password.text == "")
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Oops! We still need your Password.")
            return false
        }
        else if ((txt_password.text?.characters.count)! < 6)
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Password must be more than 6 character")
            return false
        }
            
        else if (txt_mobile.text == "")
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Oops! We still need your Phone number")
            return false
        }
            
        else if (txt_dob.text == "")
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Oops! We still need your Birth Date.")
            return false
        }
        
        
        
        
        return true
    }
    
   

}

extension Signup_VC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txt_gender {
            self.dropDown(textField, selector: ["Male","Female"])
            return false
        }else if textField == txt_state {
            
            var stateArr:[String] = []
            for i in 0..<UserData.stateList.count {
                stateArr.append(UserData.stateList[i].name)
            }
            self.dropDown(textField, selector:stateArr)
            return false
        }else if textField == txt_sub {
            
            self.getSuburbData()
            
            
            return false
        }else{
            return true
        }
    }
}

extension Signup_VC : UIPopoverPresentationControllerDelegate,PopUpViewControllerDelegate {
    
    func dropDown(_ textField:UITextField , selector:[String]) {
        let storyBoard = UIStoryboard(name: "Trainer", bundle: nil)
        let popController = storyBoard.instantiateViewController(withIdentifier: "PopUpViewController") as!  PopUpViewController
        popController.delegate = self
        popController.arr = selector
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = textField
        popController.popoverPresentationController?.sourceRect = textField.bounds
        popController.preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 50, height: 250)
        self.present(popController, animated: true, completion: nil)
        tmpTextField = textField
    }
    
    func dropDownForTrainer(_ textField:UITextField , selector:[String]) {
        let storyBoard = UIStoryboard(name: "Trainer", bundle: nil)
        let popController = storyBoard.instantiateViewController(withIdentifier: "MultipleSelectorPopUp_VC_id") as!  MultipleSelectorPopUp_VC
        popController.delegate = self
        popController.arr = selector
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = textField
        popController.popoverPresentationController?.sourceRect = textField.bounds
        popController.preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 50, height: 300)
        self.present(popController, animated: true, completion: nil)
        tmpTextField = textField
    }
    
    func saveString(_ strText: String) {
        tmpTextField.text = strText
    }
    func idString(_ strText: String) {
        
        if tmpTextField == self.txt_sub {
        print(strText)
        let arr = strText.components(separatedBy: ",")
        print(arr)
        postString = ""
        for i in 0..<arr.count {
            if i == 0 {
                postString = SuburbList[Int(arr[i])!].postCode
            }else{
                postString = postString + "," +  SuburbList[Int(arr[i])!].postCode
            }
        }
        
        print(postString)
        }else if tmpTextField == self.txt_state {
            //stateCode = postCode[Int(strText)!]
             stateCode = getStateCode().stateCode
        }
    }
    func getTagOfTable(_ tblTag : Int, _ indexValue : String) {
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle{
        return UIModalPresentationStyle.none
    }
    
    func getStateCode()  -> State {
        var stateString:State!
        for i in 0..<UserData.stateList.count {
            if UserData.stateList[i].name == txt_state.text! {
               return UserData.stateList[i]
            }
        }
        return stateString
    }
    
    func getSuburbList(stateCode:String)  {
        
        SuburbList =  UserData.suburbList.filter { (temp:Suburb) -> Bool in
            return temp.stateCode.lowercased().contains(stateCode.lowercased())
        }
    }
    
}
