//
//  Utility.swift
//  NicoBeacon
//
//  Created by Vinay on 21/08/17.
//  Copyright © 2017 iWeb. All rights reserved.
//

import UIKit
import SQLite3


class Utility: NSObject
{
    class func textUnderline(txtF: UITextField)
    {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: txtF.frame.size.height - width, width:  txtF.frame.size.width, height: txtF.frame.size.height)
        
        border.borderWidth = width
        txtF.layer.addSublayer(border)
        txtF.layer.masksToBounds = true
    }
    
    class func buttonGradient(button: UIButton)
    {
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.colors = [Defines.kStartColor, Defines.kEndColor];
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = button.bounds
        gradient.cornerRadius = button.frame.size.height/2
        button.clipsToBounds = true
        button.layer.insertSublayer(gradient, at: 0)
    }
    class func viewGradient(view: UIView)
    {
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.colors = [Defines.kStartColor, Defines.kEndColor];
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
    class func shadowInView(view: UIView)
    {
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 10
    }
    
    class func navigationBarView(view: UIView){
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.colors = [Defines.kStartColor, Defines.kEndColor];
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 10
    }
   
    class func underLine(txt: UITextField)
    {
        let border = CALayer()
        let width = CGFloat(1.0)

        border.borderColor = Defines.kTextViewUnderLineColor
        
        border.frame = CGRect(x: 0, y: txt.frame.size.height - width, width:  txt.frame.size.width, height: txt.frame.size.height)
        border.borderWidth = width
        txt.layer.addSublayer(border)
        txt.layer.masksToBounds = true
    }
    
    // MARK: - alert message method
    class func showAlertMessage(vc: UIViewController, titleStr:String, messageStr:String) -> Void
    {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert);
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func emailValidation(_ emailId: String) -> Bool
    {
       
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailId)
    }
    
    class func passwordValidation(_ pwd: String) -> Bool
    {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: passwordTest)
    }
    
    class func nameValidity(_ lastName: String) -> Bool
    {
       // let error: Error? = nil
        let regex = try? NSRegularExpression(pattern: "[a-zA-Z ]", options: [])
        let numberOfMatches: Int = (regex?.numberOfMatches(in: lastName, options: [], range: NSRange(location: 0, length: (lastName.characters.count ))))!
        return numberOfMatches == (lastName.characters.count )
    }
    
    class func openDataBase()->Bool{
        let bundlePath = Bundle.main.path(forResource: "TrainerLearner", ofType: ".db")
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        let fullDestPath = URL(fileURLWithPath: destPath).appendingPathComponent("TrainerLearner.db")
        if fileManager.fileExists(atPath: fullDestPath.path){
            print("Database file is exist")
            print(fullDestPath)
            //var db: OpaquePointer?
            if sqlite3_open(fullDestPath.path, &DataManger._gDataManager.database) != SQLITE_OK {
                return false
            }
            else
            {
                return true
            }
           
            

            print(fileManager.fileExists(atPath: bundlePath!))
        }else{
            do{
                try fileManager.copyItem(atPath: bundlePath!, toPath: fullDestPath.path)
                return false

            }catch{
                print("\n",error)
                return false
            }
        }
    }

    class func getStateList() -> ([String],[String]) {
        let databasePath = UserDefaults.standard.url(forKey: "DataBasePath")!
        let contactDB = FMDatabase(path: String(describing: databasePath))
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM State "
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,withArgumentsIn: nil)
            var name:[String] = []
            var stateCode:[String] = []
            while((results?.next()) == true){
                //print(results!.string(forColumn: "state")!)
                
                name.append(results!.string(forColumn: "state"))
                stateCode.append(results!.string(forColumn: "stateCode"))

                /*if AssessId.contains(results!.string(forColumn: "AssessmentId")!) == false {
                    AssessId.append(results!.string(forColumn: "AssessmentId")!)
                    performedBy.append(results!.string(forColumn: "performedBy")!)
                    reportStatus.append(Int(results!.string(forColumn: "ReportStatus")!)!)
                    AssessCreateDate.append(results!.string(forColumn: "Date")!)
                    AssessType.append(results!.string(forColumn: "Type")!)
                }*/
            }
            return (name,stateCode)
            contactDB?.close()
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            return ([],[])
        }
    }
    
    // get data from sqlite
    class func getSuburbList(state:String) -> ([String],[String]) {
        let databasePath = UserDefaults.standard.url(forKey: "DataBasePath")!
        let contactDB = FMDatabase(path: String(describing: databasePath))
        
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM Suburb where state = '\(state)' AND type='Suburb'"
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,withArgumentsIn: nil)
            var name:[String] = []
            var postCode:[String] = []
            
            while((results?.next()) == true){
               // print(results!.string(forColumn: "name"))
                name.append(results!.string(forColumn: "name"))
                postCode.append(results!.string(forColumn: "postCode"))
                /*if AssessId.contains(results!.string(forColumn: "AssessmentId")!) == false {
                 AssessId.append(results!.string(forColumn: "AssessmentId")!)
                 performedBy.append(results!.string(forColumn: "performedBy")!)
                 reportStatus.append(Int(results!.string(forColumn: "ReportStatus")!)!)
                 AssessCreateDate.append(results!.string(forColumn: "Date")!)
                 AssessType.append(results!.string(forColumn: "Type")!)
                 }*/
            }
            
            return (name,postCode)
            contactDB?.close()
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            return ([],[])
        }
    }
    
    /*func getPostCode(stateName:String)  {
        let databasePath = UserDefaults.standard.url(forKey: "DataBasePath")!
        let contactDB = FMDatabase(path: String(describing: databasePath))
        
        //INSERT INTO State (ID,name,urbanArea,stateCode,state,postCode,type)
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM State where state = '\(stateName)'"
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,withArgumentsIn: nil)
            var name:[String] = []
            var postCode:[String] = []
            
            while((results?.next()) == true){
                // print(results!.string(forColumn: "name"))
                name.append(results!.string(forColumn: "name"))
                postCode.append(results!.string(forColumn: "postCode"))
                /*if AssessId.contains(results!.string(forColumn: "AssessmentId")!) == false {
                 AssessId.append(results!.string(forColumn: "AssessmentId")!)
                 performedBy.append(results!.string(forColumn: "performedBy")!)
                 reportStatus.append(Int(results!.string(forColumn: "ReportStatus")!)!)
                 AssessCreateDate.append(results!.string(forColumn: "Date")!)
                 AssessType.append(results!.string(forColumn: "Type")!)
                 }*/
            }
            
           // return (name,postCode)
            contactDB?.close()
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            //return ([],[])
        }
    }*/
    
}
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        if  urlString == "" {
            return
        }
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }}

//extension UIImageView {
//    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleToFill) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() {
//                self.image = image
//            }
//            }.resume()
//    }
//    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleToFill) {
//        guard let url = URL(string: link) else { return }
//        downloadedFrom(url: url, contentMode: mode)
//    }
//}

