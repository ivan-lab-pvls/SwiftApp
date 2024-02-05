//
//  AlertViewController.swift
//  Mystake
//
//  Created by Vladko on 19.01.2024.
//

import UIKit

final class AlertViewController: ViewController {
    
    // MARK: - UI Components
    
    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .background2
        view.alpha = 0.7
        return view
    }()
    
    private let titleLabel: Label = {
        let lbl = Label()
        lbl.font = .systemFont(ofSize: 26, weight: .black)
        lbl.textColor = .text1
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.shadowOpacity = 1
        iv.layer.shadowRadius = 15
        return iv
    }()
    
    private let amountView: GradientView = {
        let view = GradientView(gradient: .neon)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let amountPlusLabel: Label = {
        let lbl = Label()
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .text3
        lbl.text = "+"
        return lbl
    }()
    
    private let amountImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = Icons.coin
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let amountLabel: Label = {
        let lbl = Label()
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .text3
        return lbl
    }()
    
    private let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 0
        return nf
    }()
    
    
    // MARK: - Properties
    
    /// View model
    private let viewModel: AlertViewModel
    
    
    // MARK: - Initialization
    
    /// Initialization
    init(type: AlertType) {
        self.viewModel = .init(type: type)
        super.init()
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    /// Initialization with coder
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View lifecycle
    
    /// View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDismissTimeout()
    }
    
    /// View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showPresentationAnimation()
    }
    
    /// View will disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showDismissingAnimation()
    }
    
    /// Bind
    override func bind() {
        super.bind()
        
        let numberFormatter = numberFormatter
        
        viewModel.titleDriver
            .map { $0?.uppercased() }
            .assign(to: \.text, on: titleLabel)
            .store(in: &bag)
        
        viewModel.iconDriver
            .assign(to: \.image, on: imageView)
            .store(in: &bag)
        
        viewModel.shadowDriver
            .map { $0.cgColor }
            .assign(to: \.shadowColor, on: imageView.layer)
            .store(in: &bag)
        
        viewModel.iconDriver
            .map { $0 == nil }
            .assign(to: \.isHidden, on: imageView)
            .store(in: &bag)
        
        viewModel.amountDriver
            .map { $0 >= 0 ? "+" : "-" }
            .assign(to: \.text, on: amountPlusLabel)
            .store(in: &bag)
        
        viewModel.amountDriver
            .compactMap { $0 }
            .map { .init(floatLiteral: abs($0)) }
            .map { numberFormatter.string(from: $0) ?? "" }
            .assign(to: \.text, on: amountLabel)
            .store(in: &bag)
        
        viewModel.amountDriver
            .map { $0 == nil }
            .assign(to: \.isHidden, on: amountView)
            .store(in: &bag)
    }
    
    /// View setups
    override func setupView() {
        super.setupView()
        view.backgroundColor = .clear
    }
    
    /// Layout setups
    override func setupLayout() {
        super.setupLayout()
        
        let stackView = UIStackView(axis: .vertical, spacing: 30, alignment: .center)
        let amountStackView = UIStackView(axis: .horizontal, spacing: 4, alignment: .center)
        
        view.addSubviews([shadowView, stackView])
        stackView.addArrangedSubviews([titleLabel, imageView, amountView])
        amountView.addSubview(amountStackView)
        amountStackView.addArrangedSubviews([amountPlusLabel, amountImageView, amountLabel])
        
        shadowView.snp.make { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.make { make in
            make.centerY.equalToSuperview().offset(-30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        imageView.snp.make { make in
            make.size.equalTo(230)
        }
        
        amountView.snp.make { make in
            make.height.equalTo(32)
        }
        
        amountStackView.snp.make { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        amountImageView.snp.make { make in
            make.width.equalTo(22)
            make.height.equalTo(24)
        }
    }
    
}

// MARK: - Setups
extension AlertViewController {
    
    /// Setup dismiss timeout
    private func setupDismissTimeout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.dismiss()
        }
    }
    
}

// MARK: - Animations
extension AlertViewController {
    
    /// Show presentation animation
    private func showPresentationAnimation() {
        imageView.alpha = 0
        imageView.transform = .identity.scaledBy(x: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.3) { [self] in
            imageView.alpha = 1
            imageView.transform = .identity
        }
    }
    
    /// Show dismissing animation
    private func showDismissingAnimation() {
        imageView.alpha = 1
        imageView.transform = .identity
        
        UIView.animate(withDuration: 0.3) { [self] in
            imageView.alpha = 0
            imageView.transform = .identity.scaledBy(x: 0.5, y: 0.5)
        }
    }
    
}


