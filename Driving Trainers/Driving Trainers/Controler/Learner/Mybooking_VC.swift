//
//  Mybooking_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 1/23/18.
//  Copyright © 2018 iWeb. All rights reserved.
//


//
//  LearnerHome_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 1/9/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
let learnerProfileNotificationKey = "com.drivertrainer.DrivingTrainers"


class Mybooking_VC: UIViewController {
    @IBOutlet weak var view_shadow: UIView!
    
    @IBOutlet weak var btn_booking: UIButton!
    @IBOutlet weak var lbl_dashboard: UILabel!
    @IBOutlet weak var view_navigation: UIView!
    @IBOutlet weak var tbl_home: UITableView!
    @IBOutlet weak var view_gradient: UIView!
    
    var mybookingListArray:[Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(DataManger._gDataManager.isFromProgress){
            lbl_dashboard.text = "PROGRESS"
            btn_booking.isHidden = true
        }
        else{
            btn_booking.isHidden = false
        }
        self.mybookingListAPI()
        self.myProfileAPI()

        self.navigationController?.navigationBar.isHidden = true
        
        Utility.navigationBarView(view: view_navigation)
        Utility.viewGradient(view: view_gradient)
        Utility.shadowInView(view: view_shadow)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_appointment(_ sender: Any) {
        let storyBoardid = UIStoryboard(name: "Learner", bundle: nil)
        let destVC: MakeAppointment_VC? = storyBoardid.instantiateViewController(withIdentifier: "MakeAppointment_VC_id") as? MakeAppointment_VC
        DataManger._gDataManager.isFromLessonPackage = false

        navigationController?.pushViewController(destVC!, animated: true)
        
    }
    @IBAction func btn_touch(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mybookingListAPI() {
        
       // NVActivityIndicatorView.DEFAULT_TYPE = .orbit
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        let dataDict:[String:String] = [
            "learner_id": UserData.Id,
            ]
        DataParser.mybookingListAPIDetils(dataDict,Defines.stateAPI, withCompletionHandler: { (array, isSuccessfull) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if(isSuccessfull)
            {
                self.mybookingListArray = array as! [Any]
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

extension Mybooking_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mybookingListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mybooking_TVC", for: indexPath) as! Mybooking_TVC
        
        cell.btn_view.tag = indexPath.row
        
        let data: LearnerMybookModel? = self.mybookingListArray[indexPath.row] as? LearnerMybookModel
        cell.lbl_package.text = data?.packagename
        cell.lbl_lesson.text = data?.lessionname
        cell.lbl_date.text =  (data?.required_instructor_date)! + " " + (data?.required_instructor_time)!
        if data?.status == "1"
        {
            cell.lbl_status.text = "Approved"
            cell.btn_view.isHidden = false
            cell.btn_view.addTarget(self, action: #selector(self.viewAction), for: .touchUpInside)

        }
        else
        {
            cell.lbl_status.text = "NOT Approved"
            cell.btn_view.isHidden = true
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    @objc func viewAction(_ sender: Any) {
        print("ankur")
        let buttonRow: Int = (sender as AnyObject).tag
        let data: LearnerMybookModel? = (self.mybookingListArray[buttonRow] as? LearnerMybookModel)
        let storyBoardid = UIStoryboard(name: "Learner", bundle: nil)
        let destVC: LearnerHome_VC? = storyBoardid.instantiateViewController(withIdentifier: "LearnerHome_VC_id") as? LearnerHome_VC
        destVC?.selectedMybookData = data
        navigationController?.pushViewController(destVC!, animated: true)
   
    }
    func myProfileAPI() {
        
        let dataDict:[String:String] = [
            "lerner_id": UserData.Id,
            ]
       // NVActivityIndicatorView.DEFAULT_TYPE = .orbit
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataParser.globalAPIDetils(dataDict,Defines.myViewPRofileLearnerAPI, withCompletionHandler: { (dict, isSuccessfull) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if(isSuccessfull){
                let status:String = dict?["status"] as! String
                
                if (status == "True")
                {
                    let profileData:NSDictionary = (dict?["data"] as? NSDictionary)!

                    DataManger._gDataManager.profileImageUrl = (dict?["imgpath"] as? String)!
                    DataManger._gDataManager.profileFname = (profileData["fname"] as? String)!
                    DataManger._gDataManager.profileLname = (profileData["lname"] as? String)!
                    DataManger._gDataManager.postal_Code = (profileData["postal_code"] as? String)!
                   // DataManger._gDataManager.profileImageName = (profileData["profile_pic"] as? String)!
                    print("First Name")
                    print(DataManger._gDataManager.profileFname)

                    NotificationCenter.default.post(name: Notification.Name(rawValue: learnerProfileNotificationKey), object: self)
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
    // 2. Post notification using "special notification key"
    @IBAction func notify() {
        
    }
    @objc func updateNotificationSentLabel() {
        print("Notification sent!")
    }
    
}

