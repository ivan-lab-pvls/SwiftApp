//
//  RulesViewModel.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import Foundation
import Combine

final class RulesViewModel: ViewModel {
    
    // MARK: - Outputs
    
    /// Text
    private let text = CurrentValueSubject<String?, Never>(nil)
    var textDriver: Driver<String?, Never> { text.asDriver() }
    
    
    // MARK: - Properties
    
    /// Game
    private let game: CurrentValueSubject<Game, Never>
    
    
    // MARK: - Initialization
    
    /// Initialization
    init(game: Game) {
        self.game = .init(game)
        super.init()
    }
    
    /// Bind data
    override func bindData() {
        super.bindData()
        
        game
            .map { $0.rules }
            .assign(value: text)
            .store(in: &bag)
    }
    
}
