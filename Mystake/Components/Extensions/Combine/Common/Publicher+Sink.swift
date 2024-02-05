//
//  Publicher+Sink.swift
//  Mystake
//
//  Created by Vladko on 07.12.2023.
//

import Combine

extension Publisher {
    
    /**
     Sink `Output` value to `((Self.Output) -> Void)`  subject
     - parameters valueSubject: `((Self.Output) -> Void)` subject that receive `Output` value
     */
    func sink(value valueHandler: @escaping ((Self.Output) -> Void)) -> AnyCancellable
    {
        sink { _ in } receiveValue: {
            valueHandler($0)
        }
    }
    
    /**
     Sink `Output` value to `((Self.Output) -> T)
     - parameters valueSubject: `((Self.Output) -> T)` subject that receive `Output` value
     */
    func sink<T: Any>(_ value: ((Output) -> T)?) -> AnyCancellable
    {
        sink { _ in } receiveValue: { output in
            let _ = value?(output)
        }
    }
    
    /**
     Sink
     */
    func sink() -> AnyCancellable {
        sink { _ in }
        receiveValue: { _ in }
    }
    
}
