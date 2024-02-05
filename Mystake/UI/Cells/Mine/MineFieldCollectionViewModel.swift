//
//  MineFieldCollectionViewModel.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import UIKit
import Combine

final class MineFieldCollectionViewModel: ViewModel {
    
    // MARK: - Outputs
    
    /// Image
    private var image = CurrentValueSubject<UIImage?, Never>(.init())
    var imageDriver: Driver<UIImage?, Never> { image.asDriver() }
    
    /// Gradient
    private var gradient = CurrentValueSubject<Gradient, Never>(.neon)
    var gradientDriver: Driver<Gradient, Never> { gradient.asDriver() }
    
    /// Showed
    private var showed = CurrentValueSubject<Bool, Never>(false)
    var showedDriver: Driver<Bool, Never> { showed.asDriver() }
    
    
    // MARK: - Properties
    
    /// Field
    private let field: CurrentValueSubject<MineField, Never>
    
    
    // MARK: - Initialization
    
    /// Intiialization
    init(field: MineField) {
        self.field = .init(field)
        super.init()
    }
    
    /// Bind
    override func bindData() {
        super.bindData()
        
        field
            .map { $0.type.image }
            .assign(value: image)
            .store(in: &bag)
        
        field
            .map { $0.type.gradient }
            .assign(value: gradient)
            .store(in: &bag)
        
        field
            .map { $0.showed }
            .assign(value: showed)
            .store(in: &bag)
    }
    
}
