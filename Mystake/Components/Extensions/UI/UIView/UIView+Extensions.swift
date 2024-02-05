//
//  UIView+Extensions.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit

extension UIView {
    
    /// Add subviews
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    /// Tap gesture
    func tapGesture() -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
        return tapGesture
    }
    
}
