//
//  CupType.swift
//  Mystake
//
//  Created by Vladko on 20.01.2024.
//

import UIKit

enum CupFieldType: CaseIterable {
    
    /// Cup 1
    case cup1
    
    /// Cup 2
    case cup2
    
    /// Cup 3
    case cup3
    
    /// Cup 4
    case cup4
    
    /// Cup 5
    case cup5
    
}

extension CupFieldType {
    
    /// Image
    var image: UIImage? {
        switch self {
        case .cup1:
            return Icons.cup1
        case .cup2:
            return Icons.cup2
        case .cup3:
            return Icons.cup3
        case .cup4:
            return Icons.cup4
        case .cup5:
            return Icons.cup5
        }
    }
    
}
