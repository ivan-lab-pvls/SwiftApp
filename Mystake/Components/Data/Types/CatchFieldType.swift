//
//  CatchFieldType.swift
//  Mystake
//
//  Created by Vladko on 20.01.2024.
//

import Foundation

enum CatchFieldType {
    
    /// Empty
    case empty
    
    /// Selected
    case selected
    
    /// Success
    case success
    
    /// Failure
    case failure
    
}

extension CatchFieldType {
    
    /// Gradient
    var gradient: Gradient {
        switch self {
        case .empty:
            return .solid(color: .background2)
        case .selected:
            return .solid(color: .background3)
        case .success:
            return .green
        case .failure:
            return .solid(color: .background4)
        }
    }
    
}


