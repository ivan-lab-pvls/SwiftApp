//
//  UITextField+Extensions.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit

extension UITextField {
    
    /// Placeholder color
    var placeholderColor: UIColor? {
        get {
            guard attributedPlaceholder?.length ?? 0 > 0 else { return nil }
            let key = NSAttributedString.Key.foregroundColor
            let color = attributedPlaceholder?.attribute(key, at: 0, effectiveRange: nil) as? UIColor
            return color
        }
        set {
            let placeholder = attributedPlaceholder?.string ?? placeholder ?? " "
            let attributes = [NSAttributedString.Key.foregroundColor : newValue]
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes as [NSAttributedString.Key : Any])
        }
    }
    
}
