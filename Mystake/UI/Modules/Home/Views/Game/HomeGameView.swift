//
//  HomeGameView.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import UIKit

final class HomeGameView: View<HomeGameModel> {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let titleLabel: Label = {
        let lbl = Label()
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        lbl.textColor = .text1
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private let actionButton: Button = {
        let btn = Button()
        return btn
    }()
    
    
    // MARK: - Lifecycle
    
    /// Bind
    override func bind(_ viewModel: HomeGameModel) {
        super.bind(viewModel)
        
        actionButton.onTap
            .assign(value: viewModel.onSelectCommand)
            .store(in: &bag)
        
        viewModel.posterDriver
            .assign(to: \.image, on: imageView)
            .store(in: &bag)
        
        viewModel.nameDriver
            .map { $0?.uppercased() }
            .assign(to: \.text, on: titleLabel)
            .store(in: &bag)
    }
    
    /// Layout setups
    override func setupLayouts() {
        super.setupLayouts()
        
        addSubview(containerView)
        containerView.addSubviews([imageView, titleLabel, actionButton])
        
        containerView.snp.make { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.make { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.make { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
        }
        
        actionButton.snp.make { make in
            make.edges.equalToSuperview()
        }
    }
    
}
