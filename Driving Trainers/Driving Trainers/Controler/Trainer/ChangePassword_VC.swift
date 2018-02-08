//
//  ChangePassword_VC.swift
//  Driving Trainers
//
//  Created by iws on 1/10/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import NVActivityIndicatorView

class ChangePassword_VC: UIViewController {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var confirmText: UITextField!
    @IBOutlet weak var newText: UITextField!
    @IBOutlet weak var oldText: UITextField!
    @IBOutlet weak var shadowView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        Utility.shadowInView(view: shadowView)
        Utility.buttonGradient(button: saveButton)
        Utility.navigationBarView(view: navigationView)
        Utility.viewGradient(view: gradientView)
        self.navigationController?.navigationBar.isHidden = true
        Utility.underLine(txt: confirmText)
        Utility.underLine(txt: newText)
        Utility.underLine(txt: oldText)
        
        newText.delegate = self
        oldText.delegate = self
        confirmText.delegate = self
        
        saveButton.layer.cornerRadius = saveButton.frame.size.height/2
    }

    @IBAction func menuAction(_ sender: UIButton) {
         self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        if oldText.text!.count == 0 {
            let banner = NotificationBanner(title: "Alert", subtitle: "Old password field should not be blank.", style: .danger)
            banner.show(queuePosition: .front)
            return
        }
        
        if newText.text!.count == 0 || newText.text!.count < 7  {
            let banner = NotificationBanner(title: "Alert", subtitle: "New password should be minimum 8 characters.", style: .danger)
            banner.show(queuePosition: .front)
            
            return
        }
        
        if newText.text! != confirmText.text! {
            let banner = NotificationBanner(title: "Alert", subtitle: "New password and confirm password does not match.", style: .danger)
            banner.show(queuePosition: .front)
            return
        }
        
        let dataDict:[String:String] = [
            "userid" : UserData.Id,
            "currentpassword" : oldText.text!,
            "newpassword": newText.text!,
            "confirmnewpass": confirmText.text!
        ]
        
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

        
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.changePassword, dataDict: dataDict, { (json) in
            print(json)
             NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if json["status"].stringValue == "True" {
                self.newText.text! = ""
                self.oldText.text! = ""
                self.confirmText.text! = ""
                let banner = NotificationBanner(title: "Confirmation", subtitle: json["message"].stringValue, style: .success)
                banner.show(queuePosition: .front)
            }else if json["status"].stringValue == "False" {
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

extension ChangePassword_VC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == oldText {
            if oldText.text!.count == 0 {
                let banner = NotificationBanner(title: "Alert", subtitle: "Old password field should not be blank.", style: .danger)
                banner.show(queuePosition: .front)
            }
        }else if textField == newText {
            if newText.text!.count == 0 || newText.text!.count < 8 {
                let banner = NotificationBanner(title: "Alert", subtitle: "New password should be minimum 8 characters.", style: .danger)
                banner.show(queuePosition: .front)
            }
        }else if textField == confirmText {
            if newText.text! != confirmText.text! {
                let banner = NotificationBanner(title: "Alert", subtitle: "New password and confirm password does not match.", style: .danger)
                banner.show(queuePosition: .front)
            }
        }
        
        return true
    }
}
