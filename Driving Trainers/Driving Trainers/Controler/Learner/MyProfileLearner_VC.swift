//
//  MyProfileLearner_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 1/29/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

import Cosmos
import NotificationBannerSwift

class MyProfileLearner_VC: UIViewController {
    
    var profileData:NSDictionary?
    var imageUrL: String = ""
    var imagePicker = UIImagePickerController()
    var base64String: String = ""
    
    var gender: String = ""

    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var lbl_user_name: UILabel!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_fname: UITextField!
    @IBOutlet weak var txt_lname: UITextField!
    @IBOutlet weak var txt_dob: UITextField!
    
    @IBOutlet weak var img_profile_learner: UIImageView!
    @IBOutlet weak var view_Gradient: UIView!
    @IBOutlet weak var view_navigationBar: UIView!
    @IBOutlet weak var btn_side: UIButton!
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var btn_edit_now: UIButton!
    
    @IBOutlet weak var btn_male: UIButton!
    @IBOutlet weak var btn_male_text: UIButton!
    
    @IBOutlet weak var btn_female_text: UIButton!
    @IBOutlet weak var btn_female: UIButton!
    
    @IBOutlet weak var txt_language: UITextField!
    @IBOutlet weak var txt_mobile: UITextField!
    
    @IBOutlet weak var txt_referBy: UITextField!
    @IBOutlet weak var txt_licence_number: UITextField!
    @IBOutlet weak var img_licence: UIImageView!
    @IBOutlet weak var txt_licence: UITextField!
    @IBOutlet weak var txt_postCode: UITextField!
    @IBOutlet weak var txt_suburb: UITextField!
    @IBOutlet weak var txt_state: UITextField!
    @IBOutlet weak var txt_street: UITextField!
    @IBOutlet weak var txt_address: UITextField!
    @IBOutlet weak var txt_streetName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myProfileAPI()
        
         let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        img_profile.isUserInteractionEnabled = true
        img_profile.addGestureRecognizer(tapGestureRecognizer)
       
        self.navigationController?.navigationBar.isHidden = true

        Utility.navigationBarView(view: view_navigationBar)
        Utility.viewGradient(view: view_Gradient)
        Utility.buttonGradient(button: btn_edit_now)
        self.underlineTxtField()
        
         txt_dob.addTarget(self, action: #selector(self.datePicker(_:)), for: UIControlEvents.editingDidBegin)
        txt_dob.delegate = self
        txt_licence.delegate = self
        // Do any additional setup after loading the view.
    }
    func underlineTxtField() {
        Utility.underLine(txt: txt_email)
        Utility.underLine(txt: txt_fname)
        Utility.underLine(txt: txt_lname)
        Utility.underLine(txt: txt_dob)
        Utility.underLine(txt: txt_mobile)
        Utility.underLine(txt: txt_state)
        Utility.underLine(txt: txt_suburb)
        Utility.underLine(txt: txt_street)
        Utility.underLine(txt: txt_postCode)
        Utility.underLine(txt: txt_language)
        Utility.underLine(txt: txt_licence_number)
        Utility.underLine(txt: txt_licence)
        Utility.underLine(txt: txt_referBy)
        Utility.underLine(txt: txt_address)
        Utility.underLine(txt: txt_streetName)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func submit_Button_touch(_ sender: Any) {
        if validation() == false {
            return
        }
       
        let data:[String:Any] = [
            
            "lerner_id": UserData.Id,
            "first_name": txt_fname.text ?? "",
            "last_name": txt_lname.text ?? "",
            "dob": txt_dob.text ?? "",
            "gender": self.gender,
            "state_code" : self.profileData?["state_code"] as? String ?? "",
            "suburb_post_code": self.profileData?["suburb_post_code"] as? String ?? "",
            "address": txt_address.text ?? "",
            "street_no": txt_street.text ?? "",
            "street_name": txt_streetName.text ?? "",
            "mobile":txt_mobile.text ?? "",
            "language": txt_language.text ?? "",
            "current_license": txt_licence.text ?? "",
            "license_no": txt_licence_number.text ?? "",
            "profile_pic": base64String   // [optional]
        ]
        print(data)
        
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.updateProfileLearnerAPI, dataDict: data, { (json) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(json)
            if json["status"].stringValue == "True" {
                self.updatedataProfileAPI()
                let banner = NotificationBanner(title: "Confirmation", subtitle: json["message"].stringValue , style: .success)
                banner.show(queuePosition: .front)
            }
            
            
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(error)
        }
        
    }
    @IBAction func side_Button_touch(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }

    }
    
    @IBAction func edit_Button_Touch_(_ sender: Any) {
        txt_fname.isUserInteractionEnabled = true
        txt_lname.isUserInteractionEnabled = true
        txt_mobile.isUserInteractionEnabled = true
        txt_street.isUserInteractionEnabled = true
        txt_address.isUserInteractionEnabled = true
        txt_streetName.isUserInteractionEnabled = true
        txt_postCode.isUserInteractionEnabled = true
        txt_language.isUserInteractionEnabled = true
        txt_licence.isUserInteractionEnabled = true
        txt_licence_number.isUserInteractionEnabled = true
        btn_male.isUserInteractionEnabled = true
        btn_male_text.isUserInteractionEnabled = true
        btn_female.isUserInteractionEnabled = true
        btn_female_text.isUserInteractionEnabled = true
        btn_edit_now.isHidden = false
        btn_edit.isHidden = true
    }
    
    func myProfileAPI() {
        
    let dataDict:[String:String] = [
        "lerner_id": UserData.Id,
        ]
  //  NVActivityIndicatorView.DEFAULT_TYPE = .orbit
    let activityData = ActivityData()
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    
    DataParser.globalAPIDetils(dataDict,Defines.myViewPRofileLearnerAPI, withCompletionHandler: { (dict, isSuccessfull) in
    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    if(isSuccessfull){
            let status:String = dict?["status"] as! String
        
            if (status == "True")
            {
                self.imageUrL = (dict?["imgpath"] as? String)!
               DataManger._gDataManager.profileImageUrl = (dict?["imgpath"] as? String)!

                self.profileData = dict?["data"] as? NSDictionary
             
                DataManger._gDataManager.profileFname = (self.profileData!["fname"] as? String)!
                DataManger._gDataManager.profileLname = (self.profileData!["lname"] as? String)!
                DataManger._gDataManager.profileImageName = (self.profileData!["profile_pic"] as? String)!
            
                DataManger._gDataManager.postal_Code = (self.profileData?["postal_code"] as? String)!
                NotificationCenter.default.post(name: Notification.Name(rawValue: learnerProfileNotificationKey), object: self)
                
                
                self.setDataAPI()
            }
            else
            {
                let messageTxt:String = dict?["message"] as! String
                
                Utility.showAlertMessage(vc: self, titleStr: Defines.alterTitle, messageStr: messageTxt)
            
            }
        
        }
        else
        {
            Utility.showAlertMessage(vc: self, titleStr: Defines.alterTitle, messageStr: Defines.loginErrorMessage)
        }
        
        })
    }
     func setDataAPI() {
//        if UserData.imgPath != "" && UserData.imgPath != nil {
//            cell?.img_profile.downloadedFrom(url: URL(string: UserData.imgPath)!)
//        }
        if (self.profileData?["profile_pic"] as? String != "" && self.profileData?["profile_pic"] as? String != nil) {
            
            let imagepath: String = self.imageUrL + (self.profileData?["profile_pic"] as? String)!
            img_profile.downloadedFrom(url: URL(string: imagepath)!)
        }
        lbl_user_name.text = (self.profileData?["fname"] as? String)! + " " + (self.profileData?["lname"] as? String)!
        txt_email.text = self.profileData?["email"] as? String
        txt_fname.text = self.profileData?["fname"] as? String
        txt_lname.text = self.profileData?["lname"] as? String
        txt_dob.text = self.profileData?["dob"] as? String
        self.gender = (self.profileData?["gender"] as? String)!

        if self.profileData?["gender"] as? String == "male"
        {
            self.btn_male.setImage(UIImage(named: "radioSelected"), for: UIControlState.normal)
            self.btn_female.setImage(UIImage(named: "radio"), for: UIControlState.normal)
        }
        else
        {
            self.btn_female.setImage(UIImage(named: "radioSelected"), for: UIControlState.normal)
            self.btn_male.setImage(UIImage(named: "radio"), for: UIControlState.normal)
        }
        txt_mobile.text = self.profileData?["mobile"] as? String
        txt_state.text = self.profileData?["state"] as? String
        txt_suburb.text = self.profileData?["subrub"] as? String
        txt_address.text = self.profileData?["address"] as? String
        txt_streetName.text = self.profileData?["street_name"] as? String
        txt_street.text = self.profileData?["street_no"] as? String
        txt_postCode.text = self.profileData?["postal_code"] as? String
        txt_language.text = self.profileData?["language"] as? String
        txt_licence.text = self.profileData?["current_license"] as? String
        txt_licence_number.text = self.profileData?["license_no"] as? String
        txt_referBy.text = self.profileData?["ref_person_name"] as? String

        txt_fname.isUserInteractionEnabled = false
        txt_lname.isUserInteractionEnabled = false
        txt_mobile.isUserInteractionEnabled = false
        txt_address.isUserInteractionEnabled = false
        txt_streetName.isUserInteractionEnabled = false
        txt_street.isUserInteractionEnabled = false
        txt_postCode.isUserInteractionEnabled = false
        txt_language.isUserInteractionEnabled = false
        txt_licence.isUserInteractionEnabled = false
        txt_licence_number.isUserInteractionEnabled = false
        btn_male.isUserInteractionEnabled = false
        btn_male_text.isUserInteractionEnabled = false
        btn_female.isUserInteractionEnabled = false
        btn_female_text.isUserInteractionEnabled = false
        btn_edit_now.isHidden = true
        btn_edit.isHidden = false
        
    }
    func updatedataProfileAPI() {
        
        let dataDict:[String:String] = [
            "lerner_id": UserData.Id,
            ]
      //  NVActivityIndicatorView.DEFAULT_TYPE = .orbit
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataParser.globalAPIDetils(dataDict,Defines.myViewPRofileLearnerAPI, withCompletionHandler: { (dict, isSuccessfull) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if(isSuccessfull){
                let status:String = dict?["status"] as! String
                
                if (status == "True")
                {
                    self.imageUrL = (dict?["imgpath"] as? String)!
                    DataManger._gDataManager.profileImageUrl = (dict?["imgpath"] as? String)!
                    
                    self.profileData = dict?["data"] as? NSDictionary
                    
                    DataManger._gDataManager.profileFname = (self.profileData!["fname"] as? String)!
                    DataManger._gDataManager.profileLname = (self.profileData!["lname"] as? String)!
                    DataManger._gDataManager.profileImageName = (self.profileData!["profile_pic"] as? String)!
                    
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: learnerProfileNotificationKey), object: self)
                     self.setDataAPI()
                }
               
            }
          
            
        })
    }
    
    func validation() -> Bool {
        if txt_fname.text == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "First name field should not be blank.")
            return false
        }else if txt_lname.text == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Last name field should not be blank.")
            return false
        }else if txt_dob.text == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Date of birth field should not be blank.")
            return false
        }else if txt_mobile.text == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Mobile field should not be blank.")
            return false
        }else if txt_postCode.text == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Postal code field should not be blank.")
            return false
        }else if txt_address.text == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Address field should not be blank.")
            return false
        }else if txt_street.text == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Street No field should not be blank.")
            return false
        }else if txt_streetName.text == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Street name field should not be blank.")
            return false
        }else if txt_licence.text == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "License field should not be blank.")
            return false
        }else if txt_licence_number.text == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Driving license field should not be blank.")
            return false
        }
        else if txt_language.text == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Language field should not be blank.")
            return false
        }
        return true
    }
    @IBAction func datePicker(_ sender: UITextField) {
       
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        
        if sender == txt_dob {
            var minimumDate: Date {
                return (Calendar.current as NSCalendar).date(byAdding: .year, value: -15, to: Date(), options: [])!
            }
            
            var maximumDate: Date {
                return (Calendar.current as NSCalendar).date(byAdding: .year, value: -100, to: Date(), options: [])!
            }
            
            datePickerView.maximumDate = minimumDate
            datePickerView.minimumDate = maximumDate
            datePickerView.addTarget(self, action: #selector(handleDatePickerforDOB(sender:)), for: .valueChanged)
        }
    }
    @objc func handleDatePickerforDOB(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        txt_dob.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func female_button_touch(_ sender: Any) {
        btn_female_text.isSelected = !btn_female_text.isSelected
        if btn_female_text.isSelected {
            self.gender = "male"
            btn_female.setImage(UIImage(named:"radio"), for: UIControlState.normal)
            btn_male.setImage(UIImage(named:"radioSelected"), for: UIControlState.normal)

        }
        else {
            self.gender = "female"
            btn_female.setImage(UIImage(named:"radioSelected"), for: UIControlState.normal)
            btn_male.setImage(UIImage(named:"radio"), for: UIControlState.normal)
        }
    }
    @IBAction func male_button_touch(_ sender: Any) {
        btn_male_text.isSelected = !btn_male_text.isSelected
        if btn_male_text.isSelected {
            self.gender = "female"
            btn_female.setImage(UIImage(named:"radioSelected"), for: UIControlState.normal)
            btn_male.setImage(UIImage(named:"radio"), for: UIControlState.normal)
        }
        else {
            self.gender = "male"
            btn_female.setImage(UIImage(named:"radio"), for: UIControlState.normal)
            btn_male.setImage(UIImage(named:"radioSelected"), for: UIControlState.normal)
            
           
        }
    }
    
}
extension MyProfileLearner_VC:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txt_licence {
            self.dropDown(textField, selector: ["Oversease","Interstate","Victorian"])
            return false
        }
        else{
            return true
        }
    }
    
    
}
extension MyProfileLearner_VC : UIPopoverPresentationControllerDelegate,PopUpViewControllerDelegate {
    
    
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
        txt_licence = textField
    }
    
    func saveString(_ strText: String) {
        txt_licence.text = strText
    }
    func idString(_ idText: String) {
        
        
    }
    func getTagOfTable(_ tblTag : Int, _ indexValue : String) {
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle{
        return UIModalPresentationStyle.none
    }
    
}
extension MyProfileLearner_VC: UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    
   // @IBAction func profileImageHasBeenTapped(_ sender: Any) {
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let refreshAlert = UIAlertController(title: "Picture", message: title, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Library", style: .default, handler: { (action: UIAlertAction!) in
            self.openLibrary()
            
        }))
        refreshAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction!) in
            self.openCamera()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        present(refreshAlert, animated: true, completion: nil)
        
        
    }
    
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let image = self.resizeImage(chosenImage, targetSize: CGSize(width: 300.0, height: 300.0))
        img_profile.image = image
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        base64String = imageData!.base64EncodedString(options: [])
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // take phota using camera
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // take photo from library
    func openLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio = targetSize.width / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
           
            newSize = CGSize(width: size.width, height: size.height)
        } else {
            newSize = CGSize(width: widthRatio, height: widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}



