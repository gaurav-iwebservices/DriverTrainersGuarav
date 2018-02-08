//
//  Dashboard_VC.swift
//  Driving Trainers
//
//  Created by iws on 1/10/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class Dashboard_VC: UIViewController {

    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var headerTitleArr = ["TOTAL EARNING","TOTAL EARNING","TOTAL EARNING","TOTAL DUES"]
    var titleArr = ["FROM SCHOOL","FROM REFERRALS","AS COMMISION",""]
    var moneyArr = ["0","0","0","0"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImage.layer.cornerRadius = 5
        logoImage.layer.masksToBounds = true
        Utility.viewGradient(view: gradientView)
       // Utility.viewGradient(view: statusBar)
       // Utility.viewGradient(view: navigationBar)
        Utility.navigationBarView(view: navigationBar)
        self.navigationController?.navigationBar.isHidden = true
        self.getData()
        
    }
    @IBAction func menuAction(_ sender: UIButton) {
         self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
    }
    
    func getData() {
        let data:[String:Any] = [
            "trainer_id":UserData.Id
        ]
        
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
 
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.dashboardTrainerAPI, dataDict: data, { (Json) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if Json["status"].stringValue == "True" {
                if Json["earnfromschool"][0]["amount"].stringValue != "" {
                    self.moneyArr[0] = Json["earnfromschool"][0]["amount"].stringValue
                }
                
                if Json["earnfromreferal"][0]["amount"].stringValue != "" {
                    self.moneyArr[1] = Json["earnfromreferal"][0]["amount"].stringValue
                }
                
                if Json["totalcommission"][0]["amount"].stringValue != "" {
                    self.moneyArr[2] = Json["totalcommission"][0]["amount"].stringValue
                }
                
                if Json["totaldues"][0]["amount"].stringValue != "" {
                    self.moneyArr[3] = Json["totaldues"][0]["amount"].stringValue
                }
                
                self.collectionView.reloadData()
            }
            
            print(Json)
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

extension Dashboard_VC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Dashboard_CVC", for: indexPath) as! Dashboard_CVC
        cell.headerLabel.text = headerTitleArr[indexPath.row]
        cell.titleLabel.text = titleArr[indexPath.row]
        cell.moneyLabel.text = "$" + moneyArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellDimension = self.view.frame.size.width / 2.0 - 10.0
        return CGSize(width: cellDimension, height: cellDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       // let leftRightInset = self.view.frame.size.width / 14.0
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
}


