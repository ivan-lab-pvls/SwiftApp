//
//  UIEdgeInsets+Extensions.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit

extension UIEdgeInsets {
    
    /// Vertical instets value
    var vertical: CGFloat {
        top + bottom
    }
    
    /// Horizontal instets value
    var horizontal: CGFloat {
        left + right
    }
    
}

extension UIEdgeInsets {
    
    /// Initialization
    init(_ inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    /// Initialization by vertical
    init(top: CGFloat = 0, bottom: CGFloat = 0) {
        self.init(top: top, left: 0, bottom: bottom, right: 0)
    }
    
    /// Initialization by horizontal
    init(left: CGFloat = 0, right: CGFloat = 0) {
        self.init(top: 0, left: left, bottom: 0, right: right)
    }
    
    /// Initialization by vertical
    init(vertical: CGFloat = 0) {
        self.init(top: vertical, left: 0, bottom: vertical, right: 0)
    }
    
    /// Initialization by horizontal
    init(horizontal: CGFloat = 0) {
        self.init(top: 0, left: horizontal, bottom: 0, right: horizontal)
    }
    
    /// Initialization
    init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
}

