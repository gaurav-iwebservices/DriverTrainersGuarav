//
//  ProgressView_TVC.swift
//  Driving Trainers
//
//  Created by iws on 1/25/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import Charts

class ProgressView_TVC: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pieView: PieChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
