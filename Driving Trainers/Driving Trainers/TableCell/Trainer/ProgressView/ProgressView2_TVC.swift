//
//  ProgressView2_TVC.swift
//  Driving Trainers
//
//  Created by iws on 1/25/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class ProgressView2_TVC: UITableViewCell {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
       submitBtn.layer.cornerRadius = submitBtn.frame.size.height/2
        Utility.buttonGradient(button: submitBtn)
        
    }

    
    /*override func layoutSubviews() {
        super.layoutSubviews()
        Utility.buttonGradient(button: submitBtn)
    }*/
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
