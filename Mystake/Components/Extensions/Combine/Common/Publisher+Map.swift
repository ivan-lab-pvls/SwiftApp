//
//  Publisher+Map.swift
//  Mystake
//
//  Created by Vladko on 07.12.2023.
//

import Foundation
import Combine

// MARK: - Map
extension Publisher {
    
    /// Map optional
    func mapOptional() -> AnyPublisher<Self.Output?, Self.Failure> {
        self
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    /// Map void
    func mapVoid() -> AnyPublisher<Void, Self.Failure> {
        self
            .map { _ in Void() }
            .eraseToAnyPublisher()
    }
    
}

// MARK: - Just
extension Publisher {
 
    /// Just to value
    func just<T: Any>(_ value: T) -> AnyPublisher<T, Never> {
        self
            .map { _ in value }
            .replaceError(with: value)
            .flatMap { _ in Just(value) }
            .eraseToAnyPublisher()
    }
    
}

// MARK: - Other
extension Publisher {
    
    /// With latest from publisher
    func withLatestFrom<P: Publisher>(_ publisher: P) -> AnyPublisher<(Self.Output, P.Output), Failure> where Self.Failure == P.Failure {
        let publisher = publisher
            .mapOptional()
            .map { (value: $0, ()) }

        return map { (value: $0, token: UUID()) }
            .combineLatest(publisher)
            .removeDuplicates(by: { (old, new) in
                let lhs = old.0, rhs = new.0
                return lhs.token == rhs.token
            })
            .map { ($0.value, $1.value) }
            .compactMap { (left, right) in
                right.map { (left, $0) }
            }
            .eraseToAnyPublisher()
    }
    
    /// With latest from publisher
    func withLatest<Root: AnyObject, Value: Any>(from keyPath: KeyPath<Root, Value>,
                                                 on root: Root?) -> AnyPublisher<(Self.Output, Value?), Self.Failure>
    {
        map { [weak root] in
            return ($0, root?[keyPath: keyPath] as? Value)
        }.eraseToAnyPublisher()
    }
    
    /// Materialize
    func materialize() -> AnyPublisher<(element: Self.Output?, error: Self.Failure?), Never> {
        self
            .map { ($0, nil) }
            .catch { CurrentValueSubject<(element: Self.Output?, error: Self.Failure?), Never>((nil, $0)) }
            .eraseToAnyPublisher()
    }
    
}

