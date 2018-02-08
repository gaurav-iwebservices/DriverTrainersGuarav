//
//  MultipleSelectorPopUp_VC.swift
//  Driving Trainers
//
//  Created by iws on 2/2/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class MultipleSelectorPopUp_VC: UIViewController {

    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var arr = ["Reschedule","Progress","Cancelled"]
    var delegate : PopUpViewControllerDelegate?
    var selectedArr:[Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        doneBtn.layer.cornerRadius = doneBtn.frame.size.height/2
        Utility.buttonGradient(button: doneBtn)
        
    }
    @IBAction func doneBtnAction(_ sender: UIButton) {
        
        if selectedArr.count == 0 {
            let banner = NotificationBanner(title: "Alert", subtitle: "Please select suburb.", style: .danger)
            banner.show(queuePosition: .front)
            return
        }
        
        var selectedIndex = ""
        var selectedSuburb:String = ""
        for i in 0..<selectedArr.count {
            if i == 0 {
                selectedSuburb = arr[selectedArr[i]]
                selectedIndex = String(selectedArr[i])
            }else{
                selectedSuburb = selectedSuburb + "," + arr[selectedArr[i]]
                selectedIndex = selectedIndex + "," + String(selectedArr[i])
            }
        }
        
        if((self.delegate) != nil)
        {
            delegate?.saveString(selectedSuburb)
            delegate?.idString(selectedIndex)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
   @objc func selectBtnAction(sender:UIButton) {
    
        if selectedArr.contains(sender.tag){
            let index = selectedArr.index(of: sender.tag)
            selectedArr.remove(at: index!)
            sender.setImage(#imageLiteral(resourceName: "untick"), for: UIControlState.normal)
        }else{
            selectedArr.append(sender.tag)
            sender.setImage(#imageLiteral(resourceName: "tick"), for: UIControlState.normal)
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

extension MultipleSelectorPopUp_VC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleSelectorPopUp_TVC", for: indexPath) as! MultipleSelectorPopUp_TVC
        cell.suburbLabel.text = arr[indexPath.row]
        cell.selectBtn.tag = indexPath.row
        
        if selectedArr.contains(indexPath.row) {
            cell.selectBtn.setImage(#imageLiteral(resourceName: "tick"), for: UIControlState.normal)
        }else{
            cell.selectBtn.setImage(#imageLiteral(resourceName: "untick"), for: UIControlState.normal)
        }
        
        cell.selectBtn.addTarget(self, action: #selector(self.selectBtnAction(sender:)), for: UIControlEvents.touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
}
