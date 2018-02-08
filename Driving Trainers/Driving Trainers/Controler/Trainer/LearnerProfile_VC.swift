//
//  LearnerProfile_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 08/01/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LearnerProfile_VC: UIViewController {

    
    @IBOutlet weak var learnerNameLabel: UILabel!
    @IBOutlet weak var navigationView: UIView!
    var studentId:String!
    @IBOutlet weak var referredText: UITextField!
    @IBOutlet weak var licenseText: UITextField!
    @IBOutlet weak var statusText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var learnerIdText: UITextField!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var bookNowBtn: UIButton!
    
    var postalCode:String!
    var package:String!
    var lession:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookNowBtn.layer.cornerRadius = bookNowBtn.frame.size.height/2
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.layer.borderWidth = 1
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.masksToBounds = true
        
        Utility.buttonGradient(button: bookNowBtn)
        Utility.viewGradient(view: gradientView)
        
        referredText.delegate = self
        licenseText.delegate = self
        statusText.delegate = self
        addressText.delegate = self
        phoneText.delegate = self
        emailText.delegate = self
        learnerIdText.delegate = self
   
        Utility.navigationBarView(view: navigationView)
        
        self.getLearnerProfile()
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getLearnerProfile() {
        let data:[String:String] = ["lerner_id" : studentId]
        
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.learnerProfile, dataDict: data, { (json) in
             NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(json)
            if json["status"].stringValue == "True" {
                 self.learnerIdText.text =  json["data"]["student_id"].stringValue
                 self.emailText.text = json["data"]["email"].stringValue
                 self.phoneText.text = json["data"]["mobile"].stringValue
                 self.addressText.text = json["data"]["address"].stringValue
                
                if json["data"]["status"].stringValue == "1" {
                    self.statusText.text = "Active"
                }else{
                    self.statusText.text = "Inactive"
                }
                 self.licenseText.text = json["data"]["current_license"].stringValue
                 self.referredText.text = json["data"]["ref_person_name"].stringValue
                
                self.lession =  json["data"]["lessionname"].stringValue
                self.package =  json["data"]["package"].stringValue
                self.postalCode =  json["data"]["postal_code"].stringValue
                self.userImage.downloadedFrom(url: URL(string:  json["imgpath"].stringValue +  json["data"]["profile_pic"].stringValue)!)
                self.learnerNameLabel.text = json["data"]["fname"].stringValue + " " + json["data"]["lname"].stringValue 
            }
            
            
        }) { (error) in
             NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(error)
        }
        
    }
    
    @IBAction func bookNowAction(_ sender: UIButton) {
        let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
        let destVC: BookingForm_VC? = storyBoardid.instantiateViewController(withIdentifier: "BookingForm_VC_id") as? BookingForm_VC
        destVC?.package = self.package
        destVC?.lession = self.lession
        destVC?.postalCode = self.postalCode
        destVC?.learnerId = self.studentId
        navigationController?.pushViewController(destVC!, animated: true)
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

extension LearnerProfile_VC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
