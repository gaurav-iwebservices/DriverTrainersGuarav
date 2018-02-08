//
//  PopUpViewController.swift
//  Driving Trainers
//
//  Created by iws on 1/10/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

protocol PopUpViewControllerDelegate {
    func saveString( _ strText : String)
    func idString( _ strText : String)
   func getTagOfTable( _ tblTag : Int, _ indexValue : String)

}


class PopUpViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var arr = ["Reschedule","Progress","Cancelled"]
    var delegate : PopUpViewControllerDelegate?
    
    //var tagValue: Int? =
    var tagValue: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.tag = self.tagValue
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

extension PopUpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = arr[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if((self.delegate) != nil)
        {
            delegate?.saveString(arr[indexPath.row]);
            delegate?.idString(String(indexPath.row))
            delegate?.getTagOfTable(tableView.tag,String(indexPath.row))
            self.dismiss(animated: true, completion: nil)
        }
    }
}
