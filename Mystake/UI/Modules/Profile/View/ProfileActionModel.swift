//
//  ProfileActionModel.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import UIKit
import Combine

final class ProfileActionModel: ViewModel {
    
    // MARK: - Inputs
    
    /// On select
    let onSelectCommand = PassthroughSubject<Void, Never>()
    
    
    // MARK: - Inputs
    
    /// On select
    let onSelect = PassthroughSubject<Void, Never>()
    
    
    // MARK: - Outputs
    
    /// Title
    private var title = CurrentValueSubject<String?, Never>(nil)
    var titleDriver: Driver<String?, Never> { title.asDriver() }
    
    
    // MARK: - Initialization
    
    /// Intiialization
    init(title: String?) {
        super.init()
        self.title.send(title)
    }
    
    /// Bind actions
    override func bindActions() {
        super.bindActions()
        
        onSelectCommand
            .assign(value: onSelect)
            .store(in: &bag)
    }
    
}
