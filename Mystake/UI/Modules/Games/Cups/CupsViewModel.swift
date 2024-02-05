//
//  CupsViewModel.swift
//  Mystake
//
//  Created by Vladko on 20.01.2024.
//

import Combine

final class CupsViewModel: ViewModel {
    
    // MARK: - Inputs
    
    /// On start
    let onStart = PassthroughSubject<Void, Never>()
    
    
    // MARK: - Outputs
    
    /// On success reply
    let onSuccessReply = PassthroughSubject<Double, Never>()
    
    /// On failure reply
    let onFailureReply = PassthroughSubject<Double, Never>()
    
    
    /// Rows
    private var rows = CurrentValueSubject<[CupFieldViewModel], Never>([])
    var rowsDriver: Driver<[CupFieldViewModel], Never> { rows.asDriver() }
    
    /// Stepper
    private var stepperModel = CurrentValueSubject<StepperModel, Never>(.init(value: 20, step: 1, minValue: 1))
    var stepperModelDriver: Driver<StepperModel, Never> { stepperModel.asDriver() }
    
    /// Cup selection model
    private var cupSelectionModel = CurrentValueSubject<CupSelectionViewModel, Never>(.init())
    var cupSelectionModelDriver: Driver<CupSelectionViewModel, Never> { cupSelectionModel.asDriver() }
    
    
    /// Selection enabled
    private var selectionEnabled = CurrentValueSubject<Bool, Never>(true)
    var selectionEnabledDriver: Driver<Bool, Never> { selectionEnabled.asDriver() }
    
    /// Start enabled
    private var startEnabled = CurrentValueSubject<Bool, Never>(false)
    var startEnabledDriver: Driver<Bool, Never> { startEnabled.asDriver() }
    
    
    // MARK: - Properties
    
    /// Game provider
    private let gameProvider = CupsGameProvider()
    
    
    // MARK: - Initialization
    
    override func bindActions() {
        super.bindActions()
        
        onStart
            .withLatestFrom(stepperModel.value.valueDriver)
            .map { $0.1 }
            .sink(gameProvider.start)
            .store(in: &bag)
        
        cupSelectionModel.value.onSelect
            .sink(gameProvider.select)
            .store(in: &bag)
        
        gameProvider.onSuccess
            .assign(value: onSuccessReply)
            .store(in: &bag)
        
        gameProvider.onFailure
            .assign(value: onFailureReply)
            .store(in: &bag)
    }
    
    /// Bind data
    override func bindData() {
        super.bindData()
        
        gameProvider.fields
            .map { $0.map { .init(field: $0) } }
            .assign(value: rows)
            .store(in: &bag)
        
        gameProvider.selectedIndex
            .assign(value: cupSelectionModel.value.index)
            .store(in: &bag)
        
        gameProvider.selectionEnabled
            .assign(value: selectionEnabled)
            .store(in: &bag)
        
        gameProvider.startEnabled
            .assign(value: startEnabled)
            .store(in: &bag)
    }
    
}
