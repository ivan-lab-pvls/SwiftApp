//
//  AlertViewModel.swift
//  Mystake
//
//  Created by Vladko on 19.01.2024.
//

import UIKit
import Combine

final class AlertViewModel: ViewModel {
    
    // MARK: - Outputs
    
    /// Title
    private let title = CurrentValueSubject<String?, Never>(nil)
    var titleDriver: Driver<String?, Never> { title.asDriver() }
    
    /// Icon
    private let icon = CurrentValueSubject<UIImage?, Never>(nil)
    var iconDriver: Driver<UIImage?, Never> { icon.asDriver() }
    
    /// Shadow
    private let shadow = CurrentValueSubject<UIColor, Never>(.clear)
    var shadowDriver: Driver<UIColor, Never> { shadow.asDriver() }
    
    /// Amount
    private let amount = CurrentValueSubject<Double?, Never>(nil)
    var amountDriver: Driver<Double?, Never> { amount.asDriver() }
    
    
    // MARK: - Properties
    
    /// Type
    private let type: CurrentValueSubject<AlertType, Never>
    
    
    // MARK: - Initialization
    
    /// Intialization
    init(type: AlertType) {
        self.type = .init(type)
        super.init()
    }
    
    /// Bind data
    override func bindData() {
        super.bindData()
        
        type
            .map { $0.title }
            .assign(value: title)
            .store(in: &bag)
        
        type
            .map { $0.image }
            .assign(value: icon)
            .store(in: &bag)
        
        type
            .map { $0.shadow }
            .assign(value: shadow)
            .store(in: &bag)
        
        type
            .map { $0.amount }
            .assign(value: amount)
            .store(in: &bag)
    }
    
}

