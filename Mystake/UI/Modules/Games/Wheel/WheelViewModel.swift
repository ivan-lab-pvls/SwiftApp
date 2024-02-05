//
//  WheelViewModel.swift
//  Mystake
//
//  Created by Vladko on 21.01.2024.
//

import Combine

final class WheelViewModel: ViewModel {
    
    // MARK: - Inputs
    
    /// On start
    let onStart = PassthroughSubject<Void, Never>()
    
    
    // MARK: - Outputs
    
    /// On result reply
    let onResultReply = PassthroughSubject<(Double, Double), Never>()
    
    
    /// Angle
    private var angle = CurrentValueSubject<Double, Never>(0)
    var angleDriver: Driver<Double, Never> { angle.asDriver() }
    
    /// Stepper
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
    private let gameProvider = WheelGameProvider()
    
    
    // MARK: - Initialization
    
    override func bindActions() {
        super.bindActions()
        
        onStart
            .withLatestFrom(stepperModel.value.valueDriver)
            .map { $0.1 }
            .sink(gameProvider.start)
            .store(in: &bag)
        
        gameProvider.onResult
            .assign(value: onResultReply)
            .store(in: &bag)
    }
    
    /// Bind data
    override func bindData() {
        super.bindData()
        
        gameProvider.rotateAngle
            .assign(value: angle)
            .store(in: &bag)
        
        gameProvider.selectionEnabled
            .assign(value: selectionEnabled)
            .store(in: &bag)
        
        gameProvider.startEnabled
            .assign(value: startEnabled)
            .store(in: &bag)
    }
    
}

