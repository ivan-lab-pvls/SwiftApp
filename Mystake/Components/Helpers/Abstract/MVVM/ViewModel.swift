//
//  ViewModel.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import Foundation
import Combine

class ViewModel: NSObject {
    
    // MARK: - Output
    
    /// Cancellable bag
    internal var bag = Set<AnyCancellable>()
    
    
    // MARK: - Initialization
    
    /// Initialization
    override init() {
        super.init()
        bind()
    }
    
    /// Model binding
    func bind() {
        bag.removeAll()
        bindData()
        bindActions()
        bindDependencies()
    }
    
    /// Model data binding
    func bindData() {}
    
    /// Model actions binding
    func bindActions() {}
    
    /// Model dependencies binding
    func bindDependencies() {}
    
}
