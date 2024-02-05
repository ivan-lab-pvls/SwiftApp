//
//  Publicher+Actions.swift
//  Mystake
//
//  Created by Vladko on 07.12.2023.
//

import Foundation
import Combine

extension Publisher {
    
    /// Delay in main loop
    func delay(milliseconds: Int) -> AnyPublisher<Self.Output, Self.Failure> {
        delay(for: .milliseconds(milliseconds), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    /// Delay in main loop
    func delay(seconds: Int) -> AnyPublisher<Self.Output, Self.Failure> {
        delay(for: .seconds(seconds), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
}

extension Publisher {
    
    /// Debounce in main loop
    func debounce(milliseconds: Int) -> AnyPublisher<Self.Output, Self.Failure> {
        debounce(for: .milliseconds(milliseconds), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    /// Debounce in main loop
    func debounce(seconds: Int) -> AnyPublisher<Self.Output, Self.Failure> {
        debounce(for: .seconds(seconds), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
}
