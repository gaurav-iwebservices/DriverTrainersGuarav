//
//  TrainerAboutUs_VC.swift
//  Driving Trainers
//
//  Created by iws on 1/18/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit
import AVFoundation
//import PlaygroundSupport

class TrainerAboutUs_VC: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var navigationView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        Utility.navigationBarView(view: navigationView)
        Utility.viewGradient(view: gradientView)
        Utility.shadowInView(view: backgroundView)
        self.navigationController?.navigationBar.isHidden = true
        
        let str = "14 down voteRound about answer:Application will resign active gets called in all sorts of scenarios... and from all my testing, even if your application stays awake while backgrounded, there are no ways to determine that the screen is locked (CPU speed doesn't report, BUS speed remains the same, mach_time denom / numer doesn't change)... However, it seems Apple does turn off the accelerometer when the device is locked... Enable iPhone accelerometer while screen is locked (tested iOS4.2 on iPhone 4 has this behavior) Thus...In your application delegate:"
        
       
        
       // PlaygroundPage.current.needsIndefiniteExecution = true
        
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: str)
        
        utterance.rate = 0.5
        
        synthesizer.speak(utterance)
    }

    @IBAction func menuAction(_ sender: UIButton) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in }
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
