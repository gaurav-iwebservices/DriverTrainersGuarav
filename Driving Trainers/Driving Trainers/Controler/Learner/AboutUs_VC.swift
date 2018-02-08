//
//  AboutUs_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 1/13/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class AboutUs_VC: UIViewController {
    @IBOutlet weak var textView_Detail: UITextView!
    
    @IBOutlet weak var view_gradient: UIView!
    @IBOutlet weak var view_shadow: UIView!
    @IBOutlet weak var view_navigation: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.viewGradient(view: view_gradient)
        Utility.shadowInView(view: view_shadow)
        Utility.navigationBarView(view: view_navigation)
        self.navigationController?.navigationBar.isHidden = true

        self.getDataFromServer()

        // Do any additional setup after loading the view.
    }
    func getDataFromServer()  {
       // NVActivityIndicatorView.DEFAULT_TYPE = .orbit
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        DataProvider.sharedInstance.getDataUsingGet(path: Defines.ServerUrl + Defines.aboutUsAPI, { (json) in
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

            print(json)
            let dataArray = json["data"].array!
            for items in dataArray
            {
                self.textView_Detail.text = items["description"].string
            }
            
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

            print(error)
            
        }
    }
    @IBAction func btn_touch(_ sender: Any) {
        // navigationController?.popViewController(animated: true)
        self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
        
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
