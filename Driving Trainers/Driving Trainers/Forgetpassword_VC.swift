//
//  Forgetpassword_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 12/18/17.
//  Copyright © 2017 iWeb. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class Forgetpassword_VC: UIViewController {

    @IBOutlet weak var subview_1: UIView!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var txt_email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()

        
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func submit_touch(_ sender: Any) {
        if (userInputValue())
        {
            self.hitforgotPasswordAPI()
        }
    }
    func hitforgotPasswordAPI() {
        
       
            
            var loginDictionary = [String: Any]()
            loginDictionary["email"] = txt_email.text
            
            
          //  NVActivityIndicatorView.DEFAULT_TYPE = .orbit
            let activityData = ActivityData()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
            
            DataParser.globalAPIDetils(loginDictionary,Defines.forgotPasswordAPI, withCompletionHandler: { (dict, isSuccessfull) in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                if(isSuccessfull)
                {
                    let status:String = dict?["status"] as! String
                    
                    if (status == "True")
                    {
                        let messageTxt:String = dict?["message"] as! String

                        Utility.showAlertMessage(vc: self, titleStr: Defines.alterTitle, messageStr: messageTxt)
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
    
   
   
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    @IBAction func back_touch(_ sender: Any) {
        
    }
    func createUI() {
        Utility.shadowInView(view: subview_1)
        Utility.underLine(txt: txt_email)
        Utility.buttonGradient(button: btn_submit)
        Utility.viewGradient(view: subview)
        btn_submit.layer.cornerRadius = btn_submit.frame.size.height/2
        
    }
    func userInputValue() -> Bool
    {
        
        
        if (txt_email.text == "")
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Oops! We still need your Email Address.")
            return false
        }
        else if !Utility.emailValidation(txt_email.text!)
        {
            Utility.showAlertMessage(vc: self, titleStr: "", messageStr: "Oops! We still need your valid Email Address.")
            return false
            
        }
        return true
    }
}
