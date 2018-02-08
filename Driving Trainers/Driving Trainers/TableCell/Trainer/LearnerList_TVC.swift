//
//  LearnerList_TVC.swift
//  Driving Trainers
//
//  Created by iWeb on 09/01/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class LearnerList_TVC: UITableViewCell {

    @IBOutlet weak var onlineMarkerView: UIView!
    @IBOutlet weak var learnerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var referedNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        onlineMarkerView.layer.cornerRadius = onlineMarkerView.frame.size.height/2
        onlineMarkerView.layer.masksToBounds = true
        onlineMarkerView.layer.borderWidth = 1
        onlineMarkerView.layer.borderColor = UIColor.white.cgColor
    
        learnerImageView.layer.cornerRadius = learnerImageView.frame.size.height/2
        learnerImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
