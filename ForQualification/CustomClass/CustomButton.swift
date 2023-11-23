//
//  CustomButton.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/29.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable var color1: UIColor = UIColor.white
    @IBInspectable var color2: UIColor = UIColor.lightGray
    @IBInspectable var position1: CGPoint = CGPoint(x: 0.5, y: 0)
    @IBInspectable var position2: CGPoint = CGPoint(x: 0.5, y: 1)
    override func draw(_ rect: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        let color1 = color1.cgColor
        let color2 = color2.cgColor
        gradientLayer.colors = [color1, color2]
        
        gradientLayer.startPoint = position1
        gradientLayer.endPoint = position2
        gradientLayer.cornerRadius = self.layer.cornerRadius
        
        self.layer.insertSublayer(gradientLayer, at: 0)
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
