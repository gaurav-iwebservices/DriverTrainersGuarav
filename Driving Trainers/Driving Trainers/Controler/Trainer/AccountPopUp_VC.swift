//
//  AccountPopUp_VC.swift
//  Driving Trainers
//
//  Created by iws on 1/22/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class AccountPopUp_VC: UIViewController {

    var referredBy:String!
    var commision:String!
    @IBOutlet weak var commisionAmount: UILabel!
    @IBOutlet weak var referredByLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

       referredByLabel.text = referredBy
        commisionAmount.text = "$" + commision
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
