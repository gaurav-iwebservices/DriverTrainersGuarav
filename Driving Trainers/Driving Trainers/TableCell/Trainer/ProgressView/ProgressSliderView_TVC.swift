//
//  ProgressSliderView_TVC.swift
//  Driving Trainers
//
//  Created by iws on 1/25/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class ProgressSliderView_TVC: UITableViewCell {

    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var progressSlider: JMMarkSlider!
    override func awakeFromNib() {
        super.awakeFromNib()
        progressSlider.minimumValue = 1
        progressSlider.maximumValue = 100
        progressSlider.addTarget(self, action: #selector(self.sliderValueDidChange(sender:)),for: .
            valueChanged)
        
    }
    
    @objc func sliderValueDidChange(sender: UISlider) {
      valueLabel.text = String(Int(sender.value)) + "%"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
