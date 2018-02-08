//
//  ProfessionalInformation_TVC.swift
//  Driving Trainers
//
//  Created by iWeb on 09/01/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class ProfessionalInformation_TVC: UITableViewCell {
    @IBOutlet weak var paymentModeText: UITextField!
    @IBOutlet weak var diaNoText: UITextField!
    @IBOutlet weak var diaDateText: UITextField!
    @IBOutlet weak var vichleTypeText: UITextField!
    @IBOutlet weak var aboutText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Utility.underLine(txt: paymentModeText)
        Utility.underLine(txt: diaNoText)
        Utility.underLine(txt: diaDateText)
        Utility.underLine(txt: vichleTypeText)
        Utility.underLine(txt: aboutText)
        
        paymentModeText.delegate = self
        diaNoText.delegate = self
        vichleTypeText.delegate = self
        aboutText.delegate = self
        diaDateText.delegate = self
        
        diaDateText.addTarget(self, action: #selector(self.datePicker(_:)), for: UIControlEvents.editingDidBegin)
    }
    
   
    @IBAction func datePicker(_ sender: UITextField) {
        if General.myProfileEdit == false {
            return
        }
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePickerforDOB(sender:)), for: .valueChanged)
        
    }
    
    @objc func handleDatePickerforDOB(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        diaDateText.text = dateFormatter.string(from: sender.date)
        TrainerProfile.DiaExpertationRate  = diaDateText.text!
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ProfessionalInformation_TVC:UITextFieldDelegate {
    
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
        if textField == paymentModeText {
            TrainerProfile.paymentModeAccepting = textField.text!
        }else if textField == diaNoText {
            TrainerProfile.DiaNumber = textField.text!
        }else if textField == diaDateText {
            TrainerProfile.DiaExpertationRate = textField.text!
        }else if textField == vichleTypeText {
            TrainerProfile.vichleType = textField.text!
        }
    }
}
