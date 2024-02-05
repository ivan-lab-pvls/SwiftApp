//
//  CatchFieldCollectionViewModel.swift
//  Mystake
//
//  Created by Vladko on 20.01.2024.
//

import UIKit
import Combine

final class CatchFieldCollectionViewModel: ViewModel {
    
    // MARK: - Outputs
    
    /// Number
    private var number = CurrentValueSubject<Int, Never>(0)
    var numberDriver: Driver<Int, Never> { number.asDriver() }
    
    /// Gradient
    private var gradient = CurrentValueSubject<Gradient, Never>(.neon)
    var gradientDriver: Driver<Gradient, Never> { gradient.asDriver() }
    
    
    // MARK: - Properties
    
    /// Field
    private let field: CurrentValueSubject<CatchField, Never>
    
    
    // MARK: - Initialization
    
    /// Intiialization
    init(field: CatchField) {
        self.field = .init(field)
        super.init()
    }
    
    /// Bind
    override func bindData() {
        super.bindData()
        
        field
            .map { $0.number }
            .assign(value: number)
            .store(in: &bag)
        
        field
            .map { $0.type.gradient }
            .assign(value: gradient)
            .store(in: &bag)
    }
    
}
