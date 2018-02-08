
//
//  Invoice_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 1/24/18.
//  Copyright © 2018 iWeb. All rights reserved.
//




import UIKit
import NVActivityIndicatorView


class TrainerList_VC: UIViewController {
    @IBOutlet weak var view_shadow: UIView!
    var invoiceData: InvoiceModel?
    
    var learnerListArray:[Any] = []
    var trainerInfo: NSDictionary!
    
    let itemsPerRow:CGFloat = 1
    var sectionInsets =  UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
    
    @IBOutlet weak var collection_trainer: UICollectionView!
    
    @IBOutlet weak var view_navigation: UIView!
    @IBOutlet weak var tbl_home: UITableView!
    @IBOutlet weak var view_gradient: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
         self.trainerListAPI()
        Utility.navigationBarView(view: view_navigation)
        Utility.viewGradient(view: view_gradient)
        Utility.shadowInView(view: view_shadow)
        self.collection_trainer.dataSource = self
        self.collection_trainer.delegate = self

        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func btn_touch(_ sender: Any) {
       // navigationController?.popViewController(animated: true)
         self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func trainerListAPI() {
        
      //  NVActivityIndicatorView.DEFAULT_TYPE = .orbit
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        let dataDict:[String:String] = [
            "learner_id": UserData.Id,
            ]
        DataParser.trainerListAPIDetils(dataDict,Defines.TrainerListAPI, withCompletionHandler: { (array, isSuccessfull) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if(isSuccessfull)
            {
                self.learnerListArray = array as! [Any]
                self.collection_trainer.reloadData()

                print("success")
            }
            else
            {
                Utility.showAlertMessage(vc: self, titleStr: Defines.alterTitle, messageStr: Defines.loginErrorMessage)
            }
            
        })
        
        
    }
}

extension TrainerList_VC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.learnerListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrainerList_CVC", for: indexPath) as! TrainerList_CVC
        let data: TrainerListModel? = self.learnerListArray[indexPath.row] as? TrainerListModel
        cell.trainerListData = data
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //let cellDimension = self.view.frame.size.width / 2.0 - 10.0
//        let cellDimensionwidth = self.view.frame.size.width
//        let cellDimensionheight = self.view.frame.size.height + 45
//
//        return CGSize(width: cellDimensionwidth, height: cellDimensionheight)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        // let leftRightInset = self.view.frame.size.width / 14.0
//        return UIEdgeInsetsMake(0, 0, 0, 0)
//    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = (sectionInsets.left ) * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.size.width - paddingSpace
        _ = availableWidth / itemsPerRow
        let cellDimensionheight = self.view.frame.size.height + 45
        return CGSize(width: collectionView.frame.size.width  , height: cellDimensionheight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
        
    }
    
    
}





