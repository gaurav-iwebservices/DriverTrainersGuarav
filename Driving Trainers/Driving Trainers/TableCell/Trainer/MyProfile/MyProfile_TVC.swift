//
//  MyProfile_TVC.swift
//  Driving Trainers
//
//  Created by iws on 1/13/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import Cosmos

class MyProfile_TVC: UITableViewCell {

    
    @IBOutlet weak var avaliabilitySwitch: UISwitch!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var dobText: UITextField!
    @IBOutlet weak var stateText: UITextField!
    @IBOutlet weak var subrubText: UITextField!
    @IBOutlet weak var streetNoText: UITextField!
    
    @IBOutlet weak var streetNameText: UITextField!
    @IBOutlet weak var postalText: UITextField!
    @IBOutlet weak var mobileText: UITextField!
    @IBOutlet weak var drivingLicenseText: UITextField!
    @IBOutlet weak var licenseStateText: UITextField!
    @IBOutlet weak var expirationDateText: UITextField!
    @IBOutlet weak var vichleTypeText: UITextField!
    @IBOutlet weak var vichleModelText: UITextField!
    @IBOutlet weak var experienceYearText: UITextField!
    @IBOutlet weak var drivingSchoolNameText: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var photoUploadBtn: UIButton!
    @IBOutlet weak var ratingView: CosmosView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
         Utility.underLine(txt: firstNameText)
         Utility.underLine(txt: lastNameText)
         Utility.underLine(txt: dobText)
         Utility.underLine(txt: stateText)
         Utility.underLine(txt: subrubText)
         Utility.underLine(txt: streetNoText)
         Utility.underLine(txt: streetNameText)
         Utility.underLine(txt: postalText)
         Utility.underLine(txt: mobileText)
         Utility.underLine(txt: drivingLicenseText)
         Utility.underLine(txt: licenseStateText)
         Utility.underLine(txt: expirationDateText)
         Utility.underLine(txt: vichleTypeText)
         Utility.underLine(txt: vichleModelText)
         Utility.underLine(txt: experienceYearText)
         Utility.underLine(txt: drivingSchoolNameText)
         Utility.viewGradient(view: gradientView)
        
        dobText.addTarget(self, action: #selector(self.datePicker(_:)), for: UIControlEvents.editingDidBegin)
        expirationDateText.addTarget(self, action: #selector(self.datePicker(_:)), for: UIControlEvents.editingDidBegin)
        maleBtn.addTarget(self, action: #selector(self.selectGenderAction(sender:)), for: UIControlEvents.touchUpInside)
        femaleBtn.addTarget(self, action: #selector(self.selectGenderAction(sender:)), for: UIControlEvents.touchUpInside)
        
        ratingView.isUserInteractionEnabled = false
        firstNameText.delegate = self
        lastNameText.delegate = self
        streetNoText.delegate = self
        streetNameText.delegate = self
        postalText.delegate = self
        mobileText.delegate = self
        drivingLicenseText.delegate = self
        licenseStateText.delegate = self
        vichleTypeText.delegate = self
        vichleModelText.delegate = self
        experienceYearText.delegate = self
        drivingSchoolNameText.delegate = self
        
        dobText.delegate = self
        expirationDateText.delegate = self
        
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.layer.borderWidth = 2
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func photoUploadAction(_ sender: UIButton) {
    }
    
    @IBAction func AvailablitiyAction(_ sender: UISwitch) {
        if sender.isOn {
            TrainerProfile.avaliablity = "1"
        }else{
            TrainerProfile.avaliablity = "2"
        }
    }
    
    
    @IBAction func datePicker(_ sender: UITextField) {
        if General.myProfileEdit == false {
            return
        }
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
        }else if sender == expirationDateText {
            var maximumDate: Date {
                return (Calendar.current as NSCalendar).date(byAdding: .year, value: 15, to: Date(), options: [])!
            }
            
            var minimumDate: Date {
                return (Calendar.current as NSCalendar).date(byAdding: .year, value: -20, to: Date(), options: [])!
            }
            
            datePickerView.maximumDate = maximumDate
            datePickerView.minimumDate = minimumDate
            datePickerView.addTarget(self, action: #selector(handleDatePickerforExpirationdate(sender:)), for: UIControlEvents.valueChanged)
        }
    }
    
    @objc func handleDatePickerforDOB(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dobText.text = dateFormatter.string(from: sender.date)
        TrainerProfile.dob = dobText.text!
    }
    
    @objc func handleDatePickerforExpirationdate(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        expirationDateText.text = dateFormatter.string(from: sender.date)
        TrainerProfile.expirationDate = expirationDateText.text!
    }
    
    @objc func selectGenderAction(sender:UIButton) {
        if General.myProfileEdit == false {
            return
        }
        if sender == maleBtn {
            TrainerProfile.gender = "male"
            sender.setImage(UIImage(named:"radioSelected"), for: UIControlState.normal)
            femaleBtn.setImage(UIImage(named:"radio"), for: UIControlState.normal)
        }else if sender == femaleBtn {
            TrainerProfile.gender = "female"
            sender.setImage(UIImage(named:"radioSelected"), for: UIControlState.normal)
            maleBtn.setImage(UIImage(named:"radio"), for: UIControlState.normal)
        }
    }
    
}

extension MyProfile_TVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if General.myProfileEdit == false {
            return false
        }else{
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if firstNameText == textField {
            TrainerProfile.firstName = textField.text!
        }else if lastNameText == textField {
            TrainerProfile.lastName = textField.text!
        }else if streetNoText == textField {
            TrainerProfile.streetNo = textField.text!
        }else if streetNameText == textField {
            TrainerProfile.streetName = textField.text!
        }else if postalText == textField {
            TrainerProfile.postalCode = textField.text!
        }else if mobileText == textField {
            TrainerProfile.mobile = textField.text!
        }else if drivingLicenseText == textField {
            TrainerProfile.drivingLicense = textField.text!
        }else if licenseStateText == textField {
            TrainerProfile.licenseState = textField.text!
        }else if vichleTypeText == textField {
            TrainerProfile.vichleType = textField.text!
        }else if vichleModelText == textField {
            TrainerProfile.vichleModel = textField.text!
        }else if experienceYearText == textField {
            TrainerProfile.experienceYear = textField.text!
        }else if drivingSchoolNameText == textField {
            TrainerProfile.drivingSchoolName = textField.text!
        }
    }
    
}



