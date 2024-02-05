//
//  WheelViewController.swift
//  Mystake
//
//  Created by Vladko on 21.01.2024.
//

import UIKit

final class WheelViewController: ViewController {
    
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
    
    private let gameFieldView: UIImageView = {
        let iv = UIImageView()
        iv.image = Images.wheel
        return iv
    }()
    
    private let gameArrowView: UIImageView = {
        let iv = UIImageView()
        iv.image = Icons.wheelArrow
        return iv
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
    private let viewModel: WheelViewModel
    
    
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
        navigation?.headline = "FORTUNE WHEEL"
    }
    
    /// Model binding
    override func bind() {
        super.bind()
        
        startButton.onTap
            .assign(value: viewModel.onStart)
            .store(in: &bag)
        
        viewModel.onResultReply
            .sink { [weak self] in
                self?.showResults(multiplier: $0.0, value: $0.1)
            }.store(in: &bag)
        
        viewModel.stepperModelDriver
            .sink(stepperView.bind)
            .store(in: &bag)
        
        viewModel.angleDriver
            .print()
            .map { .identity.rotated(by: $0) }
            .assign(to: \.transform, on: gameFieldView)
            .store(in: &bag)
        
        viewModel.selectionEnabledDriver
            .map { $0 ? 1 : 0.5 }
            .assign(to: \.alpha, on: stepperView)
            .store(in: &bag)
        
        viewModel.selectionEnabledDriver
            .assign(to: \.isUserInteractionEnabled, on: stepperView)
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
        scrollContainerView.addSubviews([gameContainerView, stepperView, startButton])
        gameContainerView.addSubviews([gameFieldView, gameArrowView])
        
        scrollView.snp.make { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        scrollContainerView.snp.make { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        gameContainerView.snp.make { make in
            make.top.equalTo(58)
            make.horizontalEdges.equalToSuperview().inset(2)
        }
        
        gameFieldView.snp.make { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(gameFieldView.snp.width)
        }
        
        gameArrowView.snp.make { make in
            make.centerY.equalTo(gameFieldView.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(55)
            make.height.equalTo(78)
        }
        
        stepperView.snp.make { make in
            make.top.equalTo(gameContainerView.snp.bottom).offset(28)
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


// MARK: - Flow
extension WheelViewController {
    
    /// Show results
    private func showResults(multiplier: Double, value: Double) {
        show(AlertViewController(type: .wheelWin(multiplier, value)), as: .modal)
    }
    
}

