//
//  AppointmentRequest_TVC.swift
//  Driving Trainers
//
//  Created by iws on 1/16/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class AppointmentRequest_TVC: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lessionNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var declineBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        Utility.buttonGradient(button: acceptBtn)
        acceptBtn.layer.cornerRadius = acceptBtn.frame.size.height/2
        Utility.buttonGradient(button: declineBtn)
        declineBtn.layer.cornerRadius = declineBtn.frame.size.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
