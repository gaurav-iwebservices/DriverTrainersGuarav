//
//  LearnerRoot_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 1/9/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit



    
  //  import Kingfisher
    
    class LearnerRoot_VC: UIViewController, UITableViewDelegate, UITableViewDataSource
    {
        
        @IBOutlet weak var tbl_side: UITableView!
        var sideMenuContentArray:[Any] = ["MY PROFILE", "DASHBOARD", "TRAINERS","PROGRESS", "INVOICE", "ABOUT US","CONTACT US","PACKAGES & LESSONS","CHANGE PASSWORD", "LOGOUT"]
        var sideMenuImageaArray:[Any] = ["profile","dashboard","trainner","progress","invoice","invoice","invoice","invoice","chenge_pws","logout"]
        // MARK: - Life cycle
        var flagClick:Int=0
       
        override func viewDidLoad()
        {
            super.viewDidLoad()
            self.navigationController?.navigationBar.isHidden = true
            NotificationCenter.default.addObserver(self, selector: #selector(LearnerRoot_VC.updateProfileNotification), name: NSNotification.Name(rawValue: learnerProfileNotificationKey), object: nil)

            
        }
        @objc func updateProfileNotification() {
            self.tbl_side.reloadData()
        }
        override func viewWillDisappear(_ animated: Bool)
        {
            self.tbl_side.reloadData()
            super.viewWillDisappear(animated)
        }
        override func viewWillAppear(_ animated: Bool)
        {
            flagClick=0
             self.tbl_side.reloadData()
            super.viewWillAppear(animated)
        }
        
        override func didReceiveMemoryWarning()
        {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        // MARK: - Table View Delegats and data source
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            
            return sideMenuContentArray.count+1
        }
        
        func numberOfSections(in tableView: UITableView) -> Int
        {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            
                if (indexPath.row == 0)
                {
                    let cell: LearnerRootProfile_TVC? = tableView.dequeueReusableCell(withIdentifier:"SideProfile", for: indexPath) as? LearnerRootProfile_TVC
                    Utility.viewGradient(view: (cell?.subView)!)
//                    cell?.img_profile.layer.borderWidth = 3.0
//                    cell?.img_profile.layer.borderColor = UIColor.white.cgColor

                    cell?.img_profile.layer.cornerRadius = (cell?.img_profile.frame.height)!/2
                    cell?.img_profile.layer.borderWidth = 3.0
                    cell?.img_profile.layer.borderColor = UIColor.white.cgColor
                    print("First name")

                    print(DataManger._gDataManager.profileFname)
                    cell?.lbl_name.text = DataManger._gDataManager.profileFname + " " + DataManger._gDataManager.profileLname
                    cell?.lbl_email.text = UserData.email
                    if DataManger._gDataManager.profileImageName != ""{
                        let completUrl:String = DataManger._gDataManager.profileImageUrl + DataManger._gDataManager.profileImageName
                        cell?.img_profile.downloadedFrom(url: URL(string: completUrl)!)
                    }
                    
                    cell?.selectionStyle = .none
                    return cell!
                }
                else
                {
                    let cell: LearnerRoot_TVC? = tableView.dequeueReusableCell(withIdentifier:"SideMenuCell", for: indexPath) as? LearnerRoot_TVC
                    cell?.selectionStyle = .none
                    cell?.lbl_side.text = sideMenuContentArray[indexPath.row-1] as? String
                   // cell?.lbl_side.text = "ankur"

                    cell?.img_side.image = UIImage(named: sideMenuImageaArray[indexPath.row-1] as! String)
                    return cell!
                }
            
            
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            
            if indexPath.row == 1 {
                
                let storyBoardid = UIStoryboard(name: "Learner", bundle: nil)
                
                let center = storyBoardid.instantiateViewController(withIdentifier: "MyProfileLearner_VC_id") as! MyProfileLearner_VC
                let nav = UINavigationController(rootViewController: center)
                self.menuContainerViewController.centerViewController = nav
                self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
            }
            
            else if indexPath.row == 2 {
                
                let storyBoardid = UIStoryboard(name: "Learner", bundle: nil)
                let center = storyBoardid.instantiateViewController(withIdentifier: "Mybooking_VC_id") as! Mybooking_VC
                DataManger._gDataManager.isFromProgress = false

                let nav = UINavigationController(rootViewController: center)
                self.menuContainerViewController.centerViewController = nav
                
                self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
                
                
            }
            
            else if indexPath.row == 3 {
                
//                let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
//
//                let center = storyBoardid.instantiateViewController(withIdentifier: "Feedback_VC_id") as! Feedback_VC
//                let nav = UINavigationController(rootViewController: center)
//                self.menuContainerViewController.centerViewController = nav
//                self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
//
                let storyBoardid = UIStoryboard(name: "Learner", bundle: nil)
                let center = storyBoardid.instantiateViewController(withIdentifier: "TrainerList_VC_id") as! TrainerList_VC
                let nav = UINavigationController(rootViewController: center)
                self.menuContainerViewController.centerViewController = nav
                
                self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
                
                
            }
            
            else if indexPath.row == 4 {
                let storyBoardid = UIStoryboard(name: "Learner", bundle: nil)
                let center = storyBoardid.instantiateViewController(withIdentifier: "Mybooking_VC_id") as! Mybooking_VC
                
                DataManger._gDataManager.isFromProgress = true

                let nav = UINavigationController(rootViewController: center)
                self.menuContainerViewController.centerViewController = nav
                
                self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
                
               
               
            }
            else if indexPath.row == 5 {
                
                let storyBoardid = UIStoryboard(name: "Learner", bundle: nil)
                let center = storyBoardid.instantiateViewController(withIdentifier: "Invoice_VC_id") as! Invoice_VC
                let nav = UINavigationController(rootViewController: center)
                self.menuContainerViewController.centerViewController = nav
                
                self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
                
                
            }
            else if indexPath.row == 6 {
                let storyBoardid = UIStoryboard(name: "Learner", bundle: nil)
                let center = storyBoardid.instantiateViewController(withIdentifier: "AboutUs_VC_id") as! AboutUs_VC
                let nav = UINavigationController(rootViewController: center)
                self.menuContainerViewController.centerViewController = nav
                
                self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)

            }
           else if indexPath.row == 7 {
                
                let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
                
                let center = storyBoardid.instantiateViewController(withIdentifier: "TrainerContactUs_VC_id") as! TrainerContactUs_VC
                let nav = UINavigationController(rootViewController: center)
                self.menuContainerViewController.centerViewController = nav
                self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)

                
            }
            else if  indexPath.row == 8 {
                
                let storyBoardid = UIStoryboard(name: "Learner", bundle: nil)
                
                let center = storyBoardid.instantiateViewController(withIdentifier: "LessonAndPackages_VC_id") as! LessonAndPackages_VC
                let nav = UINavigationController(rootViewController: center)
                self.menuContainerViewController.centerViewController = nav
                self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)

                
            }
           
           else if indexPath.row == 9 {
                
                let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
                
                let center = storyBoardid.instantiateViewController(withIdentifier: "ChangePassword_VC_id") as! ChangePassword_VC
                let nav = UINavigationController(rootViewController: center)
                self.menuContainerViewController.centerViewController = nav
                self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)

            }
            else if indexPath.row == 10 {
                
                self.logoutAction()
            }
           
            
        }
        
        func logoutAction() {
            
            UserData.firstName = ""
            UserData.lastName = ""
            UserData.email = ""
            UserData.Id = ""
            UserData.role = ""
            UserData.socialId = ""
            UserData.socialKey = ""
            UserData.userStatus = ""
            UserData.userName = ""
            
            UserDefaults.standard.setValue(UserData.firstName, forKey: "firstName")
            UserDefaults.standard.setValue(UserData.lastName, forKey: "lastName")
            UserDefaults.standard.setValue(UserData.email, forKey: "email")
            UserDefaults.standard.setValue(UserData.Id, forKey: "Id")
            UserDefaults.standard.setValue(UserData.role, forKey: "role")
            UserDefaults.standard.setValue(UserData.socialId, forKey: "socialId")
            UserDefaults.standard.setValue(UserData.socialKey, forKey: "socialKey")
            UserDefaults.standard.setValue(UserData.userStatus, forKey: "userStatus")
            UserDefaults.standard.setValue(UserData.userName, forKey: "userName")
            UserDefaults.standard.setValue("no", forKey: "login")
            
            let testController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController_id") as! ViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let nav = UINavigationController(rootViewController: testController)
            appDelegate.window?.rootViewController = nav
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            if (indexPath.section == 0)
            {
                if (indexPath.row == 0)
                {
                    return 180
                }
                else
                {
                    return 50
                }
            }
            else
            {
                return 80
            }
        }
        
        
}

