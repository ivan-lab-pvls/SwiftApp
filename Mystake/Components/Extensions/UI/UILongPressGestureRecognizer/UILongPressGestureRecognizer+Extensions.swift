//
//  UILongPressGestureRecognizer+Extensions.swift
//  Mystake
//
//  Created by Vladko on 19.01.2024.
//

import UIKit
import Combine

extension UILongPressGestureRecognizer {
    
    /// On long press publisher
    var onPress: AnyPublisher<UILongPressGestureRecognizer, Never> {
        InteractionPublisher(sender: self)
            .compactMap { [weak self] in self }
            .filter {
                $0.state == .began ||
                $0.state == .ended ||
                $0.state == .cancelled ||
                $0.state == .failed
            }.eraseToAnyPublisher()
    }
    
}
