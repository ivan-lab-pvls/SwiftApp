//
//  CupFieldViewModel.swift
//  Mystake
//
//  Created by Vladko on 21.01.2024.
//

import UIKit
import Combine

final class CupFieldViewModel: ViewModel {
    
    // MARK: - Outputs
    
    /// Image
    private var image = CurrentValueSubject<UIImage?, Never>(nil)
    var imageDriver: Driver<UIImage?, Never> { image.asDriver() }
    
    /// Ball exist
    private var ballExist = CurrentValueSubject<Bool, Never>(false)
    var ballExistDriver: Driver<Bool, Never> { ballExist.asDriver() }
    
    /// Showed
    private var showed = CurrentValueSubject<Bool, Never>(false)
    var showedDriver: Driver<Bool, Never> { showed.asDriver() }
    
    
    // MARK: - Properties
    
    /// Field
    private let field: CurrentValueSubject<CupField, Never>
    
    
    // MARK: - Initialization
    
    /// Intiialization
    init(field: CupField) {
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
            .map { $0.ball }
            .assign(value: ballExist)
            .store(in: &bag)
        
        field
            .map { $0.showed }
            .assign(value: showed)
            .store(in: &bag)
    }
    
}
