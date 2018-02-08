//
//  Account_VC.swift
//  Driving Trainers
//
//  Created by iws on 1/18/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import NVActivityIndicatorView
import NotificationBannerSwift
import UIKit

class Account_VC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var navigationView: UIView!
    var dataArr:[Account] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        Utility.shadowInView(view: backgroundView)
        Utility.viewGradient(view: gradientView)
        Utility.navigationBarView(view: navigationView)
        tableView.separatorStyle = .none
        self.navigationController?.navigationBar.isHidden = true
        self.getData()
    }
    @IBAction func menuAction(_ sender: UIButton) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        let data:[String:Any] = [
            "trainer_id":  UserData.Id
        ]
        
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.accountAPI , dataDict: data, { (Json) in
            print(Json)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if Json["status"].stringValue == "True" {
                
                for i in 0..<Json["account"].arrayValue.count{
                
                self.dataArr.append(Account.init(
                    name:Json["account"][i]["Bookinginvite"]["student_name"].stringValue,
                    paymentStatus: Json["account"][i]["payment_status"].stringValue,
                    bookingId: Json["account"][i]["booking_id"].stringValue,
                    trainerAmt: Json["account"][i]["trainer_amt"].stringValue,
                    paymentMode: Json["account"][i]["Bookinginvite"]["payment_mode"].stringValue,
                    lessionName: Json["account"][i]["lesson_name"].stringValue,
                    referredBy: Json["account"][i]["Bookinginvite"]["referred_person_name"].stringValue
                    
                ))
                }
                
                self.tableView.reloadData()
            }else if Json["status"].stringValue == "False"  {
                let banner = NotificationBanner(title: "Alert", subtitle: Json["message"].stringValue, style: .danger)
                banner.show(queuePosition: .front)
            }
            
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(error)
        }
    }

   @objc func btnAction(sender:UIButton) {
        self.showPopUp(sender, referredBy: self.dataArr[sender.tag].referredBy, commision: self.dataArr[sender.tag].trainerAmt)
    
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

extension Account_VC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Account_TVC", for: indexPath) as! Account_TVC
        cell.nameLabel.text =  self.dataArr[indexPath.row].name
        cell.amountLabel.text = "$" + self.dataArr[indexPath.row].trainerAmt + ", " + self.dataArr[indexPath.row].lessionName
        
        if self.dataArr[indexPath.row].paymentStatus == "1" {
            cell.paymentMode.text = "PAID, " + self.dataArr[indexPath.row].paymentMode
        }else {
            cell.paymentMode.text = "UNPAID, " + self.dataArr[indexPath.row].paymentMode
        }
        cell.showBtn.tag = indexPath.row
        cell.showBtn.addTarget(self, action: #selector(self.btnAction(sender:)), for: UIControlEvents.touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
}

extension Account_VC : UIPopoverPresentationControllerDelegate {
    
    func showPopUp(_ sender:UIButton, referredBy:String, commision:String) {
        let storyBoard = UIStoryboard(name: "Trainer", bundle: nil)
        let popController = storyBoard.instantiateViewController(withIdentifier: "AccountPopUp_VC_id") as!  AccountPopUp_VC
        popController.referredBy = referredBy
        popController.commision = commision
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = sender
        popController.popoverPresentationController?.sourceRect = sender.bounds
        popController.preferredContentSize = CGSize(width: 250, height: 200)
        self.present(popController, animated: true, completion: nil)
       
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle{
        return UIModalPresentationStyle.none
    }
    
}
