//
//  HomeViewController.swift
//  Mystake
//
//  Created by Vladko on 17.01.2024.
//

import UIKit

final class HomeViewController: ViewController {
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = false
        return sv
    }()
    
    private let coinsView: HomeCoinsView = {
        let view = HomeCoinsView()
        return view
    }()
    
    private let fortuneView: HomeGameView = {
        let view = HomeGameView()
        return view
    }()
    
    private let minesView: HomeGameView = {
        let view = HomeGameView()
        return view
    }()
    
    private let cupsView: HomeGameView = {
        let view = HomeGameView()
        return view
    }()
    
    private let luckView: HomeGameView = {
        let view = HomeGameView()
        return view
    }()
    
    
    // MARK: - Properties
    
    /// View model
    private let viewModel: HomeViewModel
    
    
    // MARK: - Initialization
    
    /// Initialization
    override init() {
        viewModel = .init()
        super.init()
    }
    
    /// Initialization with coder
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View lifecycle
    
    /// View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navigation = navigationController as? NavigationController
        navigation?.headline = "MY MINIGAMES"
    }
    
    /// Model binding
    override func bind() {
        super.bind()
        
        viewModel.onShowGame
            .sink { [weak self] in
                self?.showGame($0)
            }.store(in: &bag)
        
        viewModel.coinsModelDriver
            .sink(coinsView.bind)
            .store(in: &bag)
        
        viewModel.fortuneModelDriver
            .sink(fortuneView.bind)
            .store(in: &bag)
        
        viewModel.minesModelDriver
            .sink(minesView.bind)
            .store(in: &bag)
        
        viewModel.cupsModelDriver
            .sink(cupsView.bind)
            .store(in: &bag)
        
        viewModel.luckModelDriver
            .sink(luckView.bind)
            .store(in: &bag)
    }
    
    /// Layout setups
    override func setupLayout() {
        super.setupLayout()
        
        let scrollContainerView = UIView()
        let stackView = UIStackView(axis: .vertical, spacing: 16)
        let gamesStackView1 = UIStackView(axis: .horizontal, spacing: 16, distribution: .fillEqually)
        let gamesStackView2 = UIStackView(axis: .horizontal, spacing: 16, distribution: .fillEqually)
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainerView)
        scrollContainerView.addSubview(stackView)
        stackView.addArrangedSubviews([coinsView, gamesStackView1, gamesStackView2])
        gamesStackView1.addArrangedSubviews([fortuneView, minesView])
        gamesStackView2.addArrangedSubviews([cupsView, luckView])
        
        scrollView.snp.make { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        scrollContainerView.snp.make { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        stackView.snp.make { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(-16)
        }
        
        coinsView.snp.make { make in
            make.height.equalTo(coinsView.snp.width).multipliedBy(202.0 / 362.0)
        }
        
        gamesStackView1.snp.make { make in
            make.height.equalTo(gamesStackView1.snp.width).multipliedBy(202.0 / 362.0)
        }
        
        gamesStackView2.snp.make { make in
            make.height.equalTo(gamesStackView1.snp.width).multipliedBy(202.0 / 362.0)
        }
    }
    
}

// MARK: - Flow
extension HomeViewController {
    
    /// Show game
    private func showGame(_ game: Game) {
        switch game {
        case .fortuneWheel:
            show(WheelViewController())
        case .mines:
            show(MinesViewController())
        case .cups:
            show(CupsViewController())
        case .luckCatcher:
            show(CatcherViewController())
        }
    }
    
}
