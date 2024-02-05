//
//  LaunchViewModel.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import Foundation
import Combine

final class LaunchViewModel: ViewModel {
    
    // MARK: - Inputs
    
    /// On did load
    let onDidLoad = PassthroughSubject<Void, Never>()
    
    
    // MARK: - Outputs
    
    /// Show dashboard
    let onShowDashboard = PassthroughSubject<Void, Never>()
    
    
    // MARK: - Properties
    
    /// Progress
    private let progress = CurrentValueSubject<Double, Never>(0)
    
    /// Settings service
    private let settingsService = SettingsService.shared
    
    
    // MARK: - Initialization
    
    /// Bind actions
    override func bindActions() {
        super.bindActions()
        
        onDidLoad
            .sink { [weak self] in
                self?.setupProgress()
            }.store(in: &bag)
    }
    
    override func bindData() {
        super.bindData()
        
        progress
            .filter { $0 >= 1 }
            .first()
            .mapVoid()
            .assign(value: onShowDashboard)
            .store(in: &bag)
    }
    
}

// MARK: - Setups
extension LaunchViewModel {
    
    /// Setup progress
    private func setupProgress() {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
            let progress = self?.progress.value ?? 1
            
            guard progress < 1 else { timer.invalidate(); return }
            self?.progress.value = min(progress + 0.01, 1)
        }
    }
    
}

