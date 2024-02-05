//
//  HomeCoinsView.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import UIKit

final class HomeCoinsView: View<HomeCoinsModel> {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = Images.freeCoins
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let titleLabel: Label = {
        let lbl = Label()
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        lbl.textColor = .text1
        lbl.text = "GET 150 FREE COINS"
        return lbl
    }()
    
    private let getCoinsButton: Button = {
        let btn = Button()
        btn.font = .systemFont(ofSize: 14, weight: .medium)
        btn.textColor = .text1
        btn.horizontalPadding = 8
        btn.backgroundColor = .background4
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    
    // MARK: - Lifecycle
    
    /// Bind
    override func bind(_ viewModel: HomeCoinsModel) {
        super.bind(viewModel)
        
        getCoinsButton.onTap
            .assign(value: viewModel.onCoins)
            .store(in: &bag)
        
        viewModel.delayDriver
            .compactMap { $0 }
            .map { "Come back in \($0)" }
            .assign(to: \.title, on: getCoinsButton)
            .store(in: &bag)
        
        viewModel.delayDriver
            .filter { $0 == nil }
            .just("GET COINS")
            .assign(to: \.title, on: getCoinsButton)
            .store(in: &bag)
        
        viewModel.delayDriver
            .map { $0 == nil }
            .assign(to: \.isUserInteractionEnabled, on: getCoinsButton)
            .store(in: &bag)
        
        viewModel.delayDriver
            .map { $0 == nil ? .background4 : .background5 }
            .assign(to: \.backgroundColor, on: getCoinsButton)
            .store(in: &bag)
    }
    
    /// Layout setups
    override func setupLayouts() {
        super.setupLayouts()
        
        let detailsStackView = UIStackView(axis: .vertical, spacing: 10, alignment: .leading)
        
        addSubview(containerView)
        containerView.addSubviews([imageView, detailsStackView])
        detailsStackView.addArrangedSubviews([titleLabel, getCoinsButton])
        
        containerView.snp.make { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.make { make in
            make.edges.equalToSuperview()
        }
        
        detailsStackView.snp.make { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(-20)
        }
        
        getCoinsButton.snp.make { make in
            make.height.equalTo(32)
        }
    }
    
}
