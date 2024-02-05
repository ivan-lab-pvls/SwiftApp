//
//  CatcherViewController.swift
//  Mystake
//
//  Created by Vladko on 20.01.2024.
//

import UIKit

final class CatcherViewController: ViewController {
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = false
        return sv
    }()
    
    private let gameFieldView: UICollectionView = {
        let size = UIScreen.main.bounds.width * 65.0 / 393.0
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = UIScreen.main.bounds.width * 8 / 393.0
        flowLayout.minimumInteritemSpacing = UIScreen.main.bounds.width * 8 / 393.0
        flowLayout.itemSize = .init(width: size, height: size)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.alwaysBounceVertical = false
        cv.alwaysBounceHorizontal = false
        cv.backgroundColor = .clear
        cv.register(CatchFieldCollectionViewCell.self)
        return cv
    }()
    
    private let rulesButton: Button = {
        let btn = Button()
        btn.font = .systemFont(ofSize: 14, weight: .medium)
        btn.backgroundColor = .background2
        btn.textColor = .text2
        btn.title = "Rules"
        btn.image = Icons.rules
        btn.imageSize = .to(size: .init(width: 24, height: 24))
        btn.imagePadding = 3.5
        btn.horizontalPadding = 8
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 14
        return btn
    }()
    
    private let stepperView: StepperView = {
        let view = StepperView()
        view.setTitle("Bet:")
        return view
    }()
    
    private let startButton: Button = {
        let btn = Button()
        btn.font = .systemFont(ofSize: 16, weight: .bold)
        btn.textColor = .text1
        btn.title = "START"
        btn.gradient = .neon
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        return btn
    }()
    
    
    // MARK: - Properties
    
    /// View model
    private let viewModel: CatcherViewModel
    
    
    // MARK: - Initialization
    
    /// Initialization
    override init() {
        viewModel = .init()
        super.init()
        hidesBottomBarWhenPushed = true
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
        navigation?.headline = "LUCKY CATCHER"
    }
    
    /// Model binding
    override func bind() {
        super.bind()
        
        startButton.onTap
            .assign(value: viewModel.onStart)
            .store(in: &bag)
        
        rulesButton.onTap
            .sink { [weak self] in
                self?.showRules()
            }.store(in: &bag)
        
        viewModel.onResultReply
            .sink { [weak self] in
                self?.showResults(multiplier: $0.0, value: $0.1)
            }.store(in: &bag)
        
        viewModel.rowsDriver
            .mapVoid()
            .sink(gameFieldView.reloadData)
            .store(in: &bag)
        
        viewModel.stepperModelDriver
            .sink(stepperView.bind)
            .store(in: &bag)
        
        viewModel.selectionEnabledDriver
            .assign(to: \.isUserInteractionEnabled, on: gameFieldView)
            .store(in: &bag)
        
        viewModel.startEnabledDriver
            .assign(to: \.isEnabled, on: startButton)
            .store(in: &bag)
    }
    
    /// View setups
    override func setupView() {
        super.setupView()
        gameFieldView.delegate = self
        gameFieldView.dataSource = self
    }
    
    /// Layout setups
    override func setupLayout() {
        super.setupLayout()
        
        let scrollContainerView = UIView()
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainerView)
        scrollContainerView.addSubviews([gameFieldView, rulesButton, stepperView, startButton])
        
        scrollView.snp.make { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        scrollContainerView.snp.make { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        gameFieldView.snp.make { make in
            make.top.equalTo(28)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(gameFieldView.snp.width)
            make.centerX.equalToSuperview()
        }
        
        rulesButton.snp.make { make in
            make.top.equalTo(gameFieldView.snp.bottom).offset(44)
            make.centerX.equalToSuperview()
            make.height.equalTo(28)
        }
        
        stepperView.snp.make { make in
            make.top.equalTo(rulesButton.snp.bottom).offset(44)
            make.horizontalEdges.equalToSuperview().inset(18)
            make.height.equalTo(42)
        }
        
        startButton.snp.make { make in
            make.top.equalTo(stepperView.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(18)
            make.height.equalTo(54)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension CatcherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// Number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.rowsDriver.value.count
    }
    
    /// Cell for item at index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(CatchFieldCollectionViewCell.self, for: indexPath)
        let row = viewModel.rowsDriver.value[indexPath.row]
        cell.bind(row)
        return cell
    }
    
    /// Did select item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.onSelect.send(indexPath.row)
    }
    
}


// MARK: - Flow
extension CatcherViewController {
    
    /// Show rules
    private func showRules() {
        show(RulesViewController(game: .luckCatcher))
    }
    
    /// Show results
    private func showResults(multiplier: Double, value: Double) {
        show(AlertViewController(type: .luckyWin(multiplier, value)), as: .modal)
    }
    
}
