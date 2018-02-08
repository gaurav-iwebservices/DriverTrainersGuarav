//
//  Invoice_TVC.swift
//  Driving Trainers
//
//  Created by iWeb on 1/24/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class Invoice_TVC: UITableViewCell {
    @IBOutlet weak var btn_download: UIButton!
    
    @IBOutlet weak var lbl_package: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var img_trainer: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
