//
//  CustomButton.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/29.
//

import UIKit

class CustomButton: UIButton {
    
    // 角丸の半径(0で四角形)
    @IBInspectable var cornerRadius: CGFloat = 10.0
    
    // 影
    @IBInspectable var shadowOpacity: CGFloat = 0.3
    @IBInspectable var shadowRadius: CGFloat = 5.0
    
    // 枠
    @IBInspectable var borderColor: UIColor = UIColor(named: "TextColor")!
    @IBInspectable var borderWidth: CGFloat = 1.0
    
    override func draw(_ rect: CGRect) {
        // 角丸
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = (cornerRadius > 0)
        
        // 影
        self.layer.shadowColor = UIColor(named: "TextColor")?.cgColor
        self.layer.shadowOpacity = Float(shadowOpacity)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        
        // 枠線
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        
        super.draw(rect)
    }
}

extension UIButton {
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.repeatCount = 2
        
        layer.add(flash, forKey: nil)
    }
    
    func pulsate(){
        // 強調するボタン
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
}
