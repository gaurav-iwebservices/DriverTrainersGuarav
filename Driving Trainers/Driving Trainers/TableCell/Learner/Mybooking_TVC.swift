//
//  Mybooking_TVC.swift
//  Driving Trainers
//
//  Created by iWeb on 1/23/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class Mybooking_TVC: UITableViewCell {
    @IBOutlet weak var lbl_package: UILabel!
    
    @IBOutlet weak var btn_view: UIButton!
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_lesson: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Utility.buttonGradient(button: btn_view)
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
