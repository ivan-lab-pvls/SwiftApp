//
//  CupsViewController.swift
//  Mystake
//
//  Created by Vladko on 20.01.2024.
//

import UIKit

final class CupsViewController: ViewController {
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = false
        return sv
    }()
    
    private let gameFieldView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 48
        sv.alignment = .center
        return sv
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
    
    private let cupSelectionView: CupSelectionView = {
        let view = CupSelectionView()
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
    private let viewModel: CupsViewModel
    
    
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
        navigation?.headline = "CUPS"
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
        
        viewModel.onSuccessReply
            .sink { [weak self] in
                self?.showSuccess($0)
            }.store(in: &bag)
        
        viewModel.onFailureReply
            .sink { [weak self] in
                self?.showFailure($0)
            }.store(in: &bag)
        
        viewModel.rowsDriver
            .sink { [weak self] in
                self?.setupCups($0)
            }.store(in: &bag)
        
        viewModel.stepperModelDriver
            .sink(stepperView.bind)
            .store(in: &bag)
        
        viewModel.cupSelectionModelDriver
            .sink(cupSelectionView.bind)
            .store(in: &bag)
        
        viewModel.selectionEnabledDriver
            .map { $0 ? 1 : 0.5 }
            .assign(to: \.alpha, on: stepperView)
            .store(in: &bag)
        
        viewModel.selectionEnabledDriver
            .assign(to: \.isUserInteractionEnabled, on: stepperView)
            .store(in: &bag)
        
        viewModel.selectionEnabledDriver
            .map { $0 ? 1 : 0.5 }
            .assign(to: \.alpha, on: cupSelectionView)
            .store(in: &bag)
        
        viewModel.selectionEnabledDriver
            .assign(to: \.isUserInteractionEnabled, on: cupSelectionView)
            .store(in: &bag)
        
        viewModel.startEnabledDriver
            .assign(to: \.isEnabled, on: startButton)
            .store(in: &bag)
    }
    
    /// Layout setups
    override func setupLayout() {
        super.setupLayout()
        
        let scrollContainerView = UIView()
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainerView)
        scrollContainerView.addSubviews([gameFieldView, rulesButton, stepperView, cupSelectionView, startButton])
        
        scrollView.snp.make { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        scrollContainerView.snp.make { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        gameFieldView.snp.make { make in
            make.top.equalTo(92)
            make.horizontalEdges.equalToSuperview().inset(31)
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
        
        cupSelectionView.snp.make { make in
            make.top.equalTo(stepperView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(18)
        }
        
        startButton.snp.make { make in
            make.top.equalTo(cupSelectionView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(18)
            make.height.equalTo(54)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
}

// MARK: - Setups
extension CupsViewController {
    
    /// Setup cups
    private func setupCups(_ rows: [CupFieldViewModel]) {
        let cupViews = rows.map { row in
            let view = CupFieldView()
            view.bind(row)
            view.snp.make { $0.width.equalTo(77).priority(.medium) }
            return view
        }.chunked(into: 3)
        
        var views = [UIView]()
        for cups in cupViews {
            let stackView = UIStackView(axis: .horizontal, spacing: 49)
            stackView.addArrangedSubviews(cups)
            stackView.snp.make { $0.height.equalTo(100) }
            views.append(stackView)
        }
        
        gameFieldView.subviews.forEach { $0.removeFromSuperview() }
        gameFieldView.addArrangedSubviews(views)
    }
    
}


// MARK: - Flow
extension CupsViewController {
    
    /// Show rules
    private func showRules() {
        show(RulesViewController(game: .cups))
    }
    
    /// Show success
    private func showSuccess(_ value: Double) {
        show(AlertViewController(type: .cupsWin(value)), as: .modal)
    }
    
    /// Show failure
    private func showFailure(_ value: Double) {
        show(AlertViewController(type: .cupsLose(value)), as: .modal)
    }
    
}
