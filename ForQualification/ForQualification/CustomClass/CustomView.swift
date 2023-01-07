//
//  CustomView.swift
//  ForQualification
//
//  Created by 祥平 on 2022/07/10.
//

import Foundation
import UIKit

class CustomView: UIView {
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
extension UIView {
    // 角丸の半径(0で四角形)
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    // 影
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }

    // 枠
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }

}
