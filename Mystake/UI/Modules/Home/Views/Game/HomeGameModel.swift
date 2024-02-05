//
//  HomeGameModel.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import UIKit
import Combine

final class HomeGameModel: ViewModel {
    
    // MARK: - Inputs
    
    /// On select
    let onSelectCommand = PassthroughSubject<Void, Never>()
    
    // MARK: - Inputs
    
    /// On select
    let onSelect = PassthroughSubject<Game, Never>()
    
    
    // MARK: - Outputs
    
    /// Poster
    private var poster = CurrentValueSubject<UIImage?, Never>(nil)
    var posterDriver: Driver<UIImage?, Never> { poster.asDriver() }
    
    /// Name
    private var name = CurrentValueSubject<String?, Never>(nil)
    var nameDriver: Driver<String?, Never> { name.asDriver() }
    
    
    // MARK: - Properties
    
    /// Game
    let game: CurrentValueSubject<Game, Never>
    
    
    // MARK: - Initialization
    
    init(game: Game) {
        self.game = .init(game)
        super.init()
    }
    
    /// Bind actions
    override func bindActions() {
        super.bindActions()
        
        onSelectCommand
            .withLatestFrom(game)
            .map { $0.1 }
            .assign(value: onSelect)
            .store(in: &bag)
    }
    
    /// Bind data
    override func bindData() {
        super.bindData()
        
        game
            .map { $0.poster }
            .assign(value: poster)
            .store(in: &bag)
        
        game
            .map { $0.name }
            .assign(value: name)
            .store(in: &bag)
    }
    
}
