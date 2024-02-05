//
//  BalanceView.swift
//  Mystake
//
//  Created by Vladko on 17.01.2024.
//

import UIKit

final class BalanceView: View<BalanceViewModel> {
    
    // MARK: - UI Components
    
    private let containerView: GradientView = {
        let view = GradientView(gradient: .neon)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
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
    
    
    // MARK: - View lifecycle
    
    /// Bind
    override func bind(_ viewModel: BalanceViewModel) {
        super.bind(viewModel)
        
        viewModel.balanceDriver
            .mapOptional()
            .assign(to: \.text, on: amountLabel)
            .store(in: &bag)
    }
    
    /// Layout setups
    override func setupLayouts() {
        super.setupLayouts()
        
        let stackView = UIStackView(axis: .horizontal, spacing: 4)
        
        addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubviews([iconImageView, amountLabel])
        
        containerView.snp.make { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.make { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        iconImageView.snp.make { make in
            make.size.equalTo(24)
        }
    }
    
}
