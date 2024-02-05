//
//  UIApplication+Extensions.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit

extension UIApplication {
    
    /// Key window
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
}
