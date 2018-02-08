//
//  FilterView.swift
//  Driving Trainers
//
//  Created by iws on 1/30/18.
//  Copyright © 2018 iWeb. All rights reserved.
//

import UIKit

class FilterView: UIView {

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var referedText: UITextField!
    @IBOutlet weak var contactNumberText: UITextField!
    @IBOutlet weak var learnerNameText: UITextField!
    var view:UIView!
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "FilterView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        subView.layer.cornerRadius = 5
        Utility.buttonGradient(button: searchBtn)
        searchBtn.layer.cornerRadius = searchBtn.frame.size.height/2
        Utility.underLine(txt: learnerNameText)
        Utility.underLine(txt: contactNumberText)
        Utility.underLine(txt: referedText)
        self.setImageInTextField(textField: referedText)
        
        return view
    }
    
    func  setImageInTextField(textField:UITextField) {
        textField.rightViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: "dropdown")
        
        textField.rightView = imageView
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
    }

}



