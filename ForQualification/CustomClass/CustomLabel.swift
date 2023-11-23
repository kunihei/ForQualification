//
//  CustomLabel.swift
//  ForQualification
//
//  Created by 祥平 on 2021/10/15.
//

import UIKit

@IBDesignable
class CustomLabel: UILabel {
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
