//
//  UISwitch+Extensions.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit
import Combine

extension UISwitch {
    
    /// Switch publisher
    var onSwitch: AnyPublisher<Bool, Never> {
        InteractionPublisher(sender: self, event: .valueChanged)
            .compactMap { [weak self] in self?.isOn ?? false }
            .eraseToAnyPublisher()
    }
    
}
