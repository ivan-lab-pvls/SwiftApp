//
//  Gradient.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import Foundation
import UIKit

enum Gradient {
    
    /// Solid gradient
    case solid(color: UIColor)
    
    /// Neon
    case neon
    
    /// Green
    case green
    
    /// Orange
    case orange
    
}

extension Gradient {
    
    /// Colors
    var colors: [UIColor] {
        switch self {
        case .solid(let color):
            return [color, color]
        case .neon:
            return [.gradientNeon1, .gradientNeon2]
        case .green:
            return [.gradientGreen1, .gradientGreen2]
        case .orange:
            return [.gradientOrange1, .gradientOrange2]
        }
    }
    
    /// Gradient start point
    var startPoint: CGPoint {
        switch self {
        case .solid:
            return .zero
        case .neon, .green, .orange:
            return .init(x: 0.5, y: 0)
        }
    }
    
    /// Gradient end point
    var endPoint: CGPoint {
        switch self {
        case .solid:
            return .zero
        case .neon, .green, .orange:
            return .init(x: 0.5, y: 1)
        }
    }
    
}

extension Gradient {
    
    /// Linear gradient
    var linearGradient: CAGradientLayer {
        let gradient = CAGradientLayer()
        
        guard colors.count >= 2 else { return gradient }
        
        var locations: [NSNumber] = [0, 1]
        if colors.count > 2 {
            let step = 1.0/Double(colors.count)
            for i in 1...colors.count {
                locations.insert(step * Double(i) as NSNumber, at: i)
            }
        }
        
        gradient.type = .axial
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        return gradient
    }
    
}


