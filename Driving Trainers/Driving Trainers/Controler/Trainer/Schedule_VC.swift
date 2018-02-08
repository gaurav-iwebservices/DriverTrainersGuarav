//
//  Schedule_VC.swift
//  Driving Trainers
//
//  Created by iws on 1/18/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import NVActivityIndicatorView

class Schedule_VC: UIViewController {

    @IBOutlet weak var timeText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var navigationView: UIView!
    var bookingId:String!
    var state:String!
    override func viewDidLoad() {
        super.viewDidLoad()

        Utility.shadowInView(view: backgroundView)
        Utility.buttonGradient(button: submitBtn)
        Utility.navigationBarView(view: navigationView)
        Utility.viewGradient(view: gradientView)
        Utility.underLine(txt: dateText)
        Utility.underLine(txt: timeText)
        
        submitBtn.layer.cornerRadius = submitBtn.frame.size.height/2
        
      //  dateText.delegate = self
        //timeText.delegate = self
        dateText.addTarget(self, action: #selector(self.datePicker(_:)), for: UIControlEvents.editingDidBegin)
        timeText.addTarget(self, action: #selector(self.datePicker(_:)), for: UIControlEvents.editingDidBegin)
        
    }

    
    @IBAction func menuAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
   
     @IBAction func datePicker(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        sender.inputView = datePickerView
        
        if sender == dateText {
            var minimumDate: Date {
                return (Calendar.current as NSCalendar).date(byAdding: .year, value: 1, to: Date(), options: [])!
            }
            datePickerView.datePickerMode = .date
            datePickerView.minimumDate = Date()
            datePickerView.addTarget(self, action: #selector(handleDatePickerforDate(sender:)), for: .valueChanged)
        }else if sender == timeText {
            datePickerView.datePickerMode = .time
            datePickerView.addTarget(self, action: #selector(handleDatePickerforTime(sender:)), for: UIControlEvents.valueChanged)
        }
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
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        var dataDic:[String:String]
        if (DataManger._gDataManager.isFromLearnerShedule){
            dataDic = [
                "booking_id":bookingId,
                "date": dateText.text!,
                "time": timeText.text!,
                "schedule": "2"
                // [1=schedule,2=reschedule,3=cancel]"
            ]
            
        }
        else{
            dataDic = [
                "booking_id":bookingId,
                "date": dateText.text!,
                "time": timeText.text!,
                "schedule": state            // [1=schedule,2=reschedule,3=cancel]"
            ]
        }
        
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
 
        
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.appointmentScheduleReschedule, dataDict: dataDic, { (json) in
            print(json)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            self.dateText.text! = ""
            self.timeText.text! = ""
            if json["status"].stringValue == "True" {
                let banner = NotificationBanner(title: "Confirmation", subtitle: json["message"].stringValue, style: .success)
                banner.show(queuePosition: .front)
            }else  if json["status"].stringValue == "False" {
                let banner = NotificationBanner(title: "Alert", subtitle: json["message"].stringValue, style: .danger)
                banner.show(queuePosition: .front)
            }
            
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
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

extension Schedule_VC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
