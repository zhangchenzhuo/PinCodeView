//
//  ViewController.swift
//  pincode
//
//  Created by 晨卓爸爸 on 2018/11/10.
//  Copyright © 2018 Personal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var pinCodeView: PinCodeView = {
        let p = PinCodeView(frame: CGRect.zero, pinCode: 0)
        return p
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.pinCodeView)
        self.pinCodeView.frame = CGRect(x: 90, y: 90, width: 300, height: 70)
        self.pinCodeView.inputComplete = {[unowned self] (completed, pinCode) in
            print(completed, pinCode)
        }
       self.pinCodeView.pinCodeCount = 6
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


extension UIColor {
    class var random: UIColor {
        let r = CGFloat(arc4random()%256)/255.0
        let g = CGFloat(arc4random()%256)/255.0
        let b = CGFloat(arc4random()%256)/255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

