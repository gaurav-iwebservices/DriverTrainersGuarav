//
//  LearnerRoot_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 1/9/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit




//  import Kingfisher

class TrainerRoot_VC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    var sideMenuContentArray:[Any] = ["MY PROFILE", "DASHBOARD", "LEARNER LIST","APPOINTMENTS","APPOINTMENT REQUESTS", "ADD NEW LEARNER", "CHANGE PASSWORD","ABOUT US","ACCOUNT","CONTACT US", "LOGOUT"]
    var sideMenuImageaArray:[Any] = ["profile","dashboard","learner","appointment","appointment","account","chenge_pws","account","account","account","logout"]
    // MARK: - Life cycle
    var flagClick:Int=0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.tableView.estimatedRowHeight = 250
        self.tableView.rowHeight = UITableViewAutomaticDimension
        NotificationCenter.default.addObserver(self,selector: #selector(self.reloadTable)  ,name: NSNotification.Name(rawValue: "TrainerProfile"),object: nil)
    }
    
   @objc func reloadTable() {
        self.tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        flagClick=0
        
        super.viewWillAppear(animated)
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
            cell?.img_profile.layer.cornerRadius = (cell?.img_profile.frame.height)!/2
            cell?.img_profile.layer.borderWidth = 3.0
            cell?.img_profile.layer.borderColor = UIColor.white.cgColor
            cell?.lbl_name.text = UserData.firstName + " " + UserData.lastName
            cell?.lbl_email.text = UserData.email
            if UserData.imgPath != "" && UserData.imgPath != nil {
                cell?.img_profile.downloadedFrom(url: URL(string: UserData.imgPath)!)
            }
            
            cell?.selectionStyle = .none
            return cell!
        }
        else
        {
            let cell: LearnerRoot_TVC? = tableView.dequeueReusableCell(withIdentifier:"SideMenuCell", for: indexPath) as? LearnerRoot_TVC
            cell?.selectionStyle = .none
            cell?.lbl_side.text = sideMenuContentArray[indexPath.row-1] as? String
            cell?.img_side.image = UIImage(named: sideMenuImageaArray[indexPath.row-1] as! String)
            return cell!
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 1 {
            let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
            let center = storyBoardid.instantiateViewController(withIdentifier: "MyProfile_VC_id") as! MyProfile_VC
            let nav = UINavigationController(rootViewController: center)
            self.menuContainerViewController.centerViewController = nav
            
        }else if  indexPath.row == 2 {
            let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
            let center = storyBoardid.instantiateViewController(withIdentifier: "Dashboard_VC_id") as! Dashboard_VC
            let nav = UINavigationController(rootViewController: center)
            self.menuContainerViewController.centerViewController = nav
            
        } else if indexPath.row == 3 {
            let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
            let center = storyBoardid.instantiateViewController(withIdentifier: "LearnerList_VC_id") as! LearnerList_VC
            let nav = UINavigationController(rootViewController: center)
            self.menuContainerViewController.centerViewController = nav
            
        }else if indexPath.row == 4 {
            let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
            let center = storyBoardid.instantiateViewController(withIdentifier: "MyAppointment_VC_id") as! MyAppointment_VC
            let nav = UINavigationController(rootViewController: center)
            self.menuContainerViewController.centerViewController = nav
            
        }else if indexPath.row == 5 {
            let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
            let center = storyBoardid.instantiateViewController(withIdentifier: "RequestAppointment_VC_id") as! RequestAppointment_VC
            let nav = UINavigationController(rootViewController: center)
            self.menuContainerViewController.centerViewController = nav
            
        }else if indexPath.row == 6 {
            let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
            let center = storyBoardid.instantiateViewController(withIdentifier: "AddNewLearner_VC_id") as! AddNewLearner_VC
            let nav = UINavigationController(rootViewController: center)
            self.menuContainerViewController.centerViewController = nav
            
        }else if indexPath.row == 7 {
            let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
            let center = storyBoardid.instantiateViewController(withIdentifier: "ChangePassword_VC_id") as! ChangePassword_VC
            let nav = UINavigationController(rootViewController: center)
            self.menuContainerViewController.centerViewController = nav
            
        }else if indexPath.row == 8 {
            let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
            let center = storyBoardid.instantiateViewController(withIdentifier: "TrainerAboutUs_VC_id") as! TrainerAboutUs_VC
            let nav = UINavigationController(rootViewController: center)
            self.menuContainerViewController.centerViewController = nav
            
        }else if indexPath.row == 9 {
            let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
            let center = storyBoardid.instantiateViewController(withIdentifier: "Account_VC_id") as! Account_VC
            let nav = UINavigationController(rootViewController: center)
            self.menuContainerViewController.centerViewController = nav
            
        }else if indexPath.row == 10 {
            let storyBoardid = UIStoryboard(name: "Trainer", bundle: nil)
            let center = storyBoardid.instantiateViewController(withIdentifier: "TrainerContactUs_VC_id") as! TrainerContactUs_VC
            let nav = UINavigationController(rootViewController: center)
            self.menuContainerViewController.centerViewController = nav
            
        }else if indexPath.row == 11 {
            
            let title = "Are you sure you want to logout?"
            
            let refreshAlert = UIAlertController(title: "Alert", message: title, preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    self.logoutAction()
                }))
                refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                    
                }))
                
                present(refreshAlert, animated: true, completion: nil)
                
            
        
        }
        
     self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
       
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       /* if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 180
            }
            else{
                return 40
                
            }
        } else{
            return 80
        }
    }*/
        
        return UITableViewAutomaticDimension
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
        UserData.imgPath = ""
        
        UserDefaults.standard.setValue(UserData.firstName, forKey: "firstName")
        UserDefaults.standard.setValue(UserData.lastName, forKey: "lastName")
        UserDefaults.standard.setValue(UserData.email, forKey: "email")
        UserDefaults.standard.setValue(UserData.Id, forKey: "Id")
        UserDefaults.standard.setValue(UserData.role, forKey: "role")
        UserDefaults.standard.setValue(UserData.socialId, forKey: "socialId")
        UserDefaults.standard.setValue(UserData.socialKey, forKey: "socialKey")
        UserDefaults.standard.setValue(UserData.userStatus, forKey: "userStatus")
        UserDefaults.standard.setValue(UserData.userName, forKey: "userName")
        UserDefaults.standard.setValue(UserData.imgPath, forKey: "ImgPath")
        UserDefaults.standard.setValue("no", forKey: "login")
        
        let testController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController_id") as! ViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let nav = UINavigationController(rootViewController: testController)
        appDelegate.window?.rootViewController = nav
    }
    
    
}


