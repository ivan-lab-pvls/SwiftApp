//
//  UserService.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit
import Combine

final class UserService: NSObject {
    
    // MARK: -
    
    /// Setting service
    static let shared = UserService()
    
    /// Bag
    private var bag = Set<AnyCancellable>()
    
    
    /// Settings service
    private var settingsService: SettingsService {
        SettingsService.shared
    }
    
    
    // MARK: - Publishers
    
    /// User image
    private let userImageSubject = CurrentValueSubject<UIImage?, Never>(nil)
    var userImage: Driver<UIImage?, Never> { userImageSubject.asDriver() }
    
    /// User balance
    private let userBalanceSubject = CurrentValueSubject<Double, Never>(1000)
    var userBalance: Driver<Double, Never> { userBalanceSubject.asDriver() }
    
    /// Free coins delay
    private let freeCoinsDelaySubject = CurrentValueSubject<Double, Never>(0)
    var freeCoinsDelay: Driver<Double, Never> { freeCoinsDelaySubject.asDriver() }
    
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
        bind()
        setupFreeCoinsTimer()
    }
    
    /// Bind
    private func bind() {
        settingsService
            .publisher(for: \.userImage)
            .map { .init(base64: $0) }
            .assign(value: userImageSubject)
            .store(in: &bag)
        
        settingsService
            .publisher(for: \.userBalance)
            .assign(value: userBalanceSubject)
            .store(in: &bag)
    }
    
}

// MARK: - Setups
extension UserService {
    
    /// Setup free coins timer
    private func setupFreeCoinsTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [unowned self] _ in
            let date = settingsService.lastFreeCoinsDate
            let delay = max(date.timeIntervalSinceNow, 0)
            freeCoinsDelaySubject.send(delay)
        }
    }
    
}

// MARK: - Public actions
extension UserService {
    
    /// Update user image
    func updateUserImage(_ image: UIImage?) {
        settingsService.userImage = image?.base64() ?? ""
    }
    
    /// Update user balance
    func updateUserBalance(changeBy value: Double) {
        settingsService.userBalance += value
    }
    
    /// Get free coins
    func getFreeCoins() {
        settingsService.lastFreeCoinsDate = Date(timeIntervalSinceNow: 60 * 60 * 24)
        settingsService.userBalance += 150
    }
    
}
