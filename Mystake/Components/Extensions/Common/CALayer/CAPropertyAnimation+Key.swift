//
//  CAPropertyAnimation+Key.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit

extension CAPropertyAnimation {
    
    enum Key: String {
        var path: String {
            return rawValue
        }

        case strokeStart = "strokeStart"
        case strokeEnd = "strokeEnd"
        case strokeColor = "strokeColor"
        case rotationZ = "transform.rotation.z"
        case scale = "transform.scale"
    }

    convenience init(key: Key) {
        self.init(keyPath: key.path)
    }
    
}
