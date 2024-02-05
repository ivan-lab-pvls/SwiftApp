//
//  CupsGameProvider.swift
//  Mystake
//
//  Created by Vladko on 21.01.2024.
//

import Foundation
import Combine

final class CupsGameProvider: NSObject {
    
    // MARK: - Properties
    
    /// Bag
    private var bag = Set<AnyCancellable>()
    
    /// User service
    private var userService: UserService {
        UserService.shared
    }
    
    
    // MARK: - Subjects
    
    /// Fields
    private let fieldsSubject = CurrentValueSubject<[CupField], Never>([])
    var fields: Driver<[CupField], Never> { fieldsSubject.asDriver() }
    
    /// Selected index
    private let selectedIndexSubject = CurrentValueSubject<Int?, Never>(nil)
    var selectedIndex: Driver<Int?, Never> { selectedIndexSubject.asDriver() }
    
    /// Playing
    private let playingSubject = CurrentValueSubject<Bool, Never>(false)
    var playing: Driver<Bool, Never> { playingSubject.asDriver() }
    
    
    /// Selection enabled
    private let selectionEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    var selectionEnabled: Driver<Bool, Never> { selectionEnabledSubject.asDriver() }
    
    /// Start enabled
    private let startEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    var startEnabled: Driver<Bool, Never> { startEnabledSubject.asDriver() }
    
    
    /// On success
    private let onSuccessSubject = PassthroughSubject<Double, Never>()
    var onSuccess: AnyPublisher<Double, Never> { onSuccessSubject.eraseToAnyPublisher() }
    
    /// On failure
    private let onFailureSubject = PassthroughSubject<Double, Never>()
    var onFailure: AnyPublisher<Double, Never> { onFailureSubject.eraseToAnyPublisher() }
    
    
    // MARK: - Initialization
    
    /// Initialization
    override init() {
        super.init()
        setupFields()
        bind()
    }
    
    /// Bind
    private func bind() {
        playing
            .map { !$0 }
            .assign(value: selectionEnabledSubject)
            .store(in: &bag)
        
        selectedIndex
            .map { $0 != nil }
            .assign(value: startEnabledSubject)
            .store(in: &bag)
    }
    
}

// MARK: - Public actions
extension CupsGameProvider {
    
    /// Start
    func start(bet: Double) {
        guard let selectedIndex = selectedIndex.value else { return }
        let fields = fieldsSubject.value
        let selectedField = fields[selectedIndex]
        
        fieldsSubject.value[selectedIndex].showed = true
        playingSubject.send(true)
        
        if selectedField.ball {
            handleSuccess(bet)
        } else {
            handleFailure(bet)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            self?.setupFields()
            self?.selectedIndexSubject.send(nil)
            self?.playingSubject.send(false)
        })
    }
    
    /// Select
    func select(_ index: Int) {
        let index = selectedIndexSubject.value == index ? nil : index
        selectedIndexSubject.send(index)
    }
    
}

// MARK: - Private actions
extension CupsGameProvider {
    
    /// Handle success
    private func handleSuccess(_ bet: Double) {
        userService.updateUserBalance(changeBy: bet)
        playingSubject.send(false)
        onSuccessSubject.send(bet * 2)
    }
    
    /// Handle failure
    private func handleFailure(_ bet: Double) {
        userService.updateUserBalance(changeBy: -bet)
        playingSubject.send(false)
        onFailureSubject.send(-bet)
    }
    
    /// Setup fields
    private func setupFields() {
        let ballIndex = Int.random(in: 0...4)
        
        let fields = CupFieldType.allCases
            .enumerated()
            .map { CupField(type: $0.element, ball: $0.offset == ballIndex, showed: false) }
        
        fieldsSubject.send(fields)
    }
    
}
