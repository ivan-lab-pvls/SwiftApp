//
//  Driver.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import Combine

class Driver<Output, Failure>: Publisher where Failure : Error {
    
    // MARK: - Private properties
    
    /// Current value subject
    private let currentValueSubject: CurrentValueSubject<Output, Failure>
    
    
    // MARK: - Properties
    
    /// Value
    var value: Output {
        currentValueSubject.value
    }
    
    
    // MARK: - Initialization
    
    /// Initialization with subject
    public init(_ subject: CurrentValueSubject<Output, Failure>) {
        currentValueSubject = subject
    }
    
    /// Receive subscriber
    public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        currentValueSubject.receive(subscriber: subscriber)
    }
    
}

// MARK: - Extensions
extension CurrentValueSubject {
    
    /// Convert subject to driver publisher
    func asDriver() -> Driver<Output, Failure> {
        .init(self)
    }
    
}
