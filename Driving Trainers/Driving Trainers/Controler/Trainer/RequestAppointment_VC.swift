//
//  RequestAppointment_VC.swift
//  Driving Trainers
//
//  Created by iws on 1/16/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import NotificationBannerSwift

class RequestAppointment_VC: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.shadowInView(view: backgroundView)
        Utility.viewGradient(view: gradientView)
        Utility.navigationBarView(view: navigationView)
        self.getRequestAppointment()
        self.tableView.separatorStyle = .none
        self.navigationController?.navigationBar.isHidden = true
       
    }

    @IBAction func menuAction(_ sender: UIButton) {
         self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
    }
    
    
    func getRequestAppointment() {
        let data:[String:String] = ["trainer_id" : UserData.Id]
        
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
 
        
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.appointmentRequest, dataDict: data, { (json) in
            print(json)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if json["status"].stringValue == "True" {
                TrainerProfile.ARDataArr = []
                for i in 0..<json["appoinmentrequest"].arrayValue.count {
                    TrainerProfile.ARDataArr.append(AppointmentRequest.init(
                        name: json["appoinmentrequest"][i]["student_name"].stringValue,
                        date: json["appoinmentrequest"][i]["booking_date"].stringValue,
                        status: json["appoinmentrequest"][i]["status"].stringValue,
                        address: json["appoinmentrequest"][i]["address"].stringValue,
                        student_id: json["appoinmentrequest"][i]["student_id"].stringValue,
                        lession: json["appoinmentrequest"][i]["lessionname"].stringValue,
                        instructorId: json["appoinmentrequest"][i]["instructor_id"].stringValue,
                        bookingId: json["appoinmentrequest"][i]["booking_id"].stringValue
                    ))
                }
                self.tableView.reloadData()
            }else if json["status"].stringValue == "False"  {
                let banner = NotificationBanner(title: "Alert", subtitle: json["message"].stringValue, style: .danger)
                banner.show(queuePosition: .front)
            }
            
            
        }) { (error) in
            print(error)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
        
    }
    
    @objc func appointmentRequestAcceptAction(sender:UIButton){
        
        if sender.titleLabel?.text == "ACCEPTED" || sender.titleLabel?.text == "SOMEONE" {
            return
        }
        
        let data:[String:String] = [
            "trainer_id" : UserData.Id,
            "booking_id" : TrainerProfile.ARDataArr[sender.tag].bookingId,
            "status" : "1"                  // [1=Accept,2=Decline]
        ]
        
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.ApptRequestAccept, dataDict: data, { (json) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(json)
        if json["status"].stringValue == "True"  {
            let banner = NotificationBanner(title: "Alert", subtitle: json["message"].stringValue, style: .success)
            banner.show(queuePosition: .front)
            self.getRequestAppointment()
        }else if json["status"].stringValue == "False"  {
            let banner = NotificationBanner(title: "Alert", subtitle: json["message"].stringValue, style: .danger)
            banner.show(queuePosition: .front)
        }
            
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(error)
        }
        
    }
    
    @objc func appointmentRequestDeclineAction(sender:UIButton){
        let data:[String:String] = [
            "trainer_id" : UserData.Id,
            "booking_id" : TrainerProfile.ARDataArr[sender.tag].bookingId,
            "status" : "2"                  // [1=Accept,2=Decline]
        ]
        
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.ApptRequestAccept, dataDict: data, { (json) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(json)
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

extension RequestAppointment_VC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TrainerProfile.ARDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentRequest_TVC", for: indexPath) as! AppointmentRequest_TVC
        cell.nameLabel.text = TrainerProfile.ARDataArr[indexPath.row].name
        cell.dateLabel.text =  TrainerProfile.ARDataArr[indexPath.row].date
        cell.lessionNameLabel.text =  TrainerProfile.ARDataArr[indexPath.row].lession
        
        if TrainerProfile.ARDataArr[indexPath.row].instructorId == UserData.Id && TrainerProfile.ARDataArr[indexPath.row].status == "1" {
            cell.acceptBtn.setTitle("ACCEPTED", for: UIControlState.normal)
        } else if TrainerProfile.ARDataArr[indexPath.row].instructorId != UserData.Id && TrainerProfile.ARDataArr[indexPath.row].status == "1" {
            cell.acceptBtn.setTitle("SOMEONE", for: UIControlState.normal)
        }
        
        cell.acceptBtn.tag = indexPath.row
        cell.acceptBtn.addTarget(self, action: #selector(self.appointmentRequestAcceptAction(sender:)), for: UIControlEvents.touchUpInside)
        if TrainerProfile.ARDataArr[indexPath.row].instructorId == UserData.Id && TrainerProfile.ARDataArr[indexPath.row].status == "0" {
            cell.declineBtn.tag = indexPath.row
            cell.declineBtn.addTarget(self, action: #selector(self.appointmentRequestDeclineAction(sender:)), for: UIControlEvents.touchUpInside)
        }else{
            cell.declineBtn.isHidden = true
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
}
