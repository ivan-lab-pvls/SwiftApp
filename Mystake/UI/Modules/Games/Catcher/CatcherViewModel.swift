//
//  CatcherViewModel.swift
//  Mystake
//
//  Created by Vladko on 20.01.2024.
//

import Combine

final class CatcherViewModel: ViewModel {
    
    // MARK: - Inputs
    
    /// On start
    let onStart = PassthroughSubject<Void, Never>()
    
    /// On select
    let onSelect = PassthroughSubject<Int, Never>()
    
    
    // MARK: - Outputs
    
    /// On result reply
    let onResultReply = PassthroughSubject<(Double, Double), Never>()
    
    
    /// Rows
    private var rows = CurrentValueSubject<[CatchFieldCollectionViewModel], Never>([])
    var rowsDriver: Driver<[CatchFieldCollectionViewModel], Never> { rows.asDriver() }
    
    /// Mines
    private var stepperModel = CurrentValueSubject<StepperModel, Never>(.init(value: 20, step: 1, minValue: 1))
    var stepperModelDriver: Driver<StepperModel, Never> { stepperModel.asDriver() }
    
    /// Selection enabled
    private var selectionEnabled = CurrentValueSubject<Bool, Never>(true)
    var selectionEnabledDriver: Driver<Bool, Never> { selectionEnabled.asDriver() }
    
    /// Start enabled
    private var startEnabled = CurrentValueSubject<Bool, Never>(false)
    var startEnabledDriver: Driver<Bool, Never> { startEnabled.asDriver() }
    
    
    // MARK: - Properties
    
    /// Game provider
    private let gameProvider = CatchGameProvider()
    
    
    // MARK: - Initialization
    
    override func bindActions() {
        super.bindActions()
        
        onStart
            .withLatestFrom(stepperModel.value.valueDriver)
            .map { $0.1 }
            .sink(gameProvider.start)
            .store(in: &bag)
        
        onSelect
            .sink(gameProvider.select)
            .store(in: &bag)
        
        gameProvider.onResult
            .assign(value: onResultReply)
            .store(in: &bag)
    }
    
    /// Bind data
    override func bindData() {
        super.bindData()
        
        gameProvider.fields
            .map { $0.map { .init(field: $0) } }
            .assign(value: rows)
            .store(in: &bag)
        
        gameProvider.selectionEnabled
            .assign(value: selectionEnabled)
            .store(in: &bag)
        
        gameProvider.startEnabled
            .assign(value: startEnabled)
            .store(in: &bag)
    }
    
}
