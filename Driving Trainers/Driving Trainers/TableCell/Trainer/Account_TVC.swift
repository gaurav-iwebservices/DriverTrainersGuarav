//
//  Account_TVC.swift
//  Driving Trainers
//
//  Created by iws on 1/19/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class Account_TVC: UITableViewCell {
    
    @IBOutlet weak var showBtn: UIButton!
    @IBOutlet weak var paymentMode: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
