//
//  ContactUs_VC.swift
//  Driving Trainers
//
//  Created by iws on 1/29/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import NVActivityIndicatorView

class TrainerContactUs_VC: UIViewController {
    @IBOutlet weak var stateText: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var suburbText: UITextField!
    @IBOutlet weak var queryText: UITextField!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phonelabel: UILabel!
    
    var tmpTextField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        Utility.underLine(txt: nameText)
        Utility.underLine(txt: emailText)
        Utility.underLine(txt: phoneText)
        Utility.underLine(txt: suburbText)
        Utility.underLine(txt: queryText)
        Utility.underLine(txt: stateText)
        
        nameText.delegate = self
        emailText.delegate = self
        phoneText.delegate = self
        suburbText.delegate = self
        queryText.delegate = self
        stateText.delegate = self
        
        emailLabel.text = UserData.email
        phonelabel.text = "1234567890"
        //addressLabel.text = UserData
        
        Utility.shadowInView(view: shadowView)
        Utility.viewGradient(view: gradientView)
        Utility.navigationBarView(view: navigationView)
        submitBtn.layer.cornerRadius = submitBtn.frame.size.height/2
        Utility.buttonGradient(button: submitBtn)
        
        self.setImageInTextField(textField: stateText)
        self.setImageInTextField(textField: suburbText)
        
        submitBtn.addTarget(self, action: #selector(self.submitQueryAction), for: UIControlEvents.touchUpInside)
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
    }
    
    func  setImageInTextField(textField:UITextField) {
        textField.rightViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: "dropdown")
        textField.rightView = imageView
    }

   @objc func submitQueryAction() {
        let data:[String:String] = [
            "name":nameText.text!,
            "email": emailText.text!,
            "phone": phoneText.text!,
            "suburp":suburbText.text!,
            "query":queryText.text!
        ]
    
        if Reachability.isConnectedToNetwork() == false {
            return
        }
    
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
 
    
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.contactUsAPI, dataDict: data, { (json) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(json)
            
            if json["status"].stringValue == "True" {
                let banner = NotificationBanner(title: "Confirmation", subtitle: json["massage"].stringValue , style: .success)
                banner.show(queuePosition: .front)
            }else if json["status"].stringValue == "False" {
                let banner = NotificationBanner(title: "Alert", subtitle: json["massage"].stringValue , style: .danger)
                banner.show(queuePosition: .front)
            }
        }) { (error) in
            print(error)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
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

extension TrainerContactUs_VC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == stateText {
            dropDown(textField, selector: Utility.getStateList().0)
            return false
        }else  if textField == suburbText {
            dropDown(textField, selector: Utility.getSuburbList(state: stateText.text!).0)
            return false
        }else{
            return true
        }
    }
    
}


extension TrainerContactUs_VC : UIPopoverPresentationControllerDelegate,PopUpViewControllerDelegate {
    
    func dropDown(_ textField:UITextField , selector:[String]) {
        let storyBoard = UIStoryboard(name: "Trainer", bundle: nil)
        let popController = storyBoard.instantiateViewController(withIdentifier: "PopUpViewController") as!  PopUpViewController
        popController.delegate = self
        popController.arr = selector
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = textField
        popController.popoverPresentationController?.sourceRect = textField.bounds
        popController.preferredContentSize = CGSize(width: 200, height: 200)
        self.present(popController, animated: true, completion: nil)
        tmpTextField = textField
    }
    
    func saveString(_ strText: String) {
        tmpTextField.text = strText
    }
    func idString(_ idText: String) {
      
        
    }
    func getTagOfTable(_ tblTag : Int, _ indexValue : String) {
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle{
        return UIModalPresentationStyle.none
    }
    
}
