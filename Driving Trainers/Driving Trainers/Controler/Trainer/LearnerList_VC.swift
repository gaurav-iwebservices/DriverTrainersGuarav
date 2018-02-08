//
//  LearnerList_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 09/01/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import NVActivityIndicatorView

class LearnerList_VC: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    var tmpTextField:UITextField!
    var customView:FilterView!
    
    var searchActive:Bool = false
    var filterArr:[LearnerList] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shadowView.layer.cornerRadius = 5
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowRadius = 10
        
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.delegate = self
        
        self.navigationController?.navigationBar.isHidden = true
        
        Utility.navigationBarView(view: navigationView)
        Utility.viewGradient(view: gradientView)
        
        textFieldView.layer.cornerRadius = 5
        
        tableView.separatorStyle = .none
        
        self.getData()
    }
    
    @IBAction func addLearnerAction(_ sender: UIButton) {
        let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
        let center = storyBoardid.instantiateViewController(withIdentifier: "AddNewLearner_VC_id") as! AddNewLearner_VC
        self.navigationController?.pushViewController(center, animated: true)
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        self.customView = FilterView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.customView.contactNumberText.delegate = self
        self.customView.learnerNameText.delegate = self
        self.customView.referedText.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.customView.view.addGestureRecognizer(tap)
        self.customView.view.isUserInteractionEnabled = true
        self.customView.searchBtn.addTarget(self, action: #selector(self.getFilterData), for: UIControlEvents.touchUpInside)
        self.view.addSubview(self.customView)
    }
    
    @objc func getFilterData() {
        //learner_contactno,learner_name,refredby
        var refered = ""
        if customView.referedText.text! == "system" {
            refered = "1"
        }else{
            refered = UserData.Id
        }
        
        let data:[String:Any] = [
            "trainer_id": UserData.Id,
            "learner_contactno" : customView.contactNumberText.text!,
            "learner_name": customView.learnerNameText.text!,
            "refredby":refered
        ]
         self.customView.removeFromSuperview()
        
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.learnerList , dataDict: data, { (Json) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(Json)
            TrainerProfile.dataArr = []
            if Json["status"].stringValue == "True" {
                let count1 = Json["data"].count
                for i in 0..<count1 {
                    
                    TrainerProfile.dataArr.append(LearnerList.init(
                        id: Json["data"][i]["id"].stringValue,
                        package: Json["data"][i]["package"].stringValue,
                        
                                                                   instructorId: Json["data"][i]["instructor_id"].stringValue,
                                                                   instructorName: Json["data"][i]["instructor_name"].stringValue,
                                                                   lessionName: Json["data"][i]["lessionname"].stringValue,
                                                                   streetNo: Json["data"][i]["street_no"].stringValue,
                                                                   address: Json["data"][i]["address"].stringValue,
                                                                   status: Json["data"][i]["status"].stringValue,
                                                                   paymentMode: Json["data"][i]["payment_mode"].stringValue,
                                                                   requiredInstructorDate: Json["data"][i]["required_instructor_date"].stringValue,
                                                                   time: Json["data"][i]["ampm"].stringValue,
                                                                   streetName: Json["data"][i]["street_name"].stringValue,
                                                                   totalLession: Json["data"][i]["totallesson"].stringValue,
                                                                   completedLession: Json["data"][i]["completed_lesson"].stringValue,
                                                                   referedPersonName: Json["data"][i]["ref_person_name"].stringValue,
                                                                   remainingLession: Json["data"][i]["remaining_lesson"].stringValue,
                                                                   bookingId: Json["data"][i]["booking_id"].stringValue,
                                                                   referedPersonId: Json["data"][i]["referred_person_id"].stringValue,
                                                                   duration: Json["data"][i]["duration"].stringValue,
                                                                   requiredInstructorTime: Json["data"][i]["required_instructor_time"].stringValue,
                                                                   suburbPostCode: Json["data"][i]["suburb_post_code"].stringValue,
                                                                   amount: Json["data"][i]["amount"].stringValue,
                                                                   subrub: Json["data"][i]["suburb"].stringValue,
                                                                   requestAcceptDate: Json["data"][i]["request_accept_date"].stringValue,
                                                                   paymentId: Json["data"][i]["payment_id"].stringValue,
                                                                   postalCode: Json["data"][i]["postal_code"].stringValue,
                                                                   bookingDate: Json["data"][i]["booking_date"].stringValue,
                                                                   instructorEmail: Json["data"][i]["instructor_email"].stringValue,
                                                                   state: Json["data"][i]["state"].stringValue,
                                                                   studentName: Json["data"][i]["fname"].stringValue + " " +  Json["data"][i]["lname"].stringValue,
                                                                   studentId: Json["data"][i]["student_id"].stringValue,
                                                                   studentEmail: Json["data"][i]["student_email"].stringValue,
                                                                   imgPath: Json["imgpath"].stringValue + Json["data"][i]["profile_pic"].stringValue
                        )
                    )
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
    
   @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.customView.removeFromSuperview()                          
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
         self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
    }
    
    func getData() {
        let data:[String:Any] = [
            "trainer_id": UserData.Id
        ]
        
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.learnerList , dataDict: data, { (Json) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(Json)
            TrainerProfile.dataArr = []
            if Json["status"].stringValue == "True" {
                let count1 = Json["data"].count
                for i in 0..<count1 {
                
              TrainerProfile.dataArr.append(LearnerList.init(id: Json["data"][i]["id"].stringValue,
                                 package: Json["data"][i]["package"].stringValue,
                                 instructorId: Json["data"][i]["instructor_id"].stringValue,
                                 instructorName: Json["data"][i]["instructor_name"].stringValue,
                                 lessionName: Json["data"][i]["lessionname"].stringValue,
                                 streetNo: Json["data"][i]["street_no"].stringValue,
                                 address: Json["data"][i]["address"].stringValue,
                                 status: Json["data"][i]["status"].stringValue,
                                 paymentMode: Json["data"][i]["payment_mode"].stringValue,
                                 requiredInstructorDate: Json["data"][i]["required_instructor_date"].stringValue,
                                 time: Json["data"][i]["ampm"].stringValue,
                                 streetName: Json["data"][i]["street_name"].stringValue,
                                 totalLession: Json["data"][i]["totallesson"].stringValue,
                                 completedLession: Json["data"][i]["completed_lesson"].stringValue,
                                 referedPersonName: Json["data"][i]["ref_person_name"].stringValue,
                                 remainingLession: Json["data"][i]["remaining_lesson"].stringValue,
                                 bookingId: Json["data"][i]["booking_id"].stringValue,
                                 referedPersonId: Json["data"][i]["referred_person_id"].stringValue,
                                 duration: Json["data"][i]["duration"].stringValue,
                                 requiredInstructorTime: Json["data"][i]["required_instructor_time"].stringValue,
                                 suburbPostCode: Json["data"][i]["suburb_post_code"].stringValue,
                                 amount: Json["data"][i]["amount"].stringValue,
                                 subrub: Json["data"][i]["suburb"].stringValue,
                                 requestAcceptDate: Json["data"][i]["request_accept_date"].stringValue,
                                 paymentId: Json["data"][i]["payment_id"].stringValue,
                                 postalCode: Json["data"][i]["postal_code"].stringValue,
                                 bookingDate: Json["data"][i]["booking_date"].stringValue,
                                 instructorEmail: Json["data"][i]["instructor_email"].stringValue,
                                 state: Json["data"][i]["state"].stringValue,
                                 studentName: Json["data"][i]["fname"].stringValue + " " +  Json["data"][i]["lname"].stringValue  ,
                                 studentId: Json["data"][i]["student_id"].stringValue,
                                 studentEmail: Json["data"][i]["student_email"].stringValue,
                                 imgPath: Json["imgpath"].stringValue + Json["data"][i]["profile_pic"].stringValue
                )
                    )
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
   
    func filterArray(str:String) {
        filterArr = TrainerProfile.dataArr.filter({ (temp:LearnerList) -> Bool in
            return temp.studentName.lowercased().contains(str.lowercased())
        })
        
        self.tableView.reloadData()
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

extension LearnerList_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == true {
            return filterArr.count
        }else{
            return TrainerProfile.dataArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchActive == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LearnerList_TVC", for: indexPath) as! LearnerList_TVC
            cell.nameLabel.text = filterArr[indexPath.row].studentName
            cell.referedNameLabel.text = filterArr[indexPath.row].referedPersonName
            
            if filterArr[indexPath.row].imgPath != "" && filterArr[indexPath.row].imgPath != nil {
                cell.learnerImageView.downloadedFrom(url: URL(string: filterArr[indexPath.row].imgPath)!)
            }
            
            cell.selectionStyle = .none
            return cell
        }else{
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "LearnerList_TVC", for: indexPath) as! LearnerList_TVC
            cell.nameLabel.text = TrainerProfile.dataArr[indexPath.row].studentName
            cell.referedNameLabel.text = TrainerProfile.dataArr[indexPath.row].referedPersonName
           
            
            if TrainerProfile.dataArr[indexPath.row].imgPath != "" && TrainerProfile.dataArr[indexPath.row].imgPath != nil {
                cell.learnerImageView.downloadedFrom(url: URL(string: TrainerProfile.dataArr[indexPath.row].imgPath)!)
            }
        
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
        let destVC: LearnerProfile_VC? = storyBoardid.instantiateViewController(withIdentifier: "LearnerProfile_VC_id") as? LearnerProfile_VC
        if searchActive == true {
            destVC?.studentId = filterArr[indexPath.row].studentId
        }else{
            destVC?.studentId = TrainerProfile.dataArr[indexPath.row].studentId
        }
        navigationController?.pushViewController(destVC!, animated: true)
    }
}

extension LearnerList_VC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == searchTextField {
            if string == ""{
                if (textField.text!.count - 1) <= 0  {
                    self.searchActive = false
                    self.tableView.reloadData()
                }else{
                    self.searchActive = true
                    let str = textField.text!.dropLast()
                    self.filterArray(str: String(str))
                }
            }else {
                self.searchActive = true
                self.filterArray(str: textField.text! + string)
            }
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.customView != nil {
            if textField == self.customView.referedText {
                self.dropDown(textField, selector: ["system","me"])
                return false
            }
        }
        return true
    }
}

extension LearnerList_VC : UIPopoverPresentationControllerDelegate,PopUpViewControllerDelegate {
    
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
