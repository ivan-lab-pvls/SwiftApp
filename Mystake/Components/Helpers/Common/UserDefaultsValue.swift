//
//  UserDefaultsValue.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import Foundation

@propertyWrapper struct UserDefaultsValue<Value> {
    
    /// Value
    var wrappedValue: Value {
        get {
            let value = storage.value(forKey: key) as? Value
            return value ?? defaultValue
        }
        set {
            storage.setValue(newValue, forKey: key)
        }
    }
    
    /// Default value
    private let defaultValue: Value
    
    /// Key
    private let key: String
    
    /// Storage
    private var storage: UserDefaults = .standard
    
    
    /// Initialization
    init(value: Value,
         key: String,
         storage: UserDefaults = .standard)
    {
        self.defaultValue = value
        self.key = key
        self.storage = storage
    }
    
}

