//
//  StepperModel.swift
//  Mystake
//
//  Created by Vladko on 19.01.2024.
//

import Foundation
import Combine

final class StepperModel: ViewModel {
    
    // MARK: - Inputs
    
    /// On amount action
    let onAmount = PassthroughSubject<Int, Never>()
    
    /// On reduce action
    let onReduce = PassthroughSubject<Void, Never>()
    
    /// On increase action
    let onIncrease = PassthroughSubject<Void, Never>()
    
    /// On long reduce action
    let onLongReduce = PassthroughSubject<Void, Never>()
    
    /// On long increase action
    let onLongIncrease = PassthroughSubject<Void, Never>()
    
    
    // MARK: - Outputs
    
    /// Text
    private let text = CurrentValueSubject<String, Never>("")
    var textDriver: Driver<String, Never> { text.asDriver() }
    
    /// Reduse enabled
    private let reduseEnabled = CurrentValueSubject<Bool, Never>(true)
    var reduseEnabledDriver: Driver<Bool, Never> { reduseEnabled.asDriver() }
    
    /// Increase enabled
    private let increaseEnabled = CurrentValueSubject<Bool, Never>(true)
    var increaseEnabledDriver: Driver<Bool, Never> { increaseEnabled.asDriver() }
    
    
    // MARK: - Properties
    
    /// Value
    private let value = CurrentValueSubject<Double, Never>(1)
    var valueDriver: Driver<Double, Never> { value.asDriver() }
    
    
    // MARK: - Private properties
    
    /// Text value
    private let textValue = CurrentValueSubject<String, Never>("")
    

    /// Step value
    private let step: Double
    
    /// Max value
    private let maxValue: Double?
    
    /// Min value
    private let minValue: Double?
    
    /// Reduce timer
    private var reduceTimer: Timer?
    
    /// Increase timer
    private var increaseTimer: Timer?
    
    
    // MARK: - Initialization
    
    /// Initialization
    init(value: Double = 1,
         step: Double = 1,
         maxValue: Double? = nil,
         minValue: Double = 0)
    {
        self.step = step
        self.maxValue = maxValue
        self.minValue = minValue
        super.init()
    }
    
    
    
    // MARK: - Initialization
    
    /// Bind actions
    override func bindActions() {
        let step = step
        let minValue = minValue
        let maxValue = maxValue
        
        onAmount
            .withLatestFrom(value)
            .compactMap { $0.1 + Double($0.0) }
            .map { min($0, maxValue ?? $0) }
            .assign(value: value)
            .store(in: &bag)
        
        onReduce
            .withLatestFrom(value)
            .compactMap { $0.1 - step }
            .map { max($0, minValue ?? $0) }
            .assign(value: value)
            .store(in: &bag)
        
        onIncrease
            .withLatestFrom(value)
            .compactMap { $0.1 + step }
            .map { min($0, maxValue ?? $0) }
            .assign(value: value)
            .store(in: &bag)
        
        onLongReduce
            .sink { [weak self] in
                self?.setupReduceTimer()
            }.store(in: &bag)
        
        onLongIncrease
            .sink { [weak self] in
                self?.setupIncreaseTimer()
            }.store(in: &bag)
    }
    
    /// Bind data
    override func bindData() {
        let minValue = minValue
        let maxValue = maxValue
        
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 0
        nf.decimalSeparator = "."
        
        value
            .map { .init(floatLiteral: $0) }
            .map { nf.string(from: $0) ?? "" }
            .assign(value: text)
            .store(in: &bag)
        
        value
            .map { .init(floatLiteral: $0) }
            .map { nf.string(from: $0) ?? "" }
            .assign(value: textValue)
            .store(in: &bag)
        
        value
            .map { minValue == nil ? true : minValue < $0 }
            .assign(value: reduseEnabled)
            .store(in: &bag)
        
        value
            .map { maxValue == nil ? true : maxValue > $0 }
            .assign(value: increaseEnabled)
            .store(in: &bag)
        
        value
            .map { minValue < $0 }
            .filter { !$0 }
            .sink { [weak self] _ in
                self?.reduceTimer?.invalidate()
            }.store(in: &bag)
        
        value
            .map { maxValue > $0 }
            .filter { !$0 }
            .sink { [weak self] _ in
                self?.increaseTimer?.invalidate()
            }.store(in: &bag)
    }
    
    
}

// MARK: - Setups
extension StepperModel {
    
    /// Setup reduce timer
    private func setupReduceTimer() {
        if reduceTimer == nil {
            reduceTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
                self?.onReduce.send()
            }
        } else {
            reduceTimer?.invalidate()
            reduceTimer = nil
        }
    }
    
    /// Setup increase timer
    private func setupIncreaseTimer() {
        if increaseTimer == nil {
            increaseTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
                self?.onIncrease.send()
            }
        } else {
            increaseTimer?.invalidate()
            increaseTimer = nil
        }
    }
    
}


// MARK: - Public methods
extension StepperModel {
    
    /// Set value
    func setValue(_ value: Double) {
        var value = value
        value = max(value, minValue ?? value)
        value = min(value, maxValue ?? value)
        self.value.send(value)
    }
    
}

