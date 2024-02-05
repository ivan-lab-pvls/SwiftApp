//
//  StepperView.swift
//  Mystake
//
//  Created by Vladko on 19.01.2024.
//

import UIKit
import Combine

final class StepperView: View<StepperModel> {
    
    // MARK: - UI Components
    
    private let stepperView: UIView = {
        let view = UIView()
        view.backgroundColor = .background2
        return view
    }()
    
    private let minusButton: Button = {
        let btn = Button()
        btn.setImage(Icons.minus, for: .normal)
        btn.imageSize = .to(size: .init(width: 34, height: 34))
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.textAlignment = .center
        lbl.textColor = .text1
        return lbl
    }()
    
    private var countLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.textAlignment = .center
        lbl.textColor = .text1
        return lbl
    }()
    
    private let plusButton: Button = {
        let btn = Button()
        btn.setImage(Icons.plus, for: .normal)
        btn.imageSize = .to(size: .init(width: 34, height: 34))
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    private let amountsStackView: UIStackView = {
        let sv = UIStackView(axis: .horizontal, spacing: 7)
        return sv
    }()
    
    private let minusLongPressGesture: UILongPressGestureRecognizer = {
        let lpgr = UILongPressGestureRecognizer()
        lpgr.minimumPressDuration = 0.5
        return lpgr
    }()
    
    private let plusLongPressGesture: UILongPressGestureRecognizer = {
        let lpgr = UILongPressGestureRecognizer()
        lpgr.minimumPressDuration = 0.5
        return lpgr
    }()
    
    
    // MARK: - Lifecycle
    
    /// Bind view model
    override func bind(_ viewModel: StepperModel) {
        super.bind(viewModel)
        setupAmounts([5, 10, 20, 50])
            
        minusButton.onTap
            .assign(value: viewModel.onReduce)
            .store(in: &bag)
        
        plusButton.onTap
            .assign(value: viewModel.onIncrease)
            .store(in: &bag)
        
        minusLongPressGesture.onPress
            .mapVoid()
            .assign(value: viewModel.onLongReduce)
            .store(in: &bag)
        
        plusLongPressGesture.onPress
            .mapVoid()
            .assign(value: viewModel.onLongIncrease)
            .store(in: &bag)
        
        titleLabel.publisher(for: \.text)
            .map { $0 == nil }
            .assign(to: \.isHidden, on: titleLabel)
            .store(in: &bag)
        
        viewModel.textDriver
            .mapOptional()
            .assign(to: \.text, on: countLabel)
            .store(in: &bag)
        
        viewModel.reduseEnabledDriver
            .assign(to: \.isEnabled, on: minusButton)
            .store(in: &bag)
        
        viewModel.increaseEnabledDriver
            .assign(to: \.isEnabled, on: plusButton)
            .store(in: &bag)
    }

    /// View setups
    override func setupView() {
        super.setupView()
        minusButton.addGestureRecognizer(minusLongPressGesture)
        plusButton.addGestureRecognizer(plusLongPressGesture)
    }
    
    /// Autolayouts setups
    override func setupLayouts() {
        super.setupLayouts()
        
        let stackView = UIStackView(axis: .horizontal, spacing: 7, alignment: .center)
        let contentStackView = UIStackView(axis: .horizontal, distribution: .equalSpacing)
        let valueStackView = UIStackView(axis: .horizontal, spacing: 5)
        
        addSubview(stackView)
        stackView.addArrangedSubviews([stepperView, amountsStackView])
        stepperView.addSubview(contentStackView)
        contentStackView.addArrangedSubviews([minusButton, valueStackView, plusButton])
        valueStackView.addArrangedSubviews([titleLabel, countLabel])
        
        stackView.snp.make { make in
            make.edges.equalToSuperview()
        }
        
        contentStackView.snp.make { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        minusButton.snp.make { make in
            make.size.equalTo(34)
        }
        
        plusButton.snp.make { make in
            make.size.equalTo(34)
        }
        
        amountsStackView.snp.make { make in
            make.height.equalTo(34)
        }
    }
    
    /// Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        stepperView.layer.cornerRadius = frame.height / 2
        stepperView.layer.masksToBounds = true
    }
    
}

// MARK: - Setups
extension StepperView {
    
    /// Setup amounts
    private func setupAmounts(_ amounts: [Int]) {
        let buttons = amounts.map { amount in
            let button = Button()
            button.backgroundColor = .background2
            button.font = .systemFont(ofSize: 14, weight: .medium)
            button.textColor = .text1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.5
            button.layer.cornerRadius = 17
            button.layer.masksToBounds = true
            button.title = "+" + String(amount)
            
            button.onTap
                .just(amount)
                .assign(value: viewModel.onAmount)
                .store(in: &bag)
            
            return button
        }
        
        amountsStackView.subviews.forEach { $0.removeFromSuperview() }
        amountsStackView.addArrangedSubviews(buttons)
        
        buttons.forEach { btn in
            btn.snp.make {
                $0.width.equalTo(btn.snp.height)
            }
        }
    }
    
}

// MARK: - Public actions
extension StepperView {
    
    /// Set title
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
}

