//
//  ViewAppointment_VC.swift
//  Driving Trainers
//
//  Created by iws on 1/10/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class ViewAppointment_VC: UIViewController {


    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    var selectedIndex:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.viewGradient(view: gradientView)
        Utility.shadowInView(view: shadowView)
        Utility.navigationBarView(view: navigationView)
        tableView.separatorStyle = .none
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   

   @objc func btnAction(sender:UIButton) {
    
        if sender.tag == 1 {
            let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
            let destVC: Schedule_VC? = storyBoardid.instantiateViewController(withIdentifier: "Schedule_VC_id") as? Schedule_VC
            destVC?.bookingId = TrainerProfile.MADataArr[selectedIndex].bookingId
            if TrainerProfile.MADataArr[selectedIndex].LessionStatus == "0" {
                destVC?.state = "1"
            }else {
                destVC?.state = "2"
            }
            //destVC?.studentId = TrainerProfile.MADataArr[sender.tag].student_id
            navigationController?.pushViewController(destVC!, animated: true)
        }else if sender.tag == 2 {
            let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
            let destVC: AppointmentProgress_VC? = storyBoardid.instantiateViewController(withIdentifier: "AppointmentProgress_VC_id") as? AppointmentProgress_VC
            destVC?.lessionId = TrainerProfile.MADataArr[selectedIndex].Id
            destVC?.learnerId =  TrainerProfile.MADataArr[selectedIndex].student_id
            destVC?.index = selectedIndex
           // destVC?.bookingId = TrainerProfile.MADataArr[selectedIndex].bookingId
           // destVC?.state = "3"
            //  destVC?.studentId = TrainerProfile.MADataArr[sender.tag].student_id
            navigationController?.pushViewController(destVC!, animated: true)

        }else if sender.tag == 3 {
            let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
            let destVC: Schedule_VC? = storyBoardid.instantiateViewController(withIdentifier: "Schedule_VC_id") as? Schedule_VC
            destVC?.bookingId = TrainerProfile.MADataArr[selectedIndex].bookingId
            destVC?.state = "3"
          //  destVC?.studentId = TrainerProfile.MADataArr[sender.tag].student_id
            navigationController?.pushViewController(destVC!, animated: true)
            
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

extension ViewAppointment_VC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewAppointment_TVC", for: indexPath) as! ViewAppointment_TVC
      //  cell.popUpButton.addTarget(self, action: #selector(self.popUpButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        cell.dateLabel.text = TrainerProfile.MADataArr[selectedIndex].createdDate
        cell.lessionTypeLabel.text = TrainerProfile.MADataArr[selectedIndex].lessionName
        cell.nameLabel.text = TrainerProfile.MADataArr[selectedIndex].name
        if TrainerProfile.MADataArr[selectedIndex].LessionStatus == "0" {
            cell.rescheduleBtn.setTitle("SCHEDULE", for: UIControlState.normal)
        }
        
        cell.rescheduleBtn.tag = 1
        cell.progressButton.tag = 2
        cell.cancelBtn.tag = 3
        
        cell.rescheduleBtn.addTarget(self, action: #selector(self.btnAction(sender:)), for: UIControlEvents.touchUpInside)
        cell.progressButton.addTarget(self, action: #selector(self.btnAction(sender:)), for: UIControlEvents.touchUpInside)
        cell.cancelBtn.addTarget(self, action: #selector(self.btnAction(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
