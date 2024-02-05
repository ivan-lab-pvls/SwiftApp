//
//  UIBezierPath+Circle.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit

extension UIBezierPath {
    
    convenience init(center: CGPoint, radius: CGFloat) {
        self.init(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(.pi * 2.0), clockwise: true)
    }
    
}
