//
//  SettingsService.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import Foundation

final class SettingsService: NSObject {
    
    /// Setting service
    static let shared = SettingsService()
    

    /// User image
    @UserDefaultsValue(value: "", key: "user.image")
    @objc dynamic var userImage: String
    
    /// User image
    @UserDefaultsValue(value: 1000, key: "user.balance")
    @objc dynamic var userBalance: Double
    
    /// User image
    @UserDefaultsValue(value: Date(timeIntervalSince1970: 0), key: "last.free.coins.date")
    @objc dynamic var lastFreeCoinsDate: Date
    
    
    override init() {
        super.init()
        
//        if lastFreeCoinsDate == Date(timeIntervalSince1970: 0) {
//            lastFreeCoinsDate = Date(timeIntervalSinceNow: 60 * 60 * 24)
//        }
    }
    
}
