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

    // 枠
    @IBInspectable var borderColor: UIColor = UIColor(named: "TextColor")!
    @IBInspectable var borderWidth: CGFloat = 1.0
    override func draw(_ rect: CGRect) {
        // 角丸
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = (cornerRadius > 0)

        // 枠線
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth

        super.draw(rect)
    }
}
