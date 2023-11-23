//
//  Notification.swift
//  ForQualification
//
//  Created by 祥平 on 2023/11/11.
//

import UIKit

extension Notification {
    // キーボードの高さ
    var keyboardHeight: CGFloat? {
        return (self.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
    }
    // キーボードのアニメーション時間
    var keybaordAnimationDuration: TimeInterval? {
        return self.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
    }
    
    // キーボードのアニメーション曲線
    var keyboardAnimationCurve: UInt? {
        return self.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
    }
}

struct  UIKeyboardInfo {
    let frame: CGRect
    let animationDuration: TimeInterval
    let animationCurve: UIView.AnimationOptions
    
    init?(info: [AnyHashable : Any]) {
        guard
            let frame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
            else { return nil }
        self.frame = frame
        animationDuration = duration
        animationCurve = UIView.AnimationOptions(rawValue: curve)
    }
}

class NotificationObserver {
    
    let closure: (_ notification: Notification) -> Void

    init(closure: @escaping (_ notification: Notification) -> Void) {
        self.closure = closure
    }

    @objc func invoke(_ notification: Notification) {
        closure(notification)
    }
}
