//
//  HomeCoinsModel.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import Combine

final class HomeCoinsModel: ViewModel {
    
    // MARK: - Inputs
    
    /// On coins
    let onCoins = PassthroughSubject<Void, Never>()
    
    
    // MARK: - Outputs
    
    /// Delay
    private var delay = CurrentValueSubject<String?, Never>(nil)
    var delayDriver: Driver<String?, Never> { delay.asDriver() }
    
    
    // MARK: - Properties
    
    /// User service
    private let userService = UserService.shared
    
    
    // MARK: - Initialization
    
    /// Bind actions
    override func bindActions() {
        super.bindActions()
        
        onCoins
            .sink(userService.getFreeCoins)
            .store(in: &bag)
    }
    
    /// Bind data
    override func bindData() {
        super.bindData()
        
        userService.freeCoinsDelay
            .sink { [weak self] in
                self?.setupDelay($0)
            }.store(in: &bag)
    }
    
}

extension HomeCoinsModel {
    
    /// Setup delay
    private func setupDelay(_ delay: Double) {
        if delay == 0 {
            self.delay.send(nil)
        } else {
            let hours = Int(delay / 3600)
            let minutes = Int((delay.truncatingRemainder(dividingBy: 3600)) / 60)
            let seconds = Int(delay.truncatingRemainder(dividingBy: 60))
            
            let string = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            self.delay.send(string)
        }
    }
    
}
