//
//  Publisher+Assign.swift
//  Mystake
//
//  Created by Vladko on 07.12.2023.
//

import Combine
import UIKit

extension Publisher {
    
    /**
     Assign `Output` valur to `PassthroughSubject` subject
     - parameters valueSubject: `PassthroughSubject` subject that receive `Output` value
     */
    func assign(value valueSubject: PassthroughSubject<Self.Output, Never>?) -> AnyCancellable
    {
        sink { _ in } receiveValue: { [weak valueSubject] in
            valueSubject?.send($0)
        }
    }
    
    /**
     Assign `Output` valur to `CurrentValueSubject` subject
     - parameters valueSubject: `CurrentValueSubject` subject that receive `Output` value
     */
    func assign(value valueSubject: CurrentValueSubject<Self.Output, Never>?) -> AnyCancellable
    {
        sink { _ in } receiveValue: { [weak valueSubject] in
            valueSubject?.send($0)
        }
    }
    
    /**
     Assign safely keyPath on root
     - parameters keyPath: `ReferenceWritableKeyPath` key path
     - parameters root: `Root` object of key path
     */
    func assignSafely<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>,
                                       on root: Root) -> AnyCancellable where Failure == Never
    {
       sink { [weak root] in
            root?[keyPath: keyPath] = $0
       }
    }
    
    /**
     Assign safely keyPath on root
     - parameters keyPath: `ReferenceWritableKeyPath` key path
     - parameters root: `Root` object of key path
     */
    func assignAnimated<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>,
                                         on root: Root,
                                         duration: TimeInterval = 0.3) -> AnyCancellable where Failure == Never
    {
       sink { [weak root] value in
           UIView.animate(withDuration: duration) {
               root?[keyPath: keyPath] = value
           } completion: { _ in
               root?[keyPath: keyPath] = value
           }
       }
    }
    
}
