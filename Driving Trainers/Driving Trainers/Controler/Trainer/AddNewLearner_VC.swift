//
//  AddNewLearner_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 08/01/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import NVActivityIndicatorView

class AddNewLearner_VC: UIViewController {
    
    
    var packagListArray:[Any] = []
    var packageListArray:[Any] = []
    var priceList:[String] = []
    var packageID:Int!
    var lessionID:Int!
    
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var stateText: UITextField!
    @IBOutlet weak var emailIdText: UITextField!
    @IBOutlet weak var timeText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var postcodeText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var mobileText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var referedText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var lessionTypeText: UITextField!
    @IBOutlet weak var packageText: UITextField!
    @IBOutlet weak var suburbText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backroundView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var dobText: UITextField!
    
    @IBOutlet weak var streetNoText: UITextField!
    @IBOutlet weak var streetNameText: UITextField!
    @IBOutlet weak var langaugeText: UITextField!
    @IBOutlet weak var currentLicenseText: UITextField!
    @IBOutlet weak var licenseNoText: UITextField!
    @IBOutlet weak var paymentModeText: UITextField!
    
    
    var tmpTextField:UITextField!
    var gender:String!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getlessionPackeageAPI()
        
        submitButton.layer.cornerRadius = submitButton.frame.size.height/2
        Utility.shadowInView(view: backroundView)
        Utility.buttonGradient(button: submitButton)
        Utility.viewGradient(view: gradientView)
        Utility.navigationBarView(view: navigationView)
        navigationController?.navigationBar.isHidden = true
        
        self.setImageInTextField(textField: suburbText)
        self.setImageInTextField(textField: referedText)
        self.setImageInTextField(textField: lessionTypeText)
        self.setImageInTextField(textField: packageText)
        self.setImageInTextField(textField: dateText)
        self.setImageInTextField(textField: stateText)
        self.setImageInTextField(textField: dobText)
        self.setImageInTextField(textField: currentLicenseText)
        self.setImageInTextField(textField: timeText )
        
        streetNoText.delegate = self
        streetNameText.delegate = self
        langaugeText.delegate = self
        currentLicenseText.delegate = self
        licenseNoText.delegate = self
        paymentModeText.delegate = self
        stateText.delegate = self
        emailIdText.delegate = self
        priceText.delegate = self
        postcodeText.delegate = self
        addressText.delegate = self
        mobileText.delegate = self
        lastNameText.delegate = self
        firstNameText.delegate = self
        referedText.delegate = self
        lessionTypeText.delegate = self
        packageText.delegate = self
        suburbText.delegate = self
        
        timeText.addTarget(self, action: #selector(self.datePicker(_:)), for: UIControlEvents.editingDidBegin)
        dobText.addTarget(self, action: #selector(self.datePicker(_:)), for: UIControlEvents.editingDidBegin)
        dateText.addTarget(self, action: #selector(self.datePicker(_:)), for: UIControlEvents.editingDidBegin)
        maleBtn.addTarget(self, action: #selector(self.selectGenderAction(sender:)), for: UIControlEvents.touchUpInside)
        femaleBtn.addTarget(self, action: #selector(self.selectGenderAction(sender:)), for: UIControlEvents.touchUpInside)
        
        
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
    }

    func  setImageInTextField(textField:UITextField) {
        textField.rightViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        if textField == dobText || textField == dateText  || textField == timeText {
            imageView.image = UIImage(named: "calender")
        }else{
            imageView.image = UIImage(named: "dropdown")
        }
        textField.rightView = imageView
    }
    
   
    @IBAction func datePicker(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        
        if sender == dobText {
            var minimumDate: Date {
                return (Calendar.current as NSCalendar).date(byAdding: .year, value: -15, to: Date(), options: [])!
            }
            
            var maximumDate: Date {
                return (Calendar.current as NSCalendar).date(byAdding: .year, value: -65, to: Date(), options: [])!
            }
            
            datePickerView.maximumDate = minimumDate
            datePickerView.minimumDate = maximumDate
            datePickerView.addTarget(self, action: #selector(handleDatePickerforDOB(sender:)), for: .valueChanged)
        }else if sender == dateText {
            datePickerView.datePickerMode = .date
            var minimumDate: Date {
                return (Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to: Date(), options: [])!
            }
            datePickerView.minimumDate = minimumDate
            datePickerView.addTarget(self, action: #selector(handleDatePickerforDate(sender:)), for: UIControlEvents.valueChanged)
        }else if sender == timeText {
            datePickerView.datePickerMode = .time
            datePickerView.addTarget(self, action: #selector(handleDatePickerforTime(sender:)), for: UIControlEvents.valueChanged)
        }
    }
    
    //@IBAction func timePicker(_ sender: UITextField) {}
    
    @objc func handleDatePickerforDOB(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dobText.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func handleDatePickerforDate(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateText.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func handleDatePickerforTime(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:MM a"
        timeText.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func selectGenderAction(sender:UIButton) {
        if sender == maleBtn {
            gender = "male"
            sender.setImage(UIImage(named:"radioSelected"), for: UIControlState.normal)
            femaleBtn.setImage(UIImage(named:"radio"), for: UIControlState.normal)
        }else if sender == femaleBtn {
            gender = "female"
            sender.setImage(UIImage(named:"radioSelected"), for: UIControlState.normal)
            maleBtn.setImage(UIImage(named:"radio"), for: UIControlState.normal)
        }
    }
    
   
    @IBAction func submitBtnAction(_ sender: UIButton) {
        
        if Validation() == false {
            return
        }
        
        var refered:String = ""
        
        if referedText.text! == "System" {
            refered = "System"
        }else{
            refered = UserData.Id
        }
       
        
        let data:[String:Any] = [
            "referid" : refered,
            "firstname":firstNameText.text!,
            "lastname":lastNameText.text!,
            "gender": gender,
            "email": emailIdText.text!,
            "mobile": mobileText.text!,
            "dob": dobText.text!,
            "package_id":packageID,
            "lesson_id":lessionID,
            "date": dateText.text!,
            "time": timeText.text!,
            "postal_code": postcodeText.text!,
            "state": stateText.text!,
            "suburb": suburbText.text!,
            "street_no": streetNoText.text!,
            "street_name": streetNameText.text!,
            "language": langaugeText.text!,
            "current_license": currentLicenseText.text!,
            "license_no": licenseNoText.text!,
            "address": addressText.text!
            
            
        ]
       
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.addLearner, dataDict: data, { (json) in
             NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(json)
            
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
    
    
    func Validation() -> Bool  {
        if firstNameText.text!.count == 0 {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "First name field should not be blank.")
            //firstNameText.becomeFirstResponder()
            return false
        }else if gender == ""{
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Please select gender.")
            return false
        }else if emailIdText.text!.count == 0{
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Email Address field should not be blank.")
            //emailIdText.becomeFirstResponder()
            return false
        }else if mobileText.text!.count == 0{
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Mobile Number field should not be blank.")
           // mobileText.becomeFirstResponder()
            return false
        }else if dobText.text!.count == 0{
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Date of birth field should not be blank.")
            //dobText.becomeFirstResponder()
            return false
        }else if dateText.text!.count == 0{
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Date field should not be blank.")
          //  dateText.becomeFirstResponder()
            return false
        }else if timeText.text!.count == 0{
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Time field should not be blank.")
            //timeText.becomeFirstResponder()
            return false
        }else if postcodeText.text!.count == 0{
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Post Code should not be blank.")
           // postcodeText.becomeFirstResponder()
            return false
        }else if stateText.text!.count == 0{
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "State field should not be blank.")
           // stateText.becomeFirstResponder()
            return false
        }else if suburbText.text!.count == 0{
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "suburb field should not be blank.")
           // suburbText.becomeFirstResponder()
            return false
        }else if streetNoText.text!.count == 0{
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Street Number field should not be blank.")
            //streetNoText.becomeFirstResponder()
            return false
        }else if streetNameText.text!.count == 0{
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Street Name field should not be blank.")
           // streetNameText.becomeFirstResponder()
            return false
        }else if langaugeText.text!.count == 0{
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Langauge field should not be blank.")
           // langaugeText.becomeFirstResponder()
            return false
        }else if currentLicenseText.text!.count == 0{
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Current License field should not be blank.")
           // currentLicenseText.becomeFirstResponder()
            return false
        }else if licenseNoText.text!.count == 0{
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "License Number field should not be blank.")
          //  licenseNoText.becomeFirstResponder()
            return false
        }else if addressText.text!.count == 0{
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Address field should not be blank.")
         //   addressText.becomeFirstResponder()
            return false
        }else{
            return true
        }
    }
    
    
    
    func getlessionPackeageAPI() {
        
        let loginDictionary = [String: Any]()
       // NVActivityIndicatorView.DEFAULT_TYPE = .orbit
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataParser.packagesLessonsAPIDetils(loginDictionary,Defines.stateAPI, withCompletionHandler: { (array,array2, isSuccessfull) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if(isSuccessfull)
            {
                self.packagListArray = array as! [Any]
                self.packageListArray = array2 as! [Any]
                
                print("success")
            }
            else
            {
                Utility.showAlertMessage(vc: self, titleStr: Defines.alterTitle, messageStr: Defines.loginErrorMessage)
            }
            
        })
        
        
    }
    
    func getLessionList(_ idText: Int) -> [String] {
        var lessionList:[String] = []
        let data: LessonPackeageModel? = (self.packagListArray[idText] as? LessonPackeageModel)
        let itemArr: [Any]? = data?.lessons_details
        priceList.removeAll()
        for items in itemArr!
        {
            let locDic = items as! NSDictionary
            let lession_name = locDic["lesson_name"] as? String ?? ""
            let price = locDic["amount"] as? Int ?? 0
            
            lessionList.append(lession_name)
            priceList.append(String(price))
        }
        return lessionList
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddNewLearner_VC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        switch textField {
        case suburbText:
            dropDown(textField, selector: Utility.getSuburbList(state: stateText.text!).0)
            return false
            
        case referedText:
            dropDown(textField, selector: ["System","Me"])
            return false
            
       /* case lessionTypeText:
            dropDown(textField, selector: ["1 lession Auto","5 lession Auto","10 lession Auto"])
            return false*/
            
        case priceText:
            return false
            
        case stateText:
            dropDown(textField, selector: Utility.getStateList().0)
            return false
     
        case currentLicenseText:
            dropDown(textField, selector: ["Oversease","Interstate","Victorian"])
            return false
            
        case packageText:
            self.dropDown(textField, selector: self.packageListArray as! [String])
            return false
            
        case lessionTypeText:
            if self.packageID == nil || self.packageID == 0 {
                return false
            }
            self.dropDown(textField, selector: self.getLessionList(self.packageID))
            return false
            
        default:
            return true
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    /*
        if textField == firstNameText {
            if textField.text! == "" {
                let banner = NotificationBanner(title: "Alert", subtitle: "First Name is blank!", style: .danger)
                banner.show(queuePosition: .front)
            }
        }
        
        
        
        switch textField {
        case firstNameText:
            if textField.text! == "" {
                let banner = NotificationBanner(title: "Alert", subtitle: "First Name field is blank!", style: .danger)
                banner.show(queuePosition: .front)
            }
            
            break
            
        case lastNameText:
            if textField.text! == "" {
                let banner = NotificationBanner(title: "Alert", subtitle: "Last Name field is blank!", style: .danger)
               banner.show(queuePosition: .front)
            }
            break
            
        case emailIdText:
            if textField.text! == "" {
                let banner = NotificationBanner(title: "Alert", subtitle: "Email field is blank!", style: .danger)
                banner.show(queuePosition: .front)
            }
            break
            
        case mobileText:
            if textField.text! == "" {
                let banner = NotificationBanner(title: "Alert", subtitle: "Mobile field is blank!", style: .danger)
                banner.show(queuePosition: .front)
            }
            break
            
        case addressText:
            if textField.text! == "" {
                let banner = NotificationBanner(title: "Alert", subtitle: "Address field is blank!", style: .danger)
                banner.show(queuePosition: .front)
            }
            break
            
        case postcodeText:
            if textField.text! == "" {
                let banner = NotificationBanner(title: "Alert", subtitle: "Post Code field is blank!", style: .danger)
                banner.show(queuePosition: .front)
            }
            break
            
        default:
           break
        }*/
        
    }
    
    
    
    
    
}


extension AddNewLearner_VC : UIPopoverPresentationControllerDelegate,PopUpViewControllerDelegate {
    
    func dropDown(_ textField:UITextField , selector:[String]) {
        let storyBoard = UIStoryboard(name: "Trainer", bundle: nil)
        let popController = storyBoard.instantiateViewController(withIdentifier: "PopUpViewController") as!  PopUpViewController
        popController.delegate = self
        popController.arr = selector
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = textField
        popController.popoverPresentationController?.sourceRect = textField.bounds
        popController.preferredContentSize = CGSize(width: 200, height: 200)
        self.present(popController, animated: true, completion: nil)
        tmpTextField = textField
    }
    
    func saveString(_ strText: String) {
        tmpTextField.text = strText
    }
    func idString(_ idText: String) {
        if(tmpTextField == packageText)
        {
            self.packageID = Int(idText)
            
            let data: LessonPackeageModel? = (self.packagListArray[self.packageID] as? LessonPackeageModel)
            let itemArr: [Any]? = data?.lessons_details
            let locDic1 = itemArr![0] as! NSDictionary
            lessionTypeText.text = locDic1["lesson_name"] as? String ?? ""
            self.lessionID = locDic1["lesson_id"] as? Int ?? 0
            let amount: Int = locDic1["amount"] as? Int ?? 0
            self.priceText.text = String(amount)
            
        }
        if(tmpTextField == lessionTypeText)
        {
            self.lessionID = Int(idText)
            self.priceText.text = priceList[Int(idText)!]
            
        }
        
    }
    func getTagOfTable(_ tblTag : Int, _ indexValue : String) {
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle{
        return UIModalPresentationStyle.none
    }
    
}
