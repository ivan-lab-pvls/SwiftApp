//
//  CatchGameProvider.swift
//  Mystake
//
//  Created by Vladko on 20.01.2024.
//

import Foundation
import Combine

final class CatchGameProvider: NSObject {
    
    // MARK: - Properties
    
    /// Bag
    private var bag = Set<AnyCancellable>()
    
    /// User service
    private var userService: UserService {
        UserService.shared
    }
    
    
    // MARK: - Subjects
    
    /// Fields
    private let fieldsSubject = CurrentValueSubject<[CatchField], Never>([])
    var fields: Driver<[CatchField], Never> { fieldsSubject.asDriver() }
    
    /// Selection enabled
    private let selectionEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    var selectionEnabled: Driver<Bool, Never> { selectionEnabledSubject.asDriver() }
    
    /// Start enabled
    private let startEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    var startEnabled: Driver<Bool, Never> { startEnabledSubject.asDriver() }
    
    
    /// On result
    private let onResultSubject = PassthroughSubject<(Double, Double), Never>()
    var onResult: AnyPublisher<(Double, Double), Never> { onResultSubject.eraseToAnyPublisher() }
    
    
    // MARK: - Initialization
    
    /// Initialization
    override init() {
        super.init()
        setupFields()
        bind()
    }
    
    /// Bind
    private func bind() {
        fields
            .map { ($0.filter({ $0.type == .success }), $0.filter({ $0.type == .failure})) }
            .map { $0.0.count == 0 && $0.1.count == 0 }
            .assign(value: selectionEnabledSubject)
            .store(in: &bag)
        
        fields
            .map { $0.filter { $0.type == .selected } }
            .map { $0.count == 3 }
            .assign(value: startEnabledSubject)
            .store(in: &bag)
    }
    
}

// MARK: - Public actions
extension CatchGameProvider {
    
    /// Start
    func start(bet: Double) {
        var fields = fieldsSubject.value
        let selectedFields = fields.filter({ $0.type == .selected })
        guard selectedFields.count == 3 else { return }
        
        var randomIndexes = [Int]()
        while randomIndexes.count != 3 {
            let index = Int.random(in: 0..<25)
            if !randomIndexes.contains(index) {
                randomIndexes.append(index)
            }
        }
        
        for i in randomIndexes {
            switch fields[i].type {
            case .empty:
                fields[i].type = .failure
            case .selected:
                fields[i].type = .success
            default:
                break
            }
        }
        
        fieldsSubject.value = fields
        
        let guessedFields = fields.filter { $0.type == .success }
        let multiplier = Double(guessedFields.count) * 2
        let amount = bet * multiplier
        handleStart(bet: bet)
        handleResult(multiplier: multiplier, amount: amount)
    }
    
    /// Select
    func select(_ index: Int) {
        var fields = fieldsSubject.value
        let field = fields[index]
        let selectedFields = fields.filter({ $0.type == .selected })
        
        if field.type == .selected {
            fields[index].type = .empty
            fieldsSubject.value = fields
        } else if selectedFields.count < 3 {
            fields[index].type = .selected
            fieldsSubject.value = fields
        }
    }
    
}

// MARK: - Private actions
extension CatchGameProvider {
    
    /// Handle start
    private func handleStart(bet: Double) {
        userService.updateUserBalance(changeBy: -bet)
    }
    
    /// Handle result
    private func handleResult(multiplier: Double, amount: Double) {
        userService.updateUserBalance(changeBy: amount)
        onResultSubject.send((multiplier, amount))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            self?.setupFields()
        })
    }
    
    /// Setup fields
    private func setupFields() {
        var fields = [CatchField]()
        
        for i in 0..<25 {
            fields.append(.init(type: .empty, number: i))
        }
        
        self.fieldsSubject.send(fields)
    }
    
}

