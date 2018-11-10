//
//  PinCodeView.swift
//  pincode
//
//  Created by 晨卓爸爸 on 2018/11/10.
//  Copyright © 2018 Personal. All rights reserved.
//

import UIKit

protocol PinCodeTextFieldProtocol: UITextFieldDelegate {
    var isFilled: Bool { get }
    var pinCodes: String { get }
    func didPressBackspace(textField : PinCodeTextField)
}

class PinCodeTextField: UITextField {
    
    var isFilled: Bool {
        return self.pinCode.count > 0
    }
    var pinCode: String {
        return self.text ?? ""
    }
    var maxCharacterCount: Int = 1
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor.lightText.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 2.0
        self.borderStyle = .none
        self.backgroundColor = UIColor.white
//        self.textContentType = .oneTimeCode
        self.inputAccessoryView = self.generateToolbar()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func deleteBackward() {
        super.deleteBackward()
        (self.delegate as? PinCodeTextFieldProtocol)?.didPressBackspace(textField: self)
    }
    func generateToolbar() -> UIToolbar {
        let width = UIScreen.main.bounds.width
        
        let toolbar =  UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 44.0))
        let itme1 = UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.flexibleSpace , target: nil, action: nil)
        let item2 = UIBarButtonItem(title: "done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneButtonDidPressed))
        toolbar.setItems([itme1, item2], animated: false)
        return toolbar
    }
    @objc func doneButtonDidPressed() {
        self.resignFirstResponder()
    }
}
class PinCodeView: UIView {
    var textFields = [PinCodeTextField]()
    var inputComplete: ((Bool, String)->())?
    
    var pinCodeCount: Int = 1 {
        didSet {
            for tf in textFields {
                tf.removeFromSuperview()
            }
            textFields.removeAll()
            
            for _ in 0..<pinCodeCount {
                print("addSubveiw")
                let tf = PinCodeTextField(frame: CGRect.zero)
                textFields.append(tf)
                self.addSubview(tf)
                tf.textAlignment = .center
                tf.delegate = self
                tf.keyboardType = .numberPad
                tf.addTarget(self, action: #selector(textFieldCotentDidChange(_:)), for: .editingChanged)
                tf.addTarget(self, action: #selector(textFieldCotentDidEnd(_:)), for: .editingDidEnd)
            }
        }
    }
    init(frame: CGRect, pinCode count: Int = 4) {
        super.init(frame: frame)
        setPinCodeCount(count)
        self.backgroundColor = UIColor.random
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        var startX = CGFloat(pinCodeCount)*40/CGFloat(2.0)-1
        startX = frame.width/2-startX
        for (i, tf) in textFields.enumerated() {
            tf.frame = CGRect(x: (startX+CGFloat(i*38+i*2)), y: 8, width: 38, height: 38)
            print(tf.frame)
        }
        
    }
    func setPinCodeCount(_ count: Int) {
        self.pinCodeCount = count
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func getFirstResponder(in view: UIView) -> UIView? {
        for subview in view.subviews {
            print(subview)
            if subview.isFirstResponder {
                return subview
            }
            if let fr = getFirstResponder(in: subview) {
                return fr
            }
        }
        return nil
    }
}
extension PinCodeView: PinCodeTextFieldProtocol {
    var isFilled: Bool {
        
        for tf in textFields {
            if !tf.isFilled {
                return false
            }
        }
        return true
    }
    var pinCodes: String {
        var pinCode = ""
        let _=self.textFields.map { pinCode += $0.pinCode }
        return pinCode
    }
    func didPressBackspace(textField: PinCodeTextField) {
        becomeFirstResponder(before: textField)
    }
    @objc func textFieldCotentDidEnd(_ textField: UITextField) {
        if let method = self.inputComplete {
            method(self.isFilled, self.pinCodes)
        }
    }
    @objc func textFieldCotentDidChange(_ textField: UITextField) {
        guard let textField = textField as? PinCodeTextField else { return }
        if textField.pinCode.count == 0 {
            becomeFirstResponder(before: textField)
        }
        
        // when textfield has been filled, ok! next!
        if textField.pinCode.count == textField.maxCharacterCount {
            becomeFirstResponder(after: textField)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textField = textField as? PinCodeTextField else { return true }
        
        if string == "" {
            return true
        }
        
        // when textfield is not empty, well, next
        if textField.pinCode.count == textField.maxCharacterCount {
            becomeFirstResponder(after: textField)
            return false
        }
        if string.count > textField.maxCharacterCount {
            return false
        }
        return true
    }
    
    func becomeFirstResponder(after textField: UITextField) {
        becomeFirstResponder(of: textField, offset: 1)
    }
    func becomeFirstResponder(before textField: UITextField) {
        becomeFirstResponder(of: textField, offset: -1)
    }
    
    @discardableResult
    private func becomeFirstResponder(of textField: UITextField, offset by: Int) -> Bool {
        var result = false
        if let i = textFields.firstIndex(of: textField as! PinCodeTextField) {
            textField.resignFirstResponder()
            if (0..<self.pinCodeCount).contains(i+by) {
                result = self.textFields[i+by].becomeFirstResponder()
            } else {

            }
        }
        return result
    }
    
    
}


