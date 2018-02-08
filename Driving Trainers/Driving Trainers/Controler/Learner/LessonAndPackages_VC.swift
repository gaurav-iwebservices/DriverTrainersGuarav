

import UIKit
import NVActivityIndicatorView


class LessonAndPackages_VC: UIViewController {
    @IBOutlet weak var view_shadow: UIView!
    
    @IBOutlet weak var btn_proceed: UIButton!
    @IBOutlet weak var view_navigation: UIView!
    @IBOutlet weak var tbl_home: UITableView!
    @IBOutlet weak var view_gradient: UIView!

    var selectedIndex:IndexPath?
    var packagListArray:[Any] = []
    var packageListArray:[Any] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getlessionPackeageAPI()
        
        self.tbl_home.separatorStyle = .none

        self.navigationController?.navigationBar.isHidden = true
        
        Utility.navigationBarView(view: view_navigation)
        Utility.viewGradient(view: view_gradient)
        Utility.shadowInView(view: view_shadow)
        Utility.buttonGradient(button: btn_proceed)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_appointment(_ sender: Any) {
        let storyBoardid = UIStoryboard(name: "Learner", bundle: nil)
        let destVC: MakeAppointment_VC? = storyBoardid.instantiateViewController(withIdentifier: "MakeAppointment_VC_id") as? MakeAppointment_VC
        navigationController?.pushViewController(destVC!, animated: true)
        
    }
    @IBAction func btn_proceed_touch(_ sender: Any) {
        
        print(selectedIndex?.section ?? 0)
        print(selectedIndex?.row ?? 0)
        
        if ((selectedIndex?.section) != nil){
            DataManger._gDataManager.isFromLessonPackage = true            
            let storyBoardid = UIStoryboard(name: "Learner", bundle: nil)
            let destVC: MakeAppointment_VC? = storyBoardid.instantiateViewController(withIdentifier: "MakeAppointment_VC_id") as? MakeAppointment_VC
            destVC?.packagListArray = self.packagListArray
            destVC?.packageListArray = self.packageListArray
            destVC?.packageIndexID = selectedIndex?.section
            destVC?.lessionIndexID = selectedIndex?.row
            navigationController?.pushViewController(destVC!, animated: true)
        }
        else{
            Utility.showAlertMessage(vc: self, titleStr: Defines.alterTitle, messageStr: "Please select one package")
        }
       
        
       
    }
    @IBAction func btn_touch(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getlessionPackeageAPI() {
        
        let loginDictionary = [String: Any]()
       // NVActivityIndicatorView.DEFAULT_TYPE = .orbit
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataParser.packagesLessonsAPIDetils(loginDictionary,Defines.stateAPI, withCompletionHandler: { (array,array2, isSuccessfull) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if(isSuccessfull)
            {
                self.packagListArray = array as! [Any]
                self.packageListArray = array2 as! [Any]
                self.tbl_home.reloadData()
                print("success")
            }
            else
            {
                Utility.showAlertMessage(vc: self, titleStr: Defines.alterTitle, messageStr: Defines.loginErrorMessage)
            }
            
        })
    }
}

extension LessonAndPackages_VC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return packagListArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let data: LessonPackeageModel? = (self.packagListArray[section] as? LessonPackeageModel)
        let itemArr: [Any]? = data?.lessons_details
        return itemArr!.count
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       let data: LessonPackeageModel? = (self.packagListArray[section] as? LessonPackeageModel)
        return data?.package_name
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LessonPackages_TVC", for: indexPath) as! LessonPackages_TVC
        
        
        let data: LessonPackeageModel? = (self.packagListArray[indexPath.section] as? LessonPackeageModel)
        let itemArr: [Any]? = data?.lessons_details
        
        let locDic = itemArr![indexPath.row] as! NSDictionary
        let lession_name = locDic["lesson_name"] as? String ?? ""
        let price = locDic["amount"] as? Int ?? 0
        cell.lbl_leeson.text = "$ " + lession_name
        cell.lbl_price.text = String(price)
        cell.btn_check.tag = indexPath.row
      
        if (selectedIndex == indexPath) {
            
            cell.btn_check.setImage(UIImage(named: "radioSelected"), for: .normal)

            
        } else {
            cell.btn_check.setImage(UIImage(named: "radio"), for: .normal)

            
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        _ = indexPath.row
        selectedIndex = indexPath
        tableView.reloadData()
    }
    
  
    
    
}


