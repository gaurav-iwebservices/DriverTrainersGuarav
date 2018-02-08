//
//  Progress_VC.swift
//  Driving Trainers
//
//  Created by iws on 1/10/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import Charts

class Progress_VC: UIViewController {

    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var sliderView: JMMarkSlider!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var gradientView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.shadowInView(view: shadowView)
        Utility.viewGradient(view: gradientView)
        Utility.buttonGradient(button: submitButton)
        Utility.navigationBarView(view: navigationView)
        submitButton.layer.cornerRadius = submitButton.frame.size.height/2
        sliderView.minimumValue = 1
        sliderView.maximumValue = 100
        sliderView.addTarget(self, action: #selector(self.sliderValueDidChange(sender:)),for: .
            valueChanged)
        self.updateChartData()
        pieChart.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
    }

    @objc func sliderValueDidChange(sender: UISlider) {
        if sender.value <= 30 {
            sliderView.minimumTrackTintColor = UIColor.green
        } else if sender.value > 30 && sender.value <= 60 {
            sliderView.minimumTrackTintColor = UIColor.yellow
        } else {
            sliderView.minimumTrackTintColor = UIColor.red
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateChartData()  {
        
       
        // 2. generate chart data entries
        let track = ["Income", "Expense", "Wallet", "Bank"]
        let money = [650, 456, 78, 856.0]
        
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = track[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "Pie Chart")
        // this is custom extension method. Download the code for more details.
        let colors: [UIColor] = [
            UIColor(red: 223.0/255.0, green: 0.0/255.0, blue: 34.0/255.0, alpha: 1.0),
            UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 7.0/255.0, alpha: 1.0),
            UIColor(red: 142.0/255.0, green: 255.0/255.0, blue: 142.0/255.0, alpha: 1.0),
            UIColor(red: 5.0/255.0, green: 159.0/255.0, blue: 21.0/255.0, alpha: 1.0)
            ]
        /*for _ in 0..<money.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }*/
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
