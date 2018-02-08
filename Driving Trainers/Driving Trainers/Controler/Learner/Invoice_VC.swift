//
//  Invoice_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 1/24/18.
//  Copyright © 2018 iWeb. All rights reserved.
//



 
    import UIKit
    import NVActivityIndicatorView
    
    
    class Invoice_VC: UIViewController {
        @IBOutlet weak var view_shadow: UIView!
        var invoiceData: InvoiceModel?
        
        var invoiceListArray:[Any] = []
        var trainerInfo: NSDictionary!
        
        
        
        @IBOutlet weak var view_navigation: UIView!
        @IBOutlet weak var tbl_home: UITableView!
        @IBOutlet weak var view_gradient: UIView!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.myInvoicAPI()
            self.navigationController?.navigationBar.isHidden = true
            
            Utility.navigationBarView(view: view_navigation)
            Utility.viewGradient(view: view_gradient)
            Utility.shadowInView(view: view_shadow)
            
            // Do any additional setup after loading the view.
        }
        
//        @IBAction func btn_appointment(_ sender: Any) {
//            let storyBoardid = UIStoryboard(name: "Learner", bundle: nil)
//            let destVC: MakeAppointment_VC? = storyBoardid.instantiateViewController(withIdentifier: "MakeAppointment_VC_id") as? MakeAppointment_VC
//            navigationController?.pushViewController(destVC!, animated: true)
//
//        }
        @IBAction func btn_touch(_ sender: Any) {
           // navigationController?.popViewController(animated: true)
             self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
    }
    
    extension Invoice_VC: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return invoiceListArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Invoice_TVC", for: indexPath) as! Invoice_TVC
            
            let data: InvoiceModel? = self.invoiceListArray[indexPath.row] as? InvoiceModel

            let firstname = data?.trainer_fname
            let lastname = data?.trainer_lname

            if (data?.trainer_profile_pic != "" && data?.trainer_profile_pic != nil) {
                
                let imagepath: String = DataManger._gDataManager.profileImageUrl + (data?.trainer_profile_pic)!
                cell.img_trainer.downloadedFrom(url: URL(string: imagepath)!)
            }
            
            
            cell.lbl_name.text = (firstname)! + " " + (lastname)!
            cell.lbl_date.text = (data?.schedule_date)! + ", " + (data?.schedule_time)!
            cell.lbl_package.text = (data?.duration)! + ", $" + (data?.lesson_amt)!

            cell.btn_download.tag = indexPath.row
            cell.btn_download.addTarget(self, action: #selector(self.downloadAction), for: .touchUpInside)

            
            cell.selectionStyle = .none
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //        let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
            //        let destVC: LearnerProfile_VC? = storyBoardid.instantiateViewController(withIdentifier: "LearnerProfile_VC_id") as? LearnerProfile_VC
            //        destVC?.studentId = TrainerProfile.dataArr[indexPath.row].studentId
            //        navigationController?.pushViewController(destVC!, animated: true)
        }
        
        func myInvoicAPI() {
            
           // NVActivityIndicatorView.DEFAULT_TYPE = .orbit
            let activityData = ActivityData()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
            let dataDict:[String:String] = [
                "learner_id": UserData.Id,
                ]
            DataParser.invoiceListAPIDetils(dataDict,Defines.myInvoiceListAPI, withCompletionHandler: { (array, isSuccessfull) in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                if(isSuccessfull)
                {
                    self.invoiceListArray = array as! [Any]
                    self.tbl_home.reloadData()
                    
                    print("success")
                }
                else
                {
                    Utility.showAlertMessage(vc: self, titleStr: Defines.alterTitle, messageStr: Defines.loginErrorMessage)
                }
                
            })
            
            
        }
        
        @objc func downloadAction(_ sender: Any) {
            print("ankur")
            let buttonRow: Int = (sender as AnyObject).tag
//            let data: LearnerMybookModel? = (self.mybookingListArray[buttonRow] as? LearnerMybookModel)
//            let storyBoardid = UIStoryboard(name: "Learner", bundle: nil)
//            let destVC: LearnerHome_VC? = storyBoardid.instantiateViewController(withIdentifier: "LearnerHome_VC_id") as? LearnerHome_VC
//            destVC?.selectedMybookData = data
//            navigationController?.pushViewController(destVC!, animated: true)
            
            
            let data: InvoiceModel? = (self.invoiceListArray[buttonRow] as? InvoiceModel)
            let storyBoardid = UIStoryboard(name: "Learner", bundle: nil)
            let destVC: LearnerInvoicePDF1_VC? = storyBoardid.instantiateViewController(withIdentifier: "LearnerInvoicePDF1_VC_id") as? LearnerInvoicePDF1_VC
            destVC?.invoiceData = data
            navigationController?.pushViewController(destVC!, animated: true)
            
            
        }
        

        
        
    }
    


