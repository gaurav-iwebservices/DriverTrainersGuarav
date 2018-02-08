//
//  FeeInfo_TVC.swift
//  Driving Trainers
//
//  Created by iws on 1/15/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class FeeInfo_TVC: UITableViewCell {

    @IBOutlet weak var feeText: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        Utility.underLine(txt: feeText)
        feeText.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}

extension FeeInfo_TVC:UITextFieldDelegate {
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
        if feeText == textField {
            TrainerProfile.feeInfo = textField.text!
        }
    }
    
}
