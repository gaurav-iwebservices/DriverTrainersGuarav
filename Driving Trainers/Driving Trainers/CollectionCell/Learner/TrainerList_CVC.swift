//
//  TrainerList_CVC.swift
//  Driving Trainers
//
//  Created by iWeb on 1/25/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class TrainerList_CVC: UICollectionViewCell {
    
    @IBOutlet weak var tbl_trainerList: UITableView!
    var trainerListData:TrainerListModel?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
extension TrainerList_CVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
           let cell = tableView.dequeueReusableCell(withIdentifier: "TrainerList_1_TVC", for: indexPath) as! TrainerList_1_TVC
            cell.selectionStyle = .none
            cell.lbl_name.text = (self.trainerListData?.trainer_fname)! + " " + (self.trainerListData?.trainer_lname)!
            
            
            
            if (self.trainerListData?.trainer_profile_pic != "" && self.trainerListData?.trainer_profile_pic != nil) {
                
                let imagepath: String = DataManger._gDataManager.profileImageUrl + (self.trainerListData?.trainer_profile_pic)!
                cell.img_profile.downloadedFrom(url: URL(string: imagepath)!)
            }
            
            
            Utility.viewGradient(view: cell.view_gradient)
            return cell
        }
        else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrainerList_2_TVC", for: indexPath) as! TrainerList_2_TVC
            cell.lbl_about.text = self.trainerListData?.trainer_description

            cell.selectionStyle = .none
            return cell
            
        }
        else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrainerList_3_TVC", for: indexPath) as! TrainerList_3_TVC
            cell.lbl_email.text = self.trainerListData?.trainer_email

            cell.selectionStyle = .none
            return cell
    
        }
        else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrainerList_4_TVC", for: indexPath) as! TrainerList_4_TVC
            cell.lbl_phone.text = self.trainerListData?.trainer_mobile

            cell.selectionStyle = .none
            return cell
    
        }
        else if indexPath.row == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrainerList_5_TVC", for: indexPath) as! TrainerList_5_TVC
            cell.car_detail.text = self.trainerListData?.trainer_vehicle_type

            cell.selectionStyle = .none
            return cell
            
        }else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrainerList_6_TVC", for: indexPath) as! TrainerList_6_TVC
            cell.lbl_exp.text = self.trainerListData?.trainer_experience_year

            cell.selectionStyle = .none
            return cell
            
        }else if indexPath.row == 6{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrainerList_7_TVC", for: indexPath) as! TrainerList_7_TVC
            cell.lbl_payment.text = self.trainerListData?.trainer_pyement_mode_accepting

            cell.selectionStyle = .none
            return cell
            
        }else if indexPath.row == 7{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrainerList_8_TVC", for: indexPath) as! TrainerList_8_TVC
            cell.lbl_language.text = "English"

            cell.selectionStyle = .none
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainerList_2_TVC", for: indexPath) as! TrainerList_2_TVC
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0{
            return 230.0;
        }
        else if indexPath.row == 1{
            return 100.0;
            
        }
        return 80.0;//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }




}

