//
//  CancelledAppointment_VC.swift
//  Driving Trainers
//
//  Created by iws on 1/10/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CancelledAppointment_VC: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Utility.shadowInView(view: shadowView)
        Utility.viewGradient(view: gradientView)
        tableView.separatorStyle = .none
       // tableView.register(UINib(nibName: "MyAppointment_TVC", bundle: nil), forCellReuseIdentifier: "MyAppointment_TVC")
    }
    
    public func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "CANCELLED")
    }
    
    @objc func viewLearnerAction(sender:UIButton){
        let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
        let destVC: LearnerProfile_VC? = storyBoardid.instantiateViewController(withIdentifier: "LearnerProfile_VC_id") as? LearnerProfile_VC
        destVC?.studentId = TrainerProfile.MACancelledData[sender.tag].student_id
        navigationController?.pushViewController(destVC!, animated: true)
    }
    
    @objc func btnAction(sender:UIButton) {
        
            let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
            let destVC: Schedule_VC? = storyBoardid.instantiateViewController(withIdentifier: "Schedule_VC_id") as? Schedule_VC
            destVC?.bookingId = TrainerProfile.MACancelledData[sender.tag].bookingId
                destVC?.state = "2"
            //destVC?.studentId = TrainerProfile.MADataArr[sender.tag].student_id
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

extension CancelledAppointment_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TrainerProfile.MACancelledData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpComing_TVC", for: indexPath) as! UpComing_TVC
        cell.dateLabel.text = TrainerProfile.MACancelledData[indexPath.row].createdDate
        cell.learnerNameLabel.text =  TrainerProfile.MACancelledData[indexPath.row].name
        cell.lessionNameLabel.text =  TrainerProfile.MACancelledData[indexPath.row].lessionName
        cell.viewLearnerBtn.tag = indexPath.row
        cell.viewLearnerBtn.addTarget(self, action: #selector(self.viewLearnerAction(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.viewAppointmentBtn.tag = indexPath.row
        cell.viewAppointmentBtn.setTitle("RESCHEDULE", for: UIControlState.normal)
        cell.viewAppointmentBtn.addTarget(self, action: #selector(self.btnAction(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
}

