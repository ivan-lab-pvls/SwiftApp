//
//  BalanceViewModel.swift
//  Mystake
//
//  Created by Vladko on 17.01.2024.
//

import Foundation
import Combine

final class BalanceViewModel: ViewModel {
    
    // MARK: - Outputs
    
    /// Balance
    private let balance = CurrentValueSubject<String, Never>("")
    var balanceDriver: Driver<String, Never> { balance.asDriver() }
    
    
    // MARK: - Properties
    
    private let userService = UserService.shared
    
    
    // MARK: - Initialization
    
    /// Bind
    override func bindData() {
        super.bindData()
        
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = " "
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.groupingSize = 3
        
        userService.userBalance
            .map { .init(floatLiteral: $0) }
            .map { formatter.string(from: $0) ?? "" }
            .assign(value: balance)
            .store(in: &bag)
    }
    
}
