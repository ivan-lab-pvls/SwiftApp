//
//  MinesViewController.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import UIKit

final class MinesViewController: ViewController {
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = false
        return sv
    }()
    
    private let gameContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let gameBackroundView: UIImageView = {
        let view = UIImageView()
        view.image = Images.background1
        view.contentMode = .scaleAspectFill
        view.alpha = 0.3
        view.layer.masksToBounds = true
        return view
    }()
    
    private let gameFieldView: UICollectionView = {
        let size = (UIScreen.main.bounds.width - 64) / 5
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.itemSize = .init(width: size, height: size)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.alwaysBounceVertical = false
        cv.alwaysBounceHorizontal = false
        cv.backgroundColor = .clear
        cv.register(MineFieldCollectionViewCell.self)
        return cv
    }()
    
    private let cherriesImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = Images.cherry
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let cherriesLabel: GradientLabel = {
        let lbl = GradientLabel(gradient: .green)
        lbl.font = .systemFont(ofSize: 26, weight: .black)
        return lbl
    }()
    
    private let minesImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = Images.mines
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let minesLabel: GradientLabel = {
        let lbl = GradientLabel(gradient: .orange)
        lbl.font = .systemFont(ofSize: 26, weight: .black)
        return lbl
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
    
    private let cashOutButton: Button = {
        let btn = Button()
        btn.font = .systemFont(ofSize: 16, weight: .bold)
        btn.textColor = .text1
        btn.title = "CASH OUT"
        btn.gradient = .neon
        btn.image = Icons.coin
        btn.imageSize = .to(size: .init(width: 18, height: 20))
        btn.imagePadding = 4
        btn.semanticContentAttribute = .forceRightToLeft
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        return btn
    }()
    
    
    // MARK: - Properties
    
    /// View model
    private let viewModel: MinesViewModel
    
    
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
        navigation?.headline = "MINES"
    }
    
    /// Model binding
    override func bind() {
        super.bind()
        
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.decimalSeparator = "."
        
        startButton.onTap
            .assign(value: viewModel.onStart)
            .store(in: &bag)
        
        cashOutButton.onTap
            .assign(value: viewModel.onCashOut)
            .store(in: &bag)
        
        rulesButton.onTap
            .sink { [weak self] in
                self?.showRules()
            }.store(in: &bag)
        
        viewModel.onSuccessReply
            .sink { [weak self] in
                self?.showSuccess($0)
            }.store(in: &bag)
        
        viewModel.onFailureReply
            .sink { [weak self] in
                self?.showFailure()
            }.store(in: &bag)
        
        viewModel.rowsDriver
            .mapVoid()
            .sink(gameFieldView.reloadData)
            .store(in: &bag)
        
        viewModel.cherriesDriver
            .map { String($0) }
            .assign(to: \.text, on: cherriesLabel)
            .store(in: &bag)
        
        viewModel.minesDriver
            .map { String($0) }
            .assign(to: \.text, on: minesLabel)
            .store(in: &bag)
        
        viewModel.amountDriver
            .map { .init(floatLiteral: $0) }
            .map { numberFormatter.string(from: $0) }
            .map { "CASH OUT: \($0 ?? "")" }
            .assign(to: \.title, on: cashOutButton)
            .store(in: &bag)
        
        viewModel.stepperModelDriver
            .sink(stepperView.bind)
            .store(in: &bag)
        
        viewModel.stepperEnabledDriver
            .map { $0 ? 1 : 0.5 }
            .assign(to: \.alpha, on: stepperView)
            .store(in: &bag)
        
        viewModel.stepperEnabledDriver
            .assign(to: \.isUserInteractionEnabled, on: stepperView)
            .store(in: &bag)
        
        viewModel.fieldsEnabledDriver
            .assign(to: \.isUserInteractionEnabled, on: gameFieldView)
            .store(in: &bag)
        
        viewModel.startEnabledDriver
            .map { !$0 }
            .assign(to: \.isHidden, on: startButton)
            .store(in: &bag)
        
        viewModel.cashOutEnabledDriver
            .map { !$0 }
            .assign(to: \.isHidden, on: cashOutButton)
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
        let fieldResultsStackView = UIStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing)
        let cherriesStackView = UIStackView(axis: .horizontal, spacing: 10)
        let minesStackView = UIStackView(axis: .horizontal, spacing: 10)
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainerView)
        scrollContainerView.addSubviews([gameContainerView, stepperView, startButton, cashOutButton])
        gameContainerView.addSubviews([gameBackroundView, gameFieldView, fieldResultsStackView])
        fieldResultsStackView.addArrangedSubviews([cherriesStackView, rulesButton, minesStackView])
        cherriesStackView.addArrangedSubviews([cherriesImageView, cherriesLabel])
        minesStackView.addArrangedSubviews([minesLabel, minesImageView])
        
        scrollView.snp.make { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        scrollContainerView.snp.make { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        gameContainerView.snp.make { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        gameBackroundView.snp.make { make in
            make.edges.equalToSuperview()
        }
        
        gameFieldView.snp.make { make in
            make.top.equalTo(28)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.width.equalTo(gameFieldView.snp.height)
        }
        
        fieldResultsStackView.snp.make { make in
            make.top.equalTo(gameFieldView.snp.bottom).offset(18)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(-16)
            make.height.equalTo(fieldResultsStackView.snp.width).multipliedBy(80.0 / 360.0)
        }
        
        cherriesImageView.snp.make { make in
            make.width.equalTo(cherriesImageView.snp.height)
        }
        
        rulesButton.snp.make { make in
            make.height.equalTo(28)
        }
        
        minesImageView.snp.make { make in
            make.width.equalTo(cherriesImageView.snp.height)
        }
        
        stepperView.snp.make { make in
            make.top.equalTo(gameContainerView.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(18)
            make.height.equalTo(42)
        }
        
        startButton.snp.make { make in
            make.top.equalTo(stepperView.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(18)
            make.height.equalTo(54)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        cashOutButton.snp.make { make in
            make.edges.equalTo(startButton)
        }
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MinesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// Number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.rowsDriver.value.count
    }
    
    /// Cell for item at index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(MineFieldCollectionViewCell.self, for: indexPath)
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
extension MinesViewController {
    
    /// Show rules
    private func showRules() {
        show(RulesViewController(game: .mines))
    }
    
    /// Show success
    private func showSuccess(_ value: Double) {
        show(AlertViewController(type: .minesWin(value)), as: .modal)
    }
    
    /// Show failure
    private func showFailure() {
        show(AlertViewController(type: .minesLose), as: .modal)
    }
    
}
