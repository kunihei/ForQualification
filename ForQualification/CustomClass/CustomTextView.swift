//
//  CustomTextView.swift
//  ForQualification
//
//  Created by 祥平 on 2021/10/15.
//

import UIKit

extension UITextView {
    // textView入力時キーボードを閉じるボタン表示
    func closeKeyboard() {
        let custombar = UIView(frame: CGRect(x:0, y:0,width:(UIScreen.main.bounds.size.width),height:40))
        custombar.backgroundColor = UIColor.white
        let commitBtn = UIButton(frame: CGRect(x:(UIScreen.main.bounds.size.width)-60,y:0,width:60,height:40))
        commitBtn.setTitle(ButtonTitle.Common.close, for: .normal)
        commitBtn.setTitleColor(UIColor.blue, for:.normal)
        commitBtn.addTarget(self, action:#selector(onClickCommitButton), for: .touchUpInside)
        custombar.addSubview(commitBtn)
        self.inputAccessoryView = custombar
        self.keyboardType = .default
    }
    
    @objc func onClickCommitButton() {
        self.resignFirstResponder()
    }
    
    func chkEmpty() -> Bool {
        if self.text.isEmpty {
            return true
        }
        return false
    }
}

@IBDesignable
class CustomTextView: UITextView {}
