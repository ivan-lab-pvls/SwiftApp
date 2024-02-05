//
//  SelectionImageAction.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import UIKit

enum SelectionImageAction {
    
    /// Camera action
    case camera
    
    /// Photo library action
    case library
    
}

extension SelectionImageAction {
    
    /// Action title
    var title: String {
        switch self {
        case .camera:
            return "Camera"
        case .library:
            return "Camera roll"
        }
    }
    
    /// Picker source type
    var sourceType: UIImagePickerController.SourceType {
        switch self {
        case .camera:
            return .camera
        case .library:
            return .photoLibrary
        }
    }
    
}
