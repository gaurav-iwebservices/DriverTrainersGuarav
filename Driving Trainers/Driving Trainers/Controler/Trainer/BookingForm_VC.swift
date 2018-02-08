//
//  BookingForm_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 09/01/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import NotificationBannerSwift

class BookingForm_VC: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var timeText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var packageText: UITextField!
    @IBOutlet weak var selectLessionText: UITextField!
    @IBOutlet weak var shadowView: UIView!
    
    var packagListArray:[Any] = []
    var packageListArray:[Any] = []
    var priceList:[String] = []
    var packageID:Int!
    var lessionID:Int!
    var learnerId:String!
    var postalCode:String!
    var tmpTextField:UITextField!

    var package:String!
    var lession:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getlessionPackeageAPI()
        submitButton.layer.cornerRadius = submitButton.frame.size.height/2
        shadowView.layer.cornerRadius = 5
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowRadius = 10
        
        Utility.underLine(txt: priceText)
        Utility.underLine(txt: timeText)
        Utility.underLine(txt: dateText)
        Utility.underLine(txt: packageText)
        Utility.underLine(txt: selectLessionText)
        Utility.buttonGradient(button: submitButton)
        Utility.viewGradient(view: gradientView)
        
       
        self.setImageInTextField(textField: timeText)
        self.setImageInTextField(textField: dateText)
        self.setImageInTextField(textField: packageText)
        self.setImageInTextField(textField: selectLessionText)
        
        priceText.delegate = self
       // timeText.delegate = self
        //dateText.delegate = self
        packageText.delegate = self
        selectLessionText.delegate = self
        
        packageText.text = package
        
        timeText.addTarget(self, action: #selector(self.datePicker(_:)), for: UIControlEvents.editingDidBegin)
        dateText.addTarget(self, action: #selector(self.datePicker(_:)), for: UIControlEvents.editingDidBegin)
        
        
        Utility.navigationBarView(view: navigationView)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func  setImageInTextField(textField:UITextField) {
        textField.rightViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        if textField == dateText || textField == timeText {
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
        
         if sender == dateText {
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
    
    func getlessionPackeageAPI() {
        
        let loginDictionary = [String: Any]()
     //   NVActivityIndicatorView.DEFAULT_TYPE = .orbit
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataParser.packagesLessonsAPIDetils(loginDictionary,Defines.stateAPI, withCompletionHandler: { (array,array2, isSuccessfull) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if(isSuccessfull)
            {
                self.packagListArray = array as! [Any]
                self.packageListArray = array2 as! [Any]
                let index = (self.packageListArray as! [String]).index(of:self.package)!
                self.getInfo(index)
                
                
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
    
    
    func getInfo(_ idText: Int) {
        
        
        let data: LessonPackeageModel = (self.packagListArray[idText] as? LessonPackeageModel)!
        
        self.packageID = data.package_id
        let itemArr: [Any] = data.lessons_details
        for i in 0..<itemArr.count {
            let locDic = itemArr[i] as! NSDictionary
            if locDic["lesson_name"] as! String == lession {
                self.lessionID = locDic["lesson_id"] as! Int
                self.priceText.text = String(describing: locDic["amount"] as! Int)
                self.selectLessionText.text = self.lession
            }
        }
        
            /*let locDic1 = itemArr![0] as! NSDictionary
            selectLessionText.text = locDic1["lesson_name"] as? String ?? ""
            self.lessionID = locDic1["lesson_id"] as? Int ?? 0
            let amount: Int = locDic1["amount"] as? Int ?? 0
            self.priceText.text = String(amount)*/
        
    }
    
    
    @IBAction func submitAction(_ sender: UIButton) {
        self.bookAppointment()
    }
    
    func bookAppointment() {
        let data:[String:Any] = [
            "package_id":packageID,
            "lesson_id":lessionID,
            "learner_id": learnerId,
            "date":dateText.text!,
            "time":timeText.text!,
            "postal_code":postalCode
        ]
        
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.bookingAPI, dataDict: data, { (json) in
            if json["status"].stringValue == "True" {
                let banner = NotificationBanner(title: "Confirmation", subtitle: json["message"].stringValue , style: .success)
                banner.show(queuePosition: .front)
            }else if json["status"].stringValue == "False" {
                let banner = NotificationBanner(title: "Alert", subtitle: json["message"].stringValue , style: .danger)
                banner.show(queuePosition: .front)
            }
            
        }) { (error) in
            print(error)
        }
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

extension BookingForm_VC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == packageText {
            self.dropDown(textField, selector: self.packageListArray as! [String])
            return false
        }else if  textField == selectLessionText {
            self.dropDown(textField, selector: self.getLessionList(self.packageID))
            return false
        }else if  textField == priceText {
            return false
        }else {
            return true
        }
    }
    
}

extension BookingForm_VC : UIPopoverPresentationControllerDelegate,PopUpViewControllerDelegate {
    
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
            selectLessionText.text = locDic1["lesson_name"] as? String ?? ""
            self.lessionID = locDic1["lesson_id"] as? Int ?? 0
            let amount: Int = locDic1["amount"] as? Int ?? 0
            self.priceText.text = String(amount)
            
        }
        if(tmpTextField == selectLessionText)
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
