//
//  UpComing_TVC.swift
//  Driving Trainers
//
//  Created by iws on 1/10/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class UpComing_TVC: UITableViewCell {

    @IBOutlet weak var learnerNameLabel: UILabel!
    @IBOutlet weak var lessionNameLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewAppointmentBtn: UIButton!
    @IBOutlet weak var viewLearnerBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewAppointmentBtn.layer.cornerRadius = viewAppointmentBtn.frame.size.height/2
        viewLearnerBtn.layer.cornerRadius = viewLearnerBtn.frame.size.height/2
        Utility.buttonGradient(button: viewLearnerBtn)
        Utility.buttonGradient(button: viewAppointmentBtn)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
