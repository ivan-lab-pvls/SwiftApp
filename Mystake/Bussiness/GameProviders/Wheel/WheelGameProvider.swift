//
//  WheelGameProvider.swift
//  Mystake
//
//  Created by Vladko on 21.01.2024.
//

import UIKit
import Combine

final class WheelGameProvider: NSObject {
    
    // MARK: - Properties
    
    /// Bag
    private var bag = Set<AnyCancellable>()
    
    /// User service
    private var userService: UserService {
        UserService.shared
    }
    
    
    // MARK: - Subjects
    
    /// Fields
    private let multipliersSubject = CurrentValueSubject<[Double: Double], Never>([:])
    var multipliers: Driver<[Double: Double], Never> { multipliersSubject.asDriver() }
    
    /// Fields
    private let rotateAngleSubject = CurrentValueSubject<Double, Never>(0)
    var rotateAngle: Driver<Double, Never> { rotateAngleSubject.asDriver() }
    
    
    /// Playing
    private let playingSubject = CurrentValueSubject<Bool, Never>(false)
    var playing: Driver<Bool, Never> { playingSubject.asDriver() }
    
    /// Selection enabled
    private let selectionEnabledSubject = CurrentValueSubject<Bool, Never>(true)
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
        setupWheel()
        bind()
    }
    
    /// Bind
    private func bind() {
        playing
            .map { !$0 }
            .assign(value: selectionEnabledSubject)
            .store(in: &bag)
        
        playing
            .map { !$0 }
            .assign(value: startEnabledSubject)
            .store(in: &bag)
    }
    
}

// MARK: - Public actions
extension WheelGameProvider {
    
    /// Start
    func start(bet: Double) {
        let item = multipliersSubject.value.randomElement()!
        let angle = item.key
        let multiplier = item.value
        playingSubject.send(true)
        handleStart(bet: bet)
        
        setupRotation(angle) { [weak self] in
            let amount = bet * multiplier
            self?.playingSubject.send(false)
            self?.handleResult(multiplier: multiplier, amount: amount)
        }
    }
    
}

// MARK: - Private actions
extension WheelGameProvider {
    
    /// Handle start
    private func handleStart(bet: Double) {
        userService.updateUserBalance(changeBy: -bet)
    }
    
    /// Handle result
    private func handleResult(multiplier: Double, amount: Double) {
        userService.updateUserBalance(changeBy: amount)
        onResultSubject.send((multiplier, amount))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            self?.setupWheel()
        })
    }
    
    /// Setup rotation
    private func setupRotation(_ angle: Double, callback: (() -> Void)?) {
        UIView.animate(withDuration: 1,delay: 0,options: .curveEaseIn) { [weak self] in
            self?.rotateAngleSubject.send(.pi)
        }
        
        UIView.animate(withDuration: 1, delay: 1, options: .curveLinear) { [weak self] in
            self?.rotateAngleSubject.send(2 * .pi)
        }
        
        UIView.animate(withDuration: 1, delay: 2, options: .curveLinear) { [weak self] in
            self?.rotateAngleSubject.send(.pi)
        }
        
        UIView.animate(withDuration: 1, delay: 3, options: .curveLinear) { [weak self] in
            self?.rotateAngleSubject.send(2 * .pi)
        }
        
        if angle > .pi {
            UIView.animate(withDuration: 1, delay: 4, options: .curveLinear) { [weak self] in
                self?.rotateAngleSubject.send(.pi)
            }
            
            UIView.animate(withDuration: 1, delay: 5, options: .curveEaseOut) { [weak self] in
                let angle = angle - Double(Int(angle / .pi) + 1) * .pi
                self?.rotateAngleSubject.send(angle)
            } completion: { _ in
                callback?()
            }
        } else {
            UIView.animate(withDuration: 1, delay: 4, options: .curveEaseOut) { [weak self] in
                self?.rotateAngleSubject.send(angle)
            } completion: { _ in
                callback?()
            }
        }
    }
    
    /// Setup wheel
    private func setupWheel() {
        rotateAngleSubject.send(0)
        multipliersSubject.value = [
            0.165: 1,
            0.495: 0,
            0.8: 3,
            1.1: 0.2,
            1.42: 1,
            1.75: 0.5,
            2.05: 2,
            2.35: 1,
            2.68: 0.5,
            3: 10,
            3.3: 0,
            3.63: 2,
            3.93: 4,
            4.23: 5,
            4.56: 0.5,
            4.89: 1,
            5.19: 0.3,
            5.5: 1,
            5.82: 2,
            6.13: 10
        ]
    }
    
}
