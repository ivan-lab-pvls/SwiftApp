//
//  MineFieldType.swift
//  Mystake
//
//  Created by Vladko on 20.01.2024.
//

import UIKit

enum MineFieldType {
    
    /// Empty
    case empty
    
    /// Mine
    case mine
    
    /// Cherry
    case cherry
    
}

extension MineFieldType {
    
    /// Image
    var image: UIImage? {
        switch self {
        case .empty:
            return nil
        case .mine:
            return Icons.mine
        case .cherry:
            return Icons.cherry
        }
    }
    
    /// Gradient
    var gradient: Gradient {
        switch self {
        case .empty:
            return .solid(color: .clear)
        case .mine:
            return .orange
        case .cherry:
            return .green
        }
    }
    
}
