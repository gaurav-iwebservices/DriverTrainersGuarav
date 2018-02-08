//
//  LearnerHome_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 1/9/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class LearnerHome_VC: UIViewController {
    @IBOutlet weak var view_shadow: UIView!
    var selectedMybookData: LearnerMybookModel?

    var mybookingListArray:[Any] = []
    var trainerInfo: NSDictionary!

    @IBOutlet weak var lbl_dashboard: UILabel!
    
    
    @IBOutlet weak var view_navigation: UIView!
    @IBOutlet weak var tbl_home: UITableView!
    @IBOutlet weak var view_gradient: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(DataManger._gDataManager.isFromProgress){
            lbl_dashboard.text = "PROGRESS"
        }
        
        self.myappointmentAPI()
        self.navigationController?.navigationBar.isHidden = true
        
        Utility.navigationBarView(view: view_navigation)
        Utility.viewGradient(view: view_gradient)
        Utility.shadowInView(view: view_shadow)
      
        // Do any additional setup after loading the view.
    }

    @IBAction func btn_appointment(_ sender: Any) {
        let storyBoardid = UIStoryboard(name: "Learner", bundle: nil)
        let destVC: MakeAppointment_VC? = storyBoardid.instantiateViewController(withIdentifier: "MakeAppointment_VC_id") as? MakeAppointment_VC
        navigationController?.pushViewController(destVC!, animated: true)
        
    }
    @IBAction func btn_touch(_ sender: Any) {
        navigationController?.popViewController(animated: true)
       // self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }

    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}

extension LearnerHome_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mybookingListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LearnerDash_TVC", for: indexPath) as! LearnerDash_TVC
        
        let data: LearnerMyAppointmentModel? = self.mybookingListArray[indexPath.row] as? LearnerMyAppointmentModel

       let firstname = trainerInfo["fname"] as? String ?? ""
        let lastname = trainerInfo["lname"] as? String ?? ""

        
        
        if (DataManger._gDataManager.imageProgressUrl != "") {
            
            let imagepath: String = DataManger._gDataManager.profileImageUrl + DataManger._gDataManager.imageProgressUrl
            cell.img_home.downloadedFrom(url: URL(string: imagepath)!)
        }

       cell.lbl_1.text = (firstname) + " " + (lastname)
        cell.lbl_2.text = (data?.schedule_date)! + ", " + (data?.schedule_time)!
        if data?.payment_status == "0"{
            cell.lbl_3.text = (data?.duration)! + ", $" + (data?.lesson_amt)! + " UNPAID"
        }
        else{
            cell.lbl_3.text = (data?.duration)! + ", $" + (data?.lesson_amt)! + " PAID"
        }
        
        if (data?.lesson_status == "0") || (data?.lesson_status == "3"){
            cell.btn_1.isHidden = true
        }
        else{
            cell.btn_1.isHidden = false
            cell.btn_1.tag = indexPath.row
            cell.btn_1.addTarget(self, action: #selector(self.normalAction), for: .touchUpInside)
        }
        
        

        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
//        let destVC: LearnerProfile_VC? = storyBoardid.instantiateViewController(withIdentifier: "LearnerProfile_VC_id") as? LearnerProfile_VC
//        destVC?.studentId = TrainerProfile.dataArr[indexPath.row].studentId
//        navigationController?.pushViewController(destVC!, animated: true)
    }
    
    
    
    func myappointmentAPI() {
        
        
        let dataDict:[String:String] = [
            "learner_id": UserData.Id,
            "trainer_id": self.selectedMybookData!.instructor_id,
            "booking_id": self.selectedMybookData!.data_id,
            ]
        
       // NVActivityIndicatorView.DEFAULT_TYPE = .orbit
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataParser.myAppoinmentAPIDetils(dataDict,Defines.myAppoinmentListAPI, withCompletionHandler: { (array,dic, isSuccessfull) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if(isSuccessfull)
            {
                self.mybookingListArray = array as! [Any]
                self.trainerInfo = dic
                self.tbl_home.reloadData()
                print("success")
            }
            else
            {
                Utility.showAlertMessage(vc: self, titleStr: Defines.alterTitle, messageStr: Defines.loginErrorMessage)
            }
            
        })
        
        
    }

}
extension LearnerHome_VC : UIPopoverPresentationControllerDelegate,PopUpViewControllerDelegate {
    
   //func dropDown(_ sender: Any , selector:[String]) {

    @objc func normalAction(_ sender: Any) {
        print("ankur")
        let data: LearnerMyAppointmentModel? = self.mybookingListArray[(sender as AnyObject).tag] as? LearnerMyAppointmentModel
        print(data?.lesson_status  ?? 0)
         let storyBoard = UIStoryboard(name: "Trainer", bundle: nil)
        let popController = storyBoard.instantiateViewController(withIdentifier: "PopUpViewController") as!  PopUpViewController
        popController.delegate = self
        if data?.lesson_status == "1"{
            let selector = ["Schedule"]
            popController.arr = selector

        }
        else if data?.lesson_status == "2"{
            let selector = ["Reschedule"]
            popController.arr = selector

        }
        else if data?.lesson_status == "4"{
            let selector = ["Progress","Give Feedback"]
            popController.arr = selector
        }
        let tagValue: Int = (sender as AnyObject).tag
        popController.tagValue = tagValue
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = sender as? UIView
        popController.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
        popController.preferredContentSize = CGSize(width: 200, height: 200)
        self.present(popController, animated: true, completion: nil)
        //tmpTextField = textField
    }
    
    func saveString(_ strText: String) {
        
       
        
    }
    func idString(_ strText: String) {
        print(strText)
    }
    func getTagOfTable(_ tblTag : Int, _ indexValue : String) {
        print("Tag Value")
        print(indexValue)
        
        if(DataManger._gDataManager.isFromProgress){
            if (indexValue == "0"){
                let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
                let destVC: AppointmentProgress_VC? = storyBoardid.instantiateViewController(withIdentifier: "AppointmentProgress_VC_id") as? AppointmentProgress_VC
                let data: LearnerMyAppointmentModel? = self.mybookingListArray[tblTag] as? LearnerMyAppointmentModel
                destVC?.lessionId = data?.data_id
                destVC?.trainerId = self.selectedMybookData!.instructor_id
                destVC?.appointmentView = true
                navigationController?.pushViewController(destVC!, animated: true)
            }
            else{
                
                self.getFeedbackStatus(tblTag)
            }
        }
        else{
            
            DataManger._gDataManager.isFromLearnerShedule = true
            let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
            let destVC: Schedule_VC? = storyBoardid.instantiateViewController(withIdentifier: "Schedule_VC_id") as? Schedule_VC
            let data: LearnerMyAppointmentModel? = self.mybookingListArray[tblTag] as? LearnerMyAppointmentModel
            destVC?.bookingId = data?.booking_id
            navigationController?.pushViewController(destVC!, animated: true)
           
        }
    }
    
    func getFeedbackStatus(_ tblTag: Int) {
        let data: LearnerMyAppointmentModel? = self.mybookingListArray[tblTag] as? LearnerMyAppointmentModel
        let dataDict:[String:String] = [
            "learner_id": UserData.Id,
            "trainer_id":self.selectedMybookData!.instructor_id,
            "lesson_id":(data?.lesson_id)!,
            ]
      //  NVActivityIndicatorView.DEFAULT_TYPE = .orbit
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataParser.globalAPIDetils(dataDict,Defines.addFeedBack, withCompletionHandler: { (dict, isSuccessfull) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if(isSuccessfull){
                let status:String = dict?["status"] as! String
                
                if (status == "True")
                {
                    let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
                    let destVC: Feedback_VC? = storyBoardid.instantiateViewController(withIdentifier: "Feedback_VC_id") as? Feedback_VC
                    let data: LearnerMyAppointmentModel? = self.mybookingListArray[tblTag] as? LearnerMyAppointmentModel
                    destVC?.lessionId = data?.lesson_id
                    destVC?.trainerId = self.selectedMybookData!.instructor_id
                    self.navigationController?.pushViewController(destVC!, animated: true)

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
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle{
        return UIModalPresentationStyle.none
    }
    
}
