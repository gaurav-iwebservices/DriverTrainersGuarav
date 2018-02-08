//
//  ViewAppointment_TVC.swift
//  Driving Trainers
//
//  Created by iws on 1/10/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class ViewAppointment_TVC: UITableViewCell {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var rescheduleBtn: UIButton!
    @IBOutlet weak var progressButton: UIButton!
    @IBOutlet weak var lessionTypeLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var popUpButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        Utility.shadowInView(view: popUpView)
    }
    @IBAction func btnAction(_ sender: UIButton) {
        if popUpView.isHidden == true {
            popUpView.isHidden = false
        }else{
            popUpView.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
