//
//  Dashboard_CVC.swift
//  Driving Trainers
//
//  Created by iws on 1/10/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class Dashboard_CVC: UICollectionViewCell {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Utility.shadowInView(view: shadowView)
    }
}
