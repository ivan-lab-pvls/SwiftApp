//
//  MinesGameProvider.swift
//  Mystake
//
//  Created by Vladko on 20.01.2024.
//

import Foundation
import Combine

final class MinesGameProvider: NSObject {
    
    // MARK: - Properties
    
    /// Bag
    private var bag = Set<AnyCancellable>()
    
    /// User service
    private var userService: UserService {
        UserService.shared
    }
    
    
    // MARK: - Subjects
    
    /// Fields
    private let fieldsSubject = CurrentValueSubject<[MineField], Never>([])
    var fields: Driver<[MineField], Never> { fieldsSubject.asDriver() }
    
    /// Playing
    private let playingSubject = CurrentValueSubject<Bool, Never>(false)
    var playing: Driver<Bool, Never> { playingSubject.asDriver() }
    
    /// Cherries
    private let cherriesSubject = CurrentValueSubject<Int, Never>(10)
    var cherries: Driver<Int, Never> { cherriesSubject.asDriver() }
    
    /// Mines
    private let minesSubject = CurrentValueSubject<Int, Never>(10)
    var mines: Driver<Int, Never> { minesSubject.asDriver() }
    
    /// Bet
    private let betSubject = CurrentValueSubject<Double, Never>(0)
    var bet: Driver<Double, Never> { betSubject.asDriver() }
    
    /// Amount
    private let amountSubject = CurrentValueSubject<Double, Never>(0)
    var amount: Driver<Double, Never> { amountSubject.asDriver() }
    
    
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
        fields
            .map { $0.filter { $0.showed && $0.type == .cherry } }
            .map { 10 - $0.count }
            .assign(value: cherriesSubject)
            .store(in: &bag)
        
        fields
            .map { $0.filter { $0.showed && $0.type == .mine } }
            .map { 3 - $0.count }
            .assign(value: minesSubject)
            .store(in: &bag)
        
        Publishers.CombineLatest(cherries, bet)
            .map { $0.1 + $0.1 * (Double(10 - $0.0) * 0.2) }
            .assign(value: amountSubject)
            .store(in: &bag)
    }
    
}

// MARK: - Public actions
extension MinesGameProvider {
    
    /// Start
    func start(bet: Double) {
        setupFields()
        betSubject.send(bet)
        playingSubject.send(true)
    }
    
    /// Cash out
    func cashOut() {
        handleSuccess()
    }
    
    /// Select
    func select(_ index: Int) {
        var fields = fieldsSubject.value
        fields[index].showed = true
        fieldsSubject.value = fields
        
        switch fields[index].type {
        case .cherry where fields.filter({ $0.type == .cherry && !$0.showed }).isEmpty:
            handleSuccess()
        case .mine:
            handleFailure()
        default:
            break
        }
    }
    
}

// MARK: - Private actions
extension MinesGameProvider {
    
    /// Handle success
    private func handleSuccess() {
        let bet = bet.value
        let cherries = fields.value.filter({ $0.type == .cherry && $0.showed }).count
        let amount = bet + bet * (Double(cherries) * 0.2)
        userService.updateUserBalance(changeBy: amount)
        playingSubject.send(false)
        onSuccessSubject.send(amount)
    }
    
    /// Handle failure
    private func handleFailure() {
        let bet = bet.value
        userService.updateUserBalance(changeBy: -bet)
        playingSubject.send(false)
        onFailureSubject.send(bet)
    }
    
    /// Setup fields
    private func setupFields() {
        var fields = Array(repeating: MineField(type: .empty, showed: false), count: 25)
        
        var cherries = Array(repeating: MineField(type: .cherry, showed: false), count: 10)
        while !cherries.isEmpty {
            let cherry = cherries.first!
            let index = Int.random(in: 0..<25)
            if fields[index].type == .empty {
                fields[index] = cherry
                cherries.removeFirst()
            }
        }
        
        var mines = Array(repeating: MineField(type: .mine, showed: false), count: 3)
        while !mines.isEmpty {
            let mine = mines.first!
            let index = Int.random(in: 0..<25)
            if fields[index].type == .empty {
                fields[index] = mine
                mines.removeFirst()
            }
        }
        
        self.fieldsSubject.send(fields)
    }
    
}
