//
//  UpComingAppointment_VC.swift
//  Driving Trainers
//
//  Created by iws on 1/10/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NotificationBannerSwift
import NVActivityIndicatorView

class UpComingAppointment_VC: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    public func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "UPCOMING")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        Utility.shadowInView(view: shadowView)
        Utility.viewGradient(view: gradientView)
        tableView.separatorStyle = .none
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getAppointmentData()
    }

    
    func getAppointmentData(){
        let data:[String:String] = [
            "trainer_id" : UserData.Id
        ]
        
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.trainerAppointmentList, dataDict: data, { (json) in
            print(json)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if json["status"].stringValue == "True" {
                TrainerProfile.MADataArr = []
                TrainerProfile.MACancelledData = []
                TrainerProfile.MACompletedData = []
                
            for i in 0..<json["appoinment"].arrayValue.count {
                let lessionStatus = json["appoinment"][i]["data"][0]["lesson_status"].stringValue
                if lessionStatus == "0" || lessionStatus == "1" || lessionStatus == "2" {
                    TrainerProfile.MADataArr.append(MyAppointment.init(
                    name: json["appoinment"][i]["data"][0]["user"]["fname"].stringValue + json["appoinment"][i]["data"][0]["user"]["lname"].stringValue,
                    createdDate: json["appoinment"][i]["data"][0]["user"]["created"].stringValue,
                    LessionStatus: json["appoinment"][i]["data"][0]["lesson_status"].stringValue,
                    lessionName: json["appoinment"][i]["data"][0]["lesson_name"].stringValue,
                    student_id: json["appoinment"][i]["data"][0]["student_id"].stringValue,
                    bookingId: json["appoinment"][i]["data"][0]["booking_id"].stringValue,
                    lessionId: json["appoinment"][i]["data"][0]["lesson_id"].stringValue,
                    Id: json["appoinment"][i]["data"][0]["id"].stringValue
                ))
                }else if lessionStatus == "3" {
                    TrainerProfile.MACancelledData.append(MyAppointment.init(
                        name: json["appoinment"][i]["data"][0]["user"]["fname"].stringValue + json["appoinment"][i]["data"][0]["user"]["lname"].stringValue,
                        createdDate: json["appoinment"][i]["data"][0]["user"]["created"].stringValue,
                        LessionStatus: json["appoinment"][i]["data"][0]["lesson_status"].stringValue,
                        lessionName: json["appoinment"][i]["data"][0]["lesson_name"].stringValue,
                        student_id: json["appoinment"][i]["data"][0]["student_id"].stringValue,
                        bookingId: json["appoinment"][i]["data"][0]["booking_id"].stringValue,
                        lessionId: json["appoinment"][i]["data"][0]["lesson_id"].stringValue,
                        Id: json["appoinment"][i]["data"][0]["id"].stringValue
                    ))
                }else if lessionStatus == "4" {
                    TrainerProfile.MACompletedData.append(MyAppointment.init(
                        name: json["appoinment"][i]["data"][0]["user"]["fname"].stringValue + json["appoinment"][i]["data"][0]["user"]["lname"].stringValue,
                        createdDate: json["appoinment"][i]["data"][0]["user"]["created"].stringValue,
                        LessionStatus: json["appoinment"][i]["data"][0]["lesson_status"].stringValue,
                        lessionName: json["appoinment"][i]["data"][0]["lesson_name"].stringValue,
                        student_id: json["appoinment"][i]["data"][0]["student_id"].stringValue,
                        bookingId: json["appoinment"][i]["data"][0]["booking_id"].stringValue,
                        lessionId: json["appoinment"][i]["data"][0]["lesson_id"].stringValue,
                        Id: json["appoinment"][i]["data"][0]["id"].stringValue
                    ))
                }
            }
            
            self.tableView.reloadData()
                
            }else if json["status"].stringValue == "False"  {
                let banner = NotificationBanner(title: "Alert", subtitle: json["message"].stringValue, style: .danger)
                banner.show(queuePosition: .front)
            }
            
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(error)
        }
        
    }
    
    @objc func viewLearnerAction(sender:UIButton){
        let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
        let destVC: LearnerProfile_VC? = storyBoardid.instantiateViewController(withIdentifier: "LearnerProfile_VC_id") as? LearnerProfile_VC
        destVC?.studentId = TrainerProfile.MADataArr[sender.tag].student_id
        navigationController?.pushViewController(destVC!, animated: true)
    }
    
    @objc func viewAppointmentAction(sender:UIButton){
        let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
        let destVC: ViewAppointment_VC? = storyBoardid.instantiateViewController(withIdentifier: "ViewAppointment_VC_id") as? ViewAppointment_VC
       // destVC?.studentId = TrainerProfile.MADataArr[sender.tag].student_id
        destVC?.selectedIndex = sender.tag
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

extension UpComingAppointment_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TrainerProfile.MADataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpComing_TVC", for: indexPath) as! UpComing_TVC
        cell.dateLabel.text = TrainerProfile.MADataArr[indexPath.row].createdDate
        cell.lessionNameLabel.text = TrainerProfile.MADataArr[indexPath.row].lessionName
        cell.learnerNameLabel.text = TrainerProfile.MADataArr[indexPath.row].name
        cell.viewLearnerBtn.tag = indexPath.row
        cell.viewLearnerBtn.addTarget(self, action: #selector(self.viewLearnerAction(sender:)), for: UIControlEvents.touchUpInside)
        cell.viewAppointmentBtn.tag = indexPath.row
        cell.viewAppointmentBtn.addTarget(self, action: #selector(self.viewAppointmentAction(sender:)), for: UIControlEvents.touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
}
