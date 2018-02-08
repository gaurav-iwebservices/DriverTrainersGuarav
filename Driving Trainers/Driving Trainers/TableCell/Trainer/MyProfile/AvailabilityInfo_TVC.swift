//
//  AvailabilityInfo_TVC.swift
//  Driving Trainers
//
//  Created by iWeb on 09/01/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class AvailabilityInfo_TVC: UITableViewCell {

    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var satBtn: UIButton!
    @IBOutlet weak var friBtn: UIButton!
    @IBOutlet weak var thuBtn: UIButton!
    @IBOutlet weak var wedBtn: UIButton!
    @IBOutlet weak var tueBtn: UIButton!
    @IBOutlet weak var monBtn: UIButton!
    @IBOutlet weak var sunBtn: UIButton!
    var availableArr = [2,2,2,2,2,2,2,2]
    
    @IBOutlet weak var toText: UITextField!
    @IBOutlet weak var fromText: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        Utility.underLine(txt: toText)
        Utility.underLine(txt: fromText)
        
        toText.delegate = self
        fromText.delegate = self
        
        toText.addTarget(self, action: #selector(self.datePicker(_:)), for: UIControlEvents.editingDidBegin)
        fromText.addTarget(self, action: #selector(self.datePicker(_:)), for: UIControlEvents.editingDidBegin)
        
        sunBtn.addTarget(self, action: #selector(self.btnClickAction(sender:)), for: UIControlEvents.touchUpInside)
        monBtn.addTarget(self, action: #selector(self.btnClickAction(sender:)), for: UIControlEvents.touchUpInside)
        tueBtn.addTarget(self, action: #selector(self.btnClickAction(sender:)), for: UIControlEvents.touchUpInside)
        wedBtn.addTarget(self, action: #selector(self.btnClickAction(sender:)), for: UIControlEvents.touchUpInside)
        thuBtn.addTarget(self, action: #selector(self.btnClickAction(sender:)), for: UIControlEvents.touchUpInside)
        friBtn.addTarget(self, action: #selector(self.btnClickAction(sender:)), for: UIControlEvents.touchUpInside)
        satBtn.addTarget(self, action: #selector(self.btnClickAction(sender:)), for: UIControlEvents.touchUpInside)
        allBtn.addTarget(self, action: #selector(self.allClickAction(sender:)), for: UIControlEvents.touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func datePicker(_ sender: UITextField) {
        
        if General.myProfileEdit == false {
            return
        }
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .time
        sender.inputView = datePickerView
        
        if sender == fromText {
            datePickerView.addTarget(self, action: #selector(handleDatePickerforFromText(sender:)), for: .valueChanged)
        }else if sender == toText {
            datePickerView.addTarget(self, action: #selector(handleDatePickerforToText(sender:)), for: UIControlEvents.valueChanged)
        }
    }
    
    @objc func handleDatePickerforFromText(sender: UIDatePicker) {
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:MM a"
        fromText.text = dateFormatter.string(from: sender.date)
        TrainerProfile.fromHour = fromText.text!.components(separatedBy: " ")[0]
        TrainerProfile.fromTime = fromText.text!.components(separatedBy: " ")[1]
    }
    
    @objc func handleDatePickerforToText(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:MM a"
        toText.text = dateFormatter.string(from: sender.date)
        TrainerProfile.toHour = toText.text!.components(separatedBy: " ")[0]
        TrainerProfile.toTime = toText.text!.components(separatedBy: " ")[1]
    }
    
    @objc func btnClickAction(sender:UIButton){
        if General.myProfileEdit == false {
            return
        }
        if availableArr[sender.tag] == 2 {
            availableArr[sender.tag] = 1
            sender.setImage(UIImage(named:"tick"), for: UIControlState.normal)
        }else{
            availableArr[sender.tag] = 2
            availableArr[7] = 2
            allBtn.setImage(UIImage(named:"untick"), for: UIControlState.normal)
            sender.setImage(UIImage(named:"untick"), for: UIControlState.normal)
        }
        self.fillData()
    }
    
    @objc func allClickAction(sender:UIButton){
        if General.myProfileEdit == false {
            return
        }
        if availableArr[sender.tag] == 2 {
            availableArr = [1,1,1,1,1,1,1,1]
            sender.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            sunBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            monBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            tueBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            wedBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            thuBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            friBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            satBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            
        }else{
            availableArr[sender.tag] = 2
            sender.setImage(UIImage(named:"untick"), for: UIControlState.normal)
        }
        self.fillData()
    }
    
    func setAvailDays(arr:[Int]) {
        if arr[7] == 1 {
            availableArr = [1,1,1,1,1,1,1,1]
            allBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            sunBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            monBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            tueBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            wedBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            thuBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            friBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            satBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
        }else{
            if arr[0] == 1 {
                sunBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            }
            if arr[1] == 1 {
                monBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            }
            if arr[2] == 1 {
                tueBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            }
            if arr[3] == 1 {
                wedBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            }
            if arr[4] == 1 {
                thuBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            }
            if arr[5] == 1 {
                friBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            }
            if arr[6] == 1 {
                satBtn.setImage(UIImage(named:"tick"), for: UIControlState.normal)
            }
            availableArr = arr
        }
        self.fillData()
    }
    
    func fillData() {
        TrainerProfile.sun = availableArr[0]
        TrainerProfile.mon = availableArr[1]
        TrainerProfile.tue = availableArr[2]
        TrainerProfile.wed = availableArr[3]
        TrainerProfile.thu = availableArr[4]
        TrainerProfile.fri = availableArr[5]
        TrainerProfile.sat = availableArr[6]
        TrainerProfile.sun = availableArr[7]
    }
    
}

extension AvailabilityInfo_TVC:UITextFieldDelegate {
    
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
}
