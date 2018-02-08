//
//  LearnerRootProfile_TVC.swift
//  Driving Trainers
//
//  Created by iWeb on 1/9/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class LearnerRootProfile_TVC: UITableViewCell {

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
