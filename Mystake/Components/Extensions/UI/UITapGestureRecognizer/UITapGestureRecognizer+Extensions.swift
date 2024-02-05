//
//  UITapGestureRecognizer+Extensions.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit
import Combine

extension UITapGestureRecognizer {
    
    /// On tap publisher
    var onTap: AnyPublisher<UITapGestureRecognizer, Never> {
        InteractionPublisher(sender: self)
            .compactMap { [weak self] in self }
            .eraseToAnyPublisher()
    }
    
}
