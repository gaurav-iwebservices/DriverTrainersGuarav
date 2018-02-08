//
//  LearnerInvoicePDF1_VC.swift
//  Driving Trainers
//
//  Created by iWeb on 2/1/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class LearnerInvoicePDF1_VC: UIViewController {
    @IBOutlet weak var web_view: UIWebView!
    @IBOutlet weak var view_gradient: UIView!
    @IBOutlet weak var view_shadow: UIView!
    @IBOutlet weak var view_navigation: UIView!
    
    var invoiceData: InvoiceModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.viewGradient(view: view_gradient)
        Utility.shadowInView(view: view_shadow)
        Utility.navigationBarView(view: view_navigation)
        self.navigationController?.navigationBar.isHidden = true
        

        let urlStr:String = self.invoiceData!.invoice_url
        web_view.loadRequest(URLRequest(url: URL(string: urlStr)!))
        
        
        
//        // Create destination URL
//        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
//        let destinationFileUrl = documentsUrl.appendingPathComponent("downloadedFile1.pdf")
//
//        //Create URL to the source file you want to download
//        let fileURL = URL(string: urlStr)
//
//        let sessionConfig = URLSessionConfiguration.default
//        let session = URLSession(configuration: sessionConfig)
//
//        let request = URLRequest(url:fileURL!)
//
//        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
//            if let tempLocalUrl = tempLocalUrl, error == nil {
//                // Success
//                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                    print("Successfully downloaded. Status code: \(statusCode)")
//                }
//
//                do {
//                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
//                } catch (let writeError) {
//                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
//                }
//
//            } else {
//                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
//            }
//        }
//        task.resume()

    }
    @IBAction func save_to_gallary_touch(_ sender: Any) {
        UIGraphicsBeginImageContext(self.web_view.frame.size)
        self.web_view.layer.render(in: UIGraphicsGetCurrentContext()!)
        var viewImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(viewImage!, nil, nil, nil)
    }
    @IBAction func btn_touch(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        //   self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
        
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
