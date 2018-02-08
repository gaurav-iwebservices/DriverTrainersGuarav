//
//  LearnerDash_TVC.swift
//  
//
//  Created by iWeb on 1/19/18.
//

import UIKit

class LearnerDash_TVC: UITableViewCell {
    @IBOutlet weak var btn_1: UIButton!
    @IBOutlet weak var view_sub: UIView!
    
    @IBOutlet weak var lbl_3: UILabel!
    @IBOutlet weak var lbl_1: UILabel!
    @IBOutlet weak var lbl_2: UILabel!
    @IBOutlet weak var img_home: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       // Utility.shadowInView(view: view_sub)

        // Initialization code
    }
    @IBAction func btn_touch(_ sender: Any) {
//        if view_sub.isHidden == true {
//            view_sub.isHidden = false
//        }else{
//            view_sub.isHidden = true
//        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


