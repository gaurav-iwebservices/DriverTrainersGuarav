//
//  BankInfo_TVC.swift
//  Driving Trainers
//
//  Created by iWeb on 09/01/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class BankInfo_TVC: UITableViewCell {

    @IBOutlet weak var accountNumberText: UITextField!
    @IBOutlet weak var bankSSBText: UITextField!
    @IBOutlet weak var bankNameText: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        Utility.underLine(txt: accountNumberText)
        Utility.underLine(txt: bankSSBText)
        Utility.underLine(txt: bankNameText)
        
        accountNumberText.delegate = self
        bankSSBText.delegate = self
        bankNameText.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension BankInfo_TVC: UITextFieldDelegate {
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
        if textField == accountNumberText {
            TrainerProfile.AccNumber = textField.text!
        }else if textField == bankSSBText {
            TrainerProfile.AccSSB = textField.text!
        }else if textField == bankNameText {
            TrainerProfile.bankAccName = textField.text!
        }
    }
}
