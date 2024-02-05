//
//  UIButton+Extensions.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit
import Combine

extension UIButton {
    
    /// Tap publisher
    var onTap: AnyPublisher<Void, Never> {
        InteractionPublisher(sender: self, event: .touchUpInside)
            .eraseToAnyPublisher()
    }
    
}
