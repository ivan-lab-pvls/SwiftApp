//
//  Comparable+Extensions.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import Foundation

// MARK: - ==

public func ==<T: Comparable>(lhs: T, rhs: T?) -> Bool {
    switch (lhs,rhs) {
    case (let lhs, .some(let rhs)):
        return lhs == rhs
    default:
        return false
    }
}

public func ==<T: Comparable>(lhs: T?, rhs: T) -> Bool {
    switch (lhs,rhs) {
    case (.some(let lhs), let rhs):
        return lhs == rhs
    default:
        return false
    }
}

public func ==<T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs,rhs) {
    case (.some(let lhs), .some(let rhs)):
        return lhs == rhs
    default:
        return false
    }
}

public func ==(lhs: [String: Any], rhs: [String: Any] ) -> Bool {
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}

public func ==(lhs: [String: Any]?, rhs: [String: Any]?) -> Bool {
    switch (lhs,rhs) {
    case (.some(let lhs), .some(let rhs)):
        return lhs == rhs
    default:
        return false
    }
}

// MARK: - <

public func <<T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs,rhs) {
    case (.some(let lhs), .some(let rhs)):
        return lhs < rhs
    default:
        return false
    }
}

// MARK: - <=

public func <=<T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs,rhs) {
    case (.some(let lhs), .some(let rhs)):
        return lhs <= rhs
    default:
        return false
    }
}


// MARK: - >=

public func >=<T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs,rhs) {
    case (.some(let lhs), .some(let rhs)):
        return lhs >= rhs
    default:
        return false
    }
}

// MARK: - >

public func ><T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs,rhs) {
    case (.some(let lhs), .some(let rhs)):
        return lhs > rhs
    default:
        return false
    }
}
