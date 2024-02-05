//
//  HomeViewModel.swift
//  Mystake
//
//  Created by Vladko on 17.01.2024.
//

import Combine

final class HomeViewModel: ViewModel {
    
    // MARK: - Outputs
    
    /// On show game
    let onShowGame = PassthroughSubject<Game, Never>()
    
    /// Delay
    private var coinsModel = CurrentValueSubject<HomeCoinsModel, Never>(.init())
    var coinsModelDriver: Driver<HomeCoinsModel, Never> { coinsModel.asDriver() }
    
    /// Fortune wheel model
    private var fortuneModel = CurrentValueSubject<HomeGameModel, Never>(.init(game: .fortuneWheel))
    var fortuneModelDriver: Driver<HomeGameModel, Never> { fortuneModel.asDriver() }
    
    /// Mines model
    private var minesModel = CurrentValueSubject<HomeGameModel, Never>(.init(game: .mines))
    var minesModelDriver: Driver<HomeGameModel, Never> { minesModel.asDriver() }
    
    /// Cups model
    private var cupsModel = CurrentValueSubject<HomeGameModel, Never>(.init(game: .cups))
    var cupsModelDriver: Driver<HomeGameModel, Never> { cupsModel.asDriver() }
    
    /// Luck model
    private var luckModel = CurrentValueSubject<HomeGameModel, Never>(.init(game: .luckCatcher))
    var luckModelDriver: Driver<HomeGameModel, Never> { luckModel.asDriver() }
    
    
    // MARK: - Initialization
    
    /// Bind actions
    override func bindActions() {
        super.bindActions()
        
        Publishers.Merge4(
            fortuneModel.value.onSelect,
            minesModel.value.onSelect,
            cupsModel.value.onSelect,
            luckModel.value.onSelect
        )
        .assign(value: onShowGame)
        .store(in: &bag)
    }
    
}
