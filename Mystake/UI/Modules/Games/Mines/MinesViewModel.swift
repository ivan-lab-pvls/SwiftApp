//
//  MinesViewModel.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import Combine

final class MinesViewModel: ViewModel {
    
    // MARK: - Inputs
    
    /// On start
    let onStart = PassthroughSubject<Void, Never>()
    
    /// On cash out
    let onCashOut = PassthroughSubject<Void, Never>()
    
    /// On select
    let onSelect = PassthroughSubject<Int, Never>()
    
    
    // MARK: - Outputs
    
    /// On success reply
    let onSuccessReply = PassthroughSubject<Double, Never>()
    
    /// On failure reply
    let onFailureReply = PassthroughSubject<Void, Never>()
    
    
    /// Rows
    private var rows = CurrentValueSubject<[MineFieldCollectionViewModel], Never>([])
    var rowsDriver: Driver<[MineFieldCollectionViewModel], Never> { rows.asDriver() }
    
    /// Mines
    private var stepperModel = CurrentValueSubject<StepperModel, Never>(.init(value: 20, step: 1, minValue: 1))
    var stepperModelDriver: Driver<StepperModel, Never> { stepperModel.asDriver() }
    
    
    /// Cherries
    private var cherries = CurrentValueSubject<Int, Never>(9)
    var cherriesDriver: Driver<Int, Never> { cherries.asDriver() }
    
    /// Mines
    private var mines = CurrentValueSubject<Int, Never>(2)
    var minesDriver: Driver<Int, Never> { mines.asDriver() }
    
    /// Amount
    private var amount = CurrentValueSubject<Double, Never>(0)
    var amountDriver: Driver<Double, Never> { amount.asDriver() }
    
    
    /// Stepper enabled
    private var stepperEnabled = CurrentValueSubject<Bool, Never>(true)
    var stepperEnabledDriver: Driver<Bool, Never> { stepperEnabled.asDriver() }
    
    /// Fields enabled
    private var fieldsEnabled = CurrentValueSubject<Bool, Never>(false)
    var fieldsEnabledDriver: Driver<Bool, Never> { fieldsEnabled.asDriver() }
    
    /// Start enabled
    private var startEnabled = CurrentValueSubject<Bool, Never>(true)
    var startEnabledDriver: Driver<Bool, Never> { startEnabled.asDriver() }
    
    /// Cash out enabled
    private var cashOutEnabled = CurrentValueSubject<Bool, Never>(false)
    var cashOutEnabledDriver: Driver<Bool, Never> { cashOutEnabled.asDriver() }
    
    
    // MARK: - Properties
    
    /// Game provider
    private let gameProvider = MinesGameProvider()
    
    
    // MARK: - Initialization
    
    override func bindActions() {
        super.bindActions()
        
        onStart
            .withLatestFrom(stepperModel.value.valueDriver)
            .map { $0.1 }
            .sink(gameProvider.start)
            .store(in: &bag)
        
        onCashOut
            .sink(gameProvider.cashOut)
            .store(in: &bag)
        
        onSelect
            .sink(gameProvider.select)
            .store(in: &bag)
        
        gameProvider.onSuccess
            .assign(value: onSuccessReply)
            .store(in: &bag)
        
        gameProvider.onFailure
            .mapVoid()
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
        
        gameProvider.playing
            .map { !$0 }
            .assign(value: stepperEnabled)
            .store(in: &bag)
        
        gameProvider.playing
            .assign(value: fieldsEnabled)
            .store(in: &bag)
        
        gameProvider.playing
            .map { !$0 }
            .assign(value: startEnabled)
            .store(in: &bag)
        
        gameProvider.playing
            .assign(value: cashOutEnabled)
            .store(in: &bag)
        
        gameProvider.cherries
            .assign(value: cherries)
            .store(in: &bag)
        
        gameProvider.mines
            .assign(value: mines)
            .store(in: &bag)
        
        gameProvider.amount
            .assign(value: amount)
            .store(in: &bag)
    }
    
}
