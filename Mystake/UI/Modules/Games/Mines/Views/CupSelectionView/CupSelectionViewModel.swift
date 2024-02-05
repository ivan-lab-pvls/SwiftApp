//
//  CupSelectionViewModel.swift
//  Mystake
//
//  Created by Vladko on 21.01.2024.
//

import Combine

final class CupSelectionViewModel: ViewModel {
    
    // MARK: - Inputs
    
    let onSelectCommand = PassthroughSubject<Int, Never>()
    
    
    // MARK: - Public outputs
    
    let onSelect = PassthroughSubject<Int, Never>()
    
    
    // MARK: - Outputs
    
    /// Selected index
    private let selectedIndex = CurrentValueSubject<Int?, Never>(nil)
    var selectedIndexDriver: Driver<Int?, Never> { selectedIndex.asDriver() }
    
    
    // MARK: - Properties
    
    /// Index
    let index = CurrentValueSubject<Int?, Never>(nil)
    
    
    // MARK: - Initialization
    
    /// Bind actions
    override func bindActions() {
        super.bindActions()
        
        onSelectCommand
            .assign(value: onSelect)
            .store(in: &bag)
    }
    
    /// Bind data
    override func bindData() {
        super.bindData()
        
        index
            .assign(value: selectedIndex)
            .store(in: &bag)
    }
    
}
