//
//  MakeAppointment_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 1/19/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class MakeAppointment_VC: UIViewController {
    
    var packagListArray:[Any] = []
    var packageListArray:[Any] = []
    
    var priceList:[String] = []


    var tmpTextField:UITextField!
    var packageIndexID:Int!
    
    var lessionIndexID:Int!

    var packageID:Int!

    var lessionID:Int!


    @IBOutlet weak var txt_state: UITextField!
    @IBOutlet weak var txt_sub: UITextField!
    
    @IBOutlet weak var txt_package: UITextField!
    @IBOutlet weak var txt_lesson: UITextField!
    @IBOutlet weak var txt_price: UITextField!
    @IBOutlet weak var txt_date: UITextField!
    @IBOutlet weak var txt_time: UITextField!
    @IBOutlet weak var txt_paymentmode: UITextField!
    
    @IBOutlet weak var view_shadow: UIView!
    
    @IBOutlet weak var btn_submit: UIButton!
    
    @IBOutlet weak var view_state: UIView!
    @IBOutlet weak var view_sub: UIView!
    
    @IBOutlet weak var view_package: UIView!
    @IBOutlet weak var view_time: UIView!
    
    @IBOutlet weak var view_payment: UIView!
    @IBOutlet weak var view_date: UIView!
    @IBOutlet weak var view_price: UIView!
    @IBOutlet weak var view_selectlession: UIView!
    @IBOutlet weak var view_top: UIView!
    @IBOutlet weak var view_navigation: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        Utility.navigationBarView(view: view_navigation)
        Utility.viewGradient(view: view_top)
        Utility.shadowInView(view: view_shadow)
        
        //Utility.textUnderline(txtF: txt_state)
        //Utility.textUnderline(txtF: txt_sub)
        
        Utility.textUnderline(txtF: txt_package)
        Utility.textUnderline(txtF: txt_lesson)
        Utility.textUnderline(txtF: txt_price)
        Utility.textUnderline(txtF: txt_date)
        Utility.textUnderline(txtF: txt_time)
        Utility.textUnderline(txtF: txt_paymentmode)
        Utility.buttonGradient(button: btn_submit)
        
        self.txt_lesson.delegate = self
        self.txt_package.delegate = self
        self.txt_date.delegate = self
        self.txt_time.delegate = self
        self.txt_paymentmode.delegate = self
        if(DataManger._gDataManager.isFromLessonPackage)
        {
            self.autofillData()
        }
        else
        {
            self.getlessionPackeageAPI()

        }

        
        txt_date.addTarget(self, action: #selector(self.datePicker(_:)), for: UIControlEvents.editingDidBegin)
        
        txt_time.addTarget(self, action: #selector(self.timePicker(_:)), for: UIControlEvents.editingDidBegin)

        // Do any additional setup after loading the view.
    }
     func autofillData() {
        
        
        let data: LessonPackeageModel? = (self.packagListArray[self.packageIndexID] as? LessonPackeageModel)
        self.txt_package.text = data?.package_name
        self.packageID = data?.package_id
        let itemArr: [Any]? = data?.lessons_details
        
        let locDic = itemArr![self.lessionIndexID] as! NSDictionary
        self.txt_lesson.text = locDic["lesson_name"] as? String ?? ""
        self.lessionID = locDic["lesson_id"] as? Int ?? 0
        self.txt_price.text = String(locDic["amount"] as? Int ?? 0)
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
                
                self.packageIndexID = 0
                
                let data: LessonPackeageModel? = (self.packagListArray[0] as? LessonPackeageModel)
                self.txt_package.text = data?.package_name
                self.packageID = data?.package_id
                let itemArr: [Any]? = data?.lessons_details
              
                let locDic = itemArr![0] as! NSDictionary
                self.txt_lesson.text = locDic["lesson_name"] as? String ?? ""
                self.lessionID = locDic["lesson_id"] as? Int ?? 0
                self.txt_price.text = String(locDic["amount"] as? Int ?? 0)
                
               
                print("success")
            }
            else
            {
                Utility.showAlertMessage(vc: self, titleStr: Defines.alterTitle, messageStr: Defines.loginErrorMessage)
            }
            
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func touch_sidemenu(_ sender: Any) {
        navigationController?.popViewController(animated: true)

        // self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
    }
    @IBAction func datePicker(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        
        var minimumDate: Date {
            return (Calendar.current as NSCalendar).date(byAdding: .year, value: 0, to: Date(), options: [])!
        }
        
        var maximumDate: Date {
            return (Calendar.current as NSCalendar).date(byAdding: .year, value: 15, to: Date(), options: [])!
        }
        
        datePickerView.maximumDate = minimumDate
        datePickerView.minimumDate = maximumDate
        datePickerView.addTarget(self, action: #selector(handleDatePickerforDOB(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePickerforDOB(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        txt_date.text = dateFormatter.string(from: sender.date)
    }
    
    
    @IBAction func timePicker(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .time
        sender.inputView = datePickerView
        
        
        datePickerView.addTarget(self, action: #selector(handletimePickerforDOB(sender:)), for: .valueChanged)
    }
    
    @objc func handletimePickerforDOB(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        let theTimeFormat = DateFormatter.Style.short
        dateFormatter.timeStyle = theTimeFormat//9

        txt_time.text = dateFormatter.string(from: sender.date)
        
       
    }
    
    @IBAction func touch_submit(_ sender: Any) {
        if (userInputValue())
        {
            
            let dataDict:[String:String] = [
                "package_id":String(self.packageID),
                "lesson_id":String(self.lessionID),
                "learner_id": UserData.Id,
                "date": txt_date.text!,
                "time": txt_time.text!,
                "postal_code": DataManger._gDataManager.postal_Code,
            ]
            print(dataDict)
            
//            let dataDict:[String:String] = [
//                "package_id": "1",
//                "lesson_id": "4",
//                "learner_id": "3",
//                "date": txt_date.text!,
//                "time": txt_time.text!,
//                "postal_code": "3067",
//                ]
            
            
            if Reachability.isConnectedToNetwork() == false {
                return
            }
            
            let activityData = ActivityData()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
            
            
            DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.bookingAPI, dataDict: dataDict, { (json) in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                print(json)
                
                if json["status"].stringValue == "True" {
                    
                    let mesaage: String = json["message"].string!
                   Utility.showAlertMessage(vc: self, titleStr: "", messageStr: mesaage)
                    
                }
                
            }) { (error) in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                print(error)
            }
        }
    }
    
    func userInputValue() -> Bool
    {
        if (txt_lesson.text == "")
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Please select the lesson")
            return false
        }
        else if (txt_package.text == "")
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Please select the package")
            return false
        }
        else if (txt_date.text == "")
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Please select date")
            return false
        }
        else if (txt_time.text == "")
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Please select time")
            return false
        }
        else if (txt_paymentmode.text == "")
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Please select payment mode")
            return false
        }
       
        return true
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
}

extension MakeAppointment_VC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txt_lesson {
            self.dropDown(textField, selector: self.getLessionList(self.packageIndexID))
            return false
          
        }else if textField == txt_package {
            self.dropDown(textField, selector: self.packageListArray as! [String])
            return false
            
        }
        else if textField == txt_paymentmode {
            self.dropDown(textField, selector: ["Online","Offline"])
            return false
        }
        else{
            return true
        }
    }
}

extension MakeAppointment_VC : UIPopoverPresentationControllerDelegate,PopUpViewControllerDelegate {
    
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
        if(tmpTextField == txt_package)
        {
            self.packageIndexID = Int(idText)

            let data: LessonPackeageModel? = (self.packagListArray[self.packageIndexID] as? LessonPackeageModel)
            self.packageID = data?.package_id
            let itemArr: [Any]? = data?.lessons_details
            let locDic1 = itemArr![0] as! NSDictionary
            txt_lesson.text = locDic1["lesson_name"] as? String ?? ""
            self.lessionID = locDic1["lesson_id"] as? Int ?? 0
            let amount: Int = locDic1["amount"] as? Int ?? 0
            self.txt_price.text = String(amount)
            
        }
        if(tmpTextField == txt_lesson)
        {
            let localIndex:Int = Int(idText)!
            let data: LessonPackeageModel? = (self.packagListArray[self.packageIndexID] as? LessonPackeageModel)
            let itemArr: [Any]? = data?.lessons_details
            let locDic1 = itemArr![localIndex] as! NSDictionary
            self.lessionID = locDic1["lesson_id"] as? Int ?? 0
            self.txt_price.text = priceList[Int(idText)!]
          
        }
        
    }
    func getTagOfTable(_ tblTag : Int, _ indexValue : String) {
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle{
        return UIModalPresentationStyle.none
    }
    
}

