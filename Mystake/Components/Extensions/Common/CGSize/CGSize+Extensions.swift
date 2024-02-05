//
//  CGSize+Extensions.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit

extension CGSize {
    var min: CGFloat {
        return CGFloat.minimum(width, height)
    }
}
