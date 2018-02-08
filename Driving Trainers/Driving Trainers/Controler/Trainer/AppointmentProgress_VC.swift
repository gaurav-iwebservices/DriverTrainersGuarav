//
//  AppointmentProgress_VC.swift
//  Driving Trainers
//
//  Created by iws on 1/25/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON
import NotificationBannerSwift

class AppointmentProgress_VC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var navigationView: UIView!
    var appointmentView:Bool!
    var dataArr:[Task] = []
    var lessionId:String!
    var trainerId:String!

    var learnerId:String!
    var pieChart:PieChartView!
    var index:Int!
    var tmpTextView:UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        Utility.navigationBarView(view: navigationView)
        Utility.viewGradient(view: gradientView)
        Utility.viewGradient(view: statusBarView)
        Utility.shadowInView(view: shadowView)
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ProgressView_TVC", bundle: nil), forCellReuseIdentifier: "ProgressView_TVC")
        tableView.register(UINib(nibName: "ProgressView2_TVC", bundle: nil), forCellReuseIdentifier: "ProgressView2_TVC")
        tableView.register(UINib(nibName: "ProgressSliderView_TVC", bundle: nil), forCellReuseIdentifier: "ProgressSliderView_TVC")
        menuContainerViewController.panMode = MFSideMenuPanModeNone
        self.getProgressDetails()
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getProgressDetails() {
        if UserData.role == "2"{
            self.trainerId = UserData.Id
        }
        let data:[String:String] = [
            "trainer_id": self.trainerId,
            "lesson_id":lessionId
        ]
        print(data)
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.viewProgress, dataDict: data, { (json) in
            print(json)
            
            if json["status"].stringValue == "True" {
                for i in 0..<json["progress"].arrayValue.count {
                    self.dataArr.append(Task.init(
                        taskName: json["progress"][i]["task_name"].stringValue,
                        taskId: json["progress"][i]["task_id"].stringValue,
                        taskScore: json["progress"][i]["score"].stringValue
                    ))
                }
                self.tableView.reloadData()
            }
            
            if json["status"].stringValue == "False" {
                let banner = NotificationBanner(title: "Alert", subtitle: json["message"].stringValue , style: .danger)
                banner.show(queuePosition: .front)
            }
            
        }) { (error) in
            print(error)
        }
        
    }
    
    /*"trainer_id
     lerner_id
     lesson_id [id from my appoinment]
     trainer_name
     progress:[{""task_id"":""3"",""task_name"":""Left Turn"",""score"":""20""},
     {""task_id"":""4"",""task_name"":""Right Turn"",""score"":""60""},
     {""task_id"":""6"",""task_name"":""Back"",""score"":""30""}]
     comment"*/
    
    @objc func setDataForWebServices(sender:UIButton){
        var taskDict:[[String:Any]] = []
        for i in 0..<dataArr.count {
            let dict:[String:String] = [
                "task_id" : dataArr[i].taskId,
                "task_name" : dataArr[i].taskName,
                "score" : dataArr[i].taskScore
            ]
            taskDict.append(dict)
        }
        
        let dataDict:[String:Any] = [
            "trainer_id": UserData.Id,
            "lerner_id":learnerId,
            "lesson_id":lessionId,
            "trainer_name":UserData.firstName + UserData.lastName ,
            "progress":taskDict,
            "comment":tmpTextView.text!
        ]
        
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.addProgress, dataDict: dataDict, { (json) in
            print(json)
        }) { (error) in
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
    
    func updateChartData(pieChart:PieChartView)  {
        
        
        var entries = [PieChartDataEntry]()
        for (index, value) in dataArr.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = Double(value.taskScore)!
            entry.label = value.taskName
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "Pie Chart")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
           /* UIColor(red: 223.0/255.0, green: 0.0/255.0, blue: 34.0/255.0, alpha: 1.0),
            UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 7.0/255.0, alpha: 1.0),
            UIColor(red: 142.0/255.0, green: 255.0/255.0, blue: 142.0/255.0, alpha: 1.0),
            UIColor(red: 5.0/255.0, green: 159.0/255.0, blue: 21.0/255.0, alpha: 1.0)
        ]*/
        for _ in 0..<dataArr.count {
         let red = Double(arc4random_uniform(256))
         let green = Double(arc4random_uniform(256))
         let blue = Double(arc4random_uniform(256))
         let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
         colors.append(color)
         }
        set.sliceSpace = 1
        set.valueLinePart1Length = 0.2
        set.valueLinePart2Length = 1.2
        set.valueLinePart1OffsetPercentage = 0.8
        //set.valueLineVariableLength = true
        set.selectionShift = 0.0
        
        set.setColor(UIColor.black)
        set.yValuePosition = .outsideSlice
        
        set.colors = colors
        let data = PieChartData(dataSet: set)
        data.setValueTextColor(UIColor.black)
        pieChart.data = data
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        pieChart.noDataText = "No data available"
        // user interaction
        pieChart.isUserInteractionEnabled = true
        
        
        let discription = Description()
        discription.text = " "
        
        
        pieChart.drawEntryLabelsEnabled = false
        pieChart.drawCenterTextEnabled = false
        pieChart.usePercentValuesEnabled = true
        
        
        
        pieChart.chartDescription = discription
        pieChart.centerText = "Pie Chart"
        pieChart.holeRadiusPercent = 0.0
        pieChart.transparentCircleColor = UIColor.clear
        pieChart.legend.enabled = false
        
        
    }
    
   
    @objc func sliderValueDidChange(sender: UISlider) {
       dataArr[sender.tag].taskScore = String(Int(sender.value))
       // let indexPath = IndexPath(item: 0, section: 0)
        //tableView.reloadRows(at: [indexPath], with: .top)
        self.updateChartData(pieChart: self.pieChart)
    }
    

}

extension AppointmentProgress_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appointmentView == true {
            return dataArr.count + 1
        }else{
            return dataArr.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressView_TVC", for: indexPath) as! ProgressView_TVC
            self.pieChart = cell.pieView
            if appointmentView == true {
                cell.nameLabel.text = TrainerProfile.MACompletedData[index].name
                cell.infoLabel.text = TrainerProfile.MACompletedData[index].createdDate
            }else{
                cell.nameLabel.text = TrainerProfile.MADataArr[index].name
                cell.infoLabel.text = TrainerProfile.MADataArr[index].createdDate
            }
            self.updateChartData(pieChart: cell.pieView)
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == dataArr.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressView2_TVC", for: indexPath) as! ProgressView2_TVC
            cell.submitBtn.addTarget(self, action: #selector(self.setDataForWebServices(sender:)), for: UIControlEvents.touchUpInside)
           // Utility.buttonGradient(button: cell.submitBtn)
            tmpTextView = cell.messageTextView
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressSliderView_TVC", for: indexPath) as! ProgressSliderView_TVC
            print(indexPath.row)
            cell.activityLabel.text = dataArr[indexPath.row - 1].taskName
            cell.progressSlider.value = Float(dataArr[indexPath.row - 1].taskScore)!
            cell.progressSlider.tag = indexPath.row - 1
            cell.valueLabel.text = dataArr[indexPath.row - 1].taskScore + "%"
            cell.progressSlider.addTarget(self, action: #selector(self.sliderValueDidChange(sender:)),for: .
                valueChanged)
            if appointmentView == true {
                cell.progressSlider.isEnabled = false
            }
            cell.selectionStyle = .none
            return cell
        }
    }
}
