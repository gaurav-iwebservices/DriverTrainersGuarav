//
//  MyProfile_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 08/01/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import NotificationBannerSwift

class MyProfile_VC: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var headerTitleArr = ["","ABOUT ME","PROFESSIONAL INFORMATION","FEE INFORMATION","AVAILABILITY INFORMATION", "BANK INFORMATION"]
    var showRowArr = [1,0,0,0,0,0]
    var tmpTextField:UITextField!
    var base64String:String = ""
    
    @IBOutlet var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    var userImage:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.navigationController?.navigationBar.isHidden = true
    
        tableView.estimatedRowHeight = 2000
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(UINib(nibName: "BankInfo_TVC", bundle: nil), forCellReuseIdentifier: "BankInfo_TVC")
        tableView.register(UINib(nibName: "ProfessionalInformation_TVC", bundle: nil), forCellReuseIdentifier: "ProfessionalInformation_TVC")
        tableView.register(UINib(nibName: "AvailabilityInfo_TVC", bundle: nil), forCellReuseIdentifier: "AvailabilityInfo_TVC")
        tableView.register(UINib(nibName: "MyProfile_TVC", bundle: nil), forCellReuseIdentifier: "MyProfile_TVC")
        
        Utility.navigationBarView(view: navigationView)
 
      /* userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.layer.borderWidth = 2
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.masksToBounds = true*/
        
        self.getTrainnerProfile()
    }
    @IBAction func menuAction(_ sender: UIButton) {
         self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
    }
    
    @IBAction func editBtnAction(_ sender: UIButton) {
        if General.myProfileEdit == false {
            General.myProfileEdit = true
            sender.setTitle("SAVE", for: UIControlState.normal)
            sender.setImage(UIImage(named:""), for: UIControlState.normal)
        }else{
            General.myProfileEdit = false
            sender.setTitle("", for: UIControlState.normal)
            sender.setImage(UIImage(named:"edit"), for: UIControlState.normal)
            self.doneBtnAction()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        General.myProfileEdit = false
    }
    
    func getTrainnerProfile() {
        
        let data:[String:Any] = [
        "trainer_id": UserData.Id,
        ]
        
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
 
        
        
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.trainnerProfileAPI, dataDict: data, { (json) in
            print(json)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if json["status"].stringValue == "True" {
                TrainerProfile.imagePath =  json["imgpath"].stringValue +  json["data"]["profile_pic"].stringValue
                UserDefaults.standard.setValue(TrainerProfile.imagePath, forKey: "ImgPath")
                UserData.imgPath = TrainerProfile.imagePath
                TrainerProfile.firstName  = json["data"]["fname"].stringValue
                TrainerProfile.lastName  = json["data"]["lname"].stringValue
                TrainerProfile.dob  = json["data"]["dob"].stringValue
                TrainerProfile.gender  = json["data"]["gender"].stringValue
                TrainerProfile.state  = json["data"]["state"].stringValue
                TrainerProfile.stateCode  = json["data"]["state_code"].stringValue
                TrainerProfile.address  = json["data"]["address"].stringValue
                TrainerProfile.abn  = json["data"]["abn"].stringValue
                TrainerProfile.subrub  = json["data"]["subrub"].stringValue
                TrainerProfile.streetNo  = json["data"]["street_no"].stringValue
                TrainerProfile.streetName  = json["data"]["street_name"].stringValue
                TrainerProfile.postalCode  = json["data"]["postal_code"].stringValue
                TrainerProfile.mobile  = json["data"]["mobile"].stringValue
                TrainerProfile.drivingLicense  = json["data"]["driving_license"].stringValue
                TrainerProfile.licenseState  = json["data"]["license_state"].stringValue
                TrainerProfile.expirationDate  = json["data"]["expiration_date"].stringValue
                TrainerProfile.vichleType  = json["data"]["vehicle_type"].stringValue
                TrainerProfile.vichleModel  = json["data"]["vehicle_model"].stringValue
                TrainerProfile.experienceYear  = json["data"]["experience_year"].stringValue
                TrainerProfile.drivingSchoolName  = json["data"]["driving_school_name"].stringValue
                // bank Info
                TrainerProfile.AccNumber = json["data"]["account_no"].stringValue
                TrainerProfile.AccSSB = json["data"]["bank_account_ssb"].stringValue
                TrainerProfile.bankAccName = json["data"]["bank_account_name"].stringValue
                //professional Info
                
                TrainerProfile.paymentModeAccepting = json["data"]["pyement_mode_accepting"].stringValue
                TrainerProfile.DiaNumber = json["data"]["dia_no"].stringValue
                TrainerProfile.DiaExpertationRate = json["data"]["dia_expiration_date"].stringValue
                TrainerProfile.vichleTramissionType = json["data"]["vehicle_transmission_type"].stringValue
                // Description
                TrainerProfile.descriptionStr = json["data"]["description"].stringValue
                
                //Fee Info
                TrainerProfile.feeInfo = json["data"]["min_fee"].stringValue
                
                //Avaliablity Info
                TrainerProfile.fromHour = json["data"]["hours_from"].stringValue
                TrainerProfile.toHour = json["data"]["hours_to"].stringValue
                TrainerProfile.fromTime = json["data"]["from_ampm"].stringValue
                TrainerProfile.toTime = json["data"]["to_ampm"].stringValue
                TrainerProfile.mon = json["data"]["mon"].intValue
                TrainerProfile.sun = json["data"]["sun"].intValue
                TrainerProfile.tue = json["data"]["tue"].intValue
                TrainerProfile.wed = json["data"]["wed"].intValue
                TrainerProfile.thu = json["data"]["thu"].intValue
                TrainerProfile.fri = json["data"]["fri"].intValue
                TrainerProfile.sat = json["data"]["sat"].intValue
                TrainerProfile.all = json["data"]["all_day"].intValue
                
                TrainerProfile.avaliablity = json["data"]["availability"].stringValue
                
                self.tableView.reloadData()
            }
            
            
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(error)
        }
        
    }
    
    @objc func headerBtnAction(sender:UIButton) {
        if showRowArr[sender.tag] == 0 {
            showRowArr[sender.tag] = 1
        }else{
            showRowArr[sender.tag] = 0
        }
        tableView.reloadData()
    }
    
    func doneBtnAction() {
       /* let indexPath1 = IndexPath(row: 0, section: 0)
        let cell1 = tableView.cellForRow(at: indexPath1) as! MyProfile_TVC!
        
        let indexPath2 = IndexPath(row: 0, section: 2)
        let cell2 = tableView.cellForRow(at: indexPath2) as! ProfessionalInformation_TVC!
        
        let indexPath3 = IndexPath(row: 0, section: 3)
        let cell3 = tableView.cellForRow(at: indexPath3) as! FeeInfo_TVC!
        
        let indexPath4 = IndexPath(row: 0, section: 4)
        let cell4 = tableView.cellForRow(at: indexPath4) as! AvailabilityInfo_TVC!
        
        let indexPath5 = IndexPath(row: 0, section: 5)
        let cell5 = tableView.cellForRow(at: indexPath5) as! BankInfo_TVC!*/
        
        /*if validation() == false {
            return
        }*/
        
        
        let data:[String:Any] = [
        
            "trainer_id": UserData.Id,
            "first_name": TrainerProfile.firstName,
            "last_name": TrainerProfile.lastName,
            "dob": TrainerProfile.dob,
            "gender":TrainerProfile.gender,
            "mobile" : TrainerProfile.mobile,
            "state_code": TrainerProfile.stateCode,
            "suburb_post_code": TrainerProfile.postalCode,
            "address": TrainerProfile.address,
            "street_no": TrainerProfile.streetNo,
            "street_name": TrainerProfile.streetName,
            "aboutus":TrainerProfile.descriptionStr,
            "driving_license": TrainerProfile.drivingLicense,
            "license_state": TrainerProfile.licenseState,
            "expiration_date": TrainerProfile.expirationDate,
            "vehicle_type":TrainerProfile.vichleType,
            "vehicle_model":TrainerProfile.vichleModel,
            "experience_year":TrainerProfile.experienceYear,
            "min_fee":TrainerProfile.feeInfo,
            "driving_school_name":TrainerProfile.drivingSchoolName,
            "dia_no":TrainerProfile.DiaNumber,
            "abn": TrainerProfile.abn,
            "dia_expiration_date":TrainerProfile.DiaExpertationRate,
            "vehicle_transmission_type":TrainerProfile.vichleTramissionType,
            "pyement_mode_accepting":TrainerProfile.paymentModeAccepting,
            "availability":TrainerProfile.avaliablity, //[2=deactive,1=active]
            "hours_from":TrainerProfile.fromHour,
            "from_ampm":TrainerProfile.fromTime, // [AM,PM]
            "hours_to":TrainerProfile.toHour,
            "to_ampm":TrainerProfile.toTime, //  [AM,PM]
            "sun":TrainerProfile.sun,   // [2=deactive,1=active]
            "mon":TrainerProfile.mon,   //  [2=deactive,1=active]
            "tue":TrainerProfile.tue,   // [2=deactive,1=active]
            "wed":TrainerProfile.wed,
            "thu":TrainerProfile.thu,
            "fri":TrainerProfile.fri,
            "sat":TrainerProfile.sat,
            "all_day":TrainerProfile.all,
            "bank_account_name":TrainerProfile.bankAccName,
            "bank_account_ssb":TrainerProfile.AccSSB,
            "account_no":TrainerProfile.AccNumber,
            "profile_pic": base64String  // [optional]
        ]
        print(data)
        
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.updateAPI, dataDict: data, { (json) in
             NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(json)
            
            if json["status"].stringValue == "True" {
               // NotificationCenter.default.post(name: MyClass.myNotification,object: nil, userInfo: userInfo)
               
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TrainerProfile"), object: nil)
                TrainerProfile.imagePath = json["imgpath"].stringValue
                UserData.imgPath = json["imgpath"].stringValue
                UserData.firstName = TrainerProfile.firstName
                UserData.lastName = TrainerProfile.lastName
                UserDefaults.standard.setValue(UserData.firstName, forKey: "firstName")
                UserDefaults.standard.setValue(UserData.lastName, forKey: "lastName")
                UserDefaults.standard.setValue(UserData.imgPath , forKey: "ImgPath")
                self.tableView.reloadData()
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
    
    func validation() -> Bool {
        if TrainerProfile.firstName == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "First name field should not be blank.")
            return false
        }else if TrainerProfile.lastName == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Last name field should not be blank.")
            return false
        }else if TrainerProfile.dob == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Date of birth field should not be blank.")
            return false
        }else if TrainerProfile.gender == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Please select gender.")
            return false
        }else if TrainerProfile.mobile == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Mobile field should not be blank.")
            return false
        }else if TrainerProfile.postalCode == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Postal code field should not be blank.")
            return false
        }else if TrainerProfile.address == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Address field should not be blank.")
            return false
        }else if TrainerProfile.streetNo == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Street No field should not be blank.")
            return false
        }else if TrainerProfile.streetName == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Street name field should not be blank.")
            return false
        }else if TrainerProfile.descriptionStr == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "About field should not be blank.")
            return false
        }else if TrainerProfile.licenseState == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "License field should not be blank.")
            return false
        }else if TrainerProfile.drivingLicense == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Driving license field should not be blank.")
            return false
        }else if TrainerProfile.expirationDate == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Expiration date field should not be blank.")
            return false
        }else if TrainerProfile.vichleType == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Vichle type field should not be blank.")
            return false
        }else if TrainerProfile.vichleModel == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Vichle model field should not be blank.")
            return false
        }else if TrainerProfile.experienceYear == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Experience year field should not be blank.")
            return false
        }else if TrainerProfile.feeInfo == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Fee Info field should not be blank.")
            return false
        }else if TrainerProfile.drivingSchoolName == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Driving school name field should not be blank.")
            return false
        }else if TrainerProfile.DiaNumber == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Dia number field should not be blank.")
            return false
        }else if TrainerProfile.abn == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "ABN field should not be blank.")
            return false
        }else if TrainerProfile.DiaExpertationRate == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Dia expertation rate field should not be blank.")
            return false
        }else if TrainerProfile.vichleTramissionType == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Vichle tramission type field should not be blank.")
            return false
        }else if TrainerProfile.paymentModeAccepting == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Payment mode accepting field should not be blank.")
            return false
        }else if TrainerProfile.fromHour == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "From field should not be blank.")
            return false
        }else if TrainerProfile.toHour == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "To field should not be blank.")
            return false
        }else if TrainerProfile.AccNumber == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Account number field should not be blank.")
            return false
        }else if TrainerProfile.AccSSB == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Bank account SSB field should not be blank.")
            return false
        }else if TrainerProfile.bankAccName == "" {
            Utility.showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Bank account name field should not be blank.")
            return false
        }
        return true
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

extension MyProfile_VC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTitleArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.section == 0 {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "MyProfile_TVC", for: indexPath) as! MyProfile_TVC
            
            customCell.firstNameText.text = TrainerProfile.firstName
            customCell.lastNameText.text = TrainerProfile.lastName
            customCell.dobText.text = TrainerProfile.dob
            customCell.stateText.text = TrainerProfile.state
            customCell.subrubText.text = TrainerProfile.subrub
            customCell.streetNoText.text = TrainerProfile.streetNo
            customCell.streetNameText.text = TrainerProfile.streetName
            customCell.postalText.text = TrainerProfile.postalCode
            customCell.mobileText.text = TrainerProfile.mobile
            customCell.drivingLicenseText.text = TrainerProfile.drivingLicense
            customCell.licenseStateText.text = TrainerProfile.licenseState
            customCell.expirationDateText.text = TrainerProfile.expirationDate
            customCell.vichleTypeText.text = TrainerProfile.vichleType
            customCell.vichleModelText.text = TrainerProfile.vichleModel
            customCell.experienceYearText.text = TrainerProfile.experienceYear
            customCell.drivingSchoolNameText.text = TrainerProfile.drivingSchoolName
            customCell.userNameLabel.text = TrainerProfile.firstName + " " + TrainerProfile.lastName
            customCell.stateText.delegate = self
            customCell.stateText.tag = 1
            customCell.subrubText.delegate = self
            customCell.subrubText.tag = 2
            customCell.licenseStateText.delegate = self
            customCell.licenseStateText.tag = 3
            customCell.photoUploadBtn.addTarget(self, action: #selector(self.changePicture(_:)), for: UIControlEvents.touchUpInside)
            userImage = customCell.userImage
            if TrainerProfile.imagePath != "" && TrainerProfile.imagePath != nil {
                customCell.userImage.downloadedFrom(url: URL(string: TrainerProfile.imagePath)!)
            }
            if TrainerProfile.gender == "male" {
                customCell.maleBtn.setImage(UIImage(named:"radioSelected"), for: UIControlState.normal)
                customCell.femaleBtn.setImage(UIImage(named:"radio"), for: UIControlState.normal)
            }else{
                customCell.femaleBtn.setImage(UIImage(named:"radioSelected"), for: UIControlState.normal)
                customCell.maleBtn.setImage(UIImage(named:"radio"), for: UIControlState.normal)
            }
            
            if TrainerProfile.avaliablity == "1" {
                customCell.avaliabilitySwitch.setOn(true, animated: false)
            }else{
                customCell.avaliabilitySwitch.setOn(false, animated: false)
            }
            
            cell = customCell
        }else if indexPath.section == 1 {
            cell.textLabel?.text = TrainerProfile.descriptionStr
            if showRowArr[1] == 0 {
                cell.contentView.isHidden = true
            }else{
                cell.contentView.isHidden = false
            }
        }else if indexPath.section == 2 {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "ProfessionalInformation_TVC", for: indexPath) as! ProfessionalInformation_TVC
            customCell.diaDateText.text = TrainerProfile.DiaExpertationRate
            customCell.diaNoText.text = TrainerProfile.DiaNumber
            customCell.paymentModeText.text = TrainerProfile.paymentModeAccepting
            customCell.vichleTypeText.text = TrainerProfile.vichleTramissionType
            if showRowArr[2] == 0 {
                customCell.contentView.isHidden = true
            }else{
                customCell.contentView.isHidden = false
            }
            cell = customCell
        }else if indexPath.section == 3 {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "FeeInfo_TVC", for: indexPath) as! FeeInfo_TVC
            customCell.feeText.text = TrainerProfile.feeInfo
            if showRowArr[3] == 0 {
                customCell.contentView.isHidden = true
            }else{
                customCell.contentView.isHidden = false
            }
            cell = customCell
        }else if indexPath.section == 4 {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "AvailabilityInfo_TVC", for: indexPath) as! AvailabilityInfo_TVC
            customCell.fromText.text = TrainerProfile.fromHour + " " + TrainerProfile.fromTime 
            customCell.toText.text = TrainerProfile.toHour + " " + TrainerProfile.toTime
            customCell.setAvailDays(arr: [
                TrainerProfile.sun,
                TrainerProfile.mon,
                TrainerProfile.tue,
                TrainerProfile.wed,
                TrainerProfile.thu,
                TrainerProfile.fri,
                TrainerProfile.sat,
                TrainerProfile.all])
            
            if showRowArr[4] == 0 {
                customCell.contentView.isHidden = true
            }else{
                customCell.contentView.isHidden = false
            }
            
            cell = customCell
        }else if indexPath.section == 5 {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "BankInfo_TVC", for: indexPath) as! BankInfo_TVC
            customCell.bankNameText.text = TrainerProfile.bankAccName
            customCell.bankSSBText.text = TrainerProfile.AccSSB
            customCell.accountNumberText.text = TrainerProfile.AccNumber
            cell = customCell
            
            if showRowArr[5] == 0 {
                customCell.contentView.isHidden = true
            }else{
                customCell.contentView.isHidden = false
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "MyProfileHeader_TVC") as! MyProfileHeader_TVC
        header.headerTitleLabel.text = headerTitleArr[section]
        header.headerButton.tag = section
        header.headerButton.addTarget(self, action: #selector(self.headerBtnAction(sender:)), for: UIControlEvents.touchUpInside)
        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 60.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if showRowArr[indexPath.section] == 0 {
            return 0
        }else{
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.doneBtnAction()
    }
   
}


extension MyProfile_VC : UIPopoverPresentationControllerDelegate,PopUpViewControllerDelegate {
    
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
        if tmpTextField.tag == 1 {
            TrainerProfile.state = strText
        }else if tmpTextField.tag == 2 {
            TrainerProfile.subrub = strText
        }
    }
    func idString(_ strText: String) {
        print(strText)
    }
    func getTagOfTable(_ tblTag : Int, _ indexValue : String) {
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle{
        return UIModalPresentationStyle.none
    }
    
}

extension MyProfile_VC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
      /*  if textField.tag == 1 {
            self.dropDown(textField, selector: Utility.getStateList())
        }else if textField.tag == 2 {
            self.dropDown(textField, selector: Utility.getSuburbList(state: TrainerProfile.state))
        }*/
        
        return false
    }
}

extension MyProfile_VC: UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    
    @IBAction func changePicture(_ sender: Any) {
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
        userImage.image = image
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
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
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
