//
//  MyAppointment_VC.swift
//  Driving Trainers
//
//  Created by iws on 1/10/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MyAppointment_VC: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var gradientView: UIView!
    var tmpTextField:UITextField!
    var customView:FilterView!
    //let blueInstagramColor = UIColor(red: 71/255.0, green: 71/255.0, blue: 71/255.0, alpha: 1.0)
     let blueInstagramColor = UIColor.white
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
       // settings.style.selectedBarBackgroundColor = UIColor(red: 0.0/255.0, green: 182.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        settings.style.selectedBarBackgroundColor = UIColor.white
       
            settings.style.buttonBarItemFont = UIFont(name: "Helvetica", size: 16)!
        
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor(red: 146/255.0, green: 147/255.0, blue: 156/255.0, alpha: 0.8)
        
        settings.style.buttonBarItemTitleColor = UIColor.white
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
           // oldCell?.label.textColor = UIColor(red: 146/255.0, green: 147/255.0, blue: 156/255.0, alpha: 0.8)
            oldCell?.label.textColor = UIColor.white.withAlphaComponent(0.7)
            newCell?.label.textColor = self?.blueInstagramColor
           
        }

        super.viewDidLoad()
       
        Utility.viewGradient(view: gradientView)
        self.navigationController?.navigationBar.isHidden = true
        Utility.navigationBarView(view: navigationBar)
        
    }

    @IBAction func menuAction(_ sender: UIButton) {
         self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let childOneVC = storyboard?.instantiateViewController(withIdentifier: "UpComingAppointment_VC_id")
        let childTwoVC = storyboard?.instantiateViewController(withIdentifier: "CompletedAppointment_VC_id")
        let childThreeVC = storyboard?.instantiateViewController(withIdentifier: "CancelledAppointment_VC_id")
        
        return [childOneVC!, childTwoVC! , childThreeVC! ]
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        
        self.customView = FilterView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.customView.contactNumberText.delegate = self
        self.customView.learnerNameText.delegate = self
        self.customView.referedText.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.customView.view.addGestureRecognizer(tap)
        self.customView.view.isUserInteractionEnabled = true
        self.view.addSubview(self.customView)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.customView.removeFromSuperview()
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

extension MyAppointment_VC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.customView.referedText {
            self.dropDown(textField, selector: ["system","me"])
            return false
        }
        return true
    }
}

extension MyAppointment_VC : UIPopoverPresentationControllerDelegate,PopUpViewControllerDelegate {
    
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
        popController.preferredContentSize = CGSize(width: 150, height:80)
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
