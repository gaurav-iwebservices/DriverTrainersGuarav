//
//  Feedback_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 1/13/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Cosmos
import NotificationBannerSwift


class Feedback_VC: UIViewController {

    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var navigationView: UIView!
    
    var lessionId:String!
    var trainerId:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        Utility.shadowInView(view: shadowView)
        Utility.viewGradient(view: gradientView)
        Utility.navigationBarView(view: navigationView)
        Utility.buttonGradient(button: submitBtn)
        submitBtn.layer.cornerRadius = submitBtn.frame.size.height/2
        submitBtn.addTarget(self, action: #selector(self.submitFeedBackAction), for: UIControlEvents.touchUpInside)
    }

    @IBAction func menuAction(_ sender: UIButton) {
         self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
    }
    
   @objc func submitFeedBackAction(){
        let data = [
            "learner_id":UserData.Id,
            "trainer_id":self.trainerId,
            "lesson_id":self.lessionId,
            "no_of_star":String(ratingView.rating),
            "description":descriptionText.text!
        ]
        if Reachability.isConnectedToNetwork() == false {
            return
        }
    
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

    
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.addFeedBack, dataDict: data, { (json) in
            print(json)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if json["status"].stringValue == "True" {
                let banner = NotificationBanner(title: "Confirmation", subtitle: json["message"].stringValue , style: .success)
                banner.show(queuePosition: .front)
            }else if json["status"].stringValue == "False" {
                let banner = NotificationBanner(title: "Alert", subtitle: json["message"].stringValue , style: .danger)
                banner.show(queuePosition: .front)
            }
            
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(error)
        }
        
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
