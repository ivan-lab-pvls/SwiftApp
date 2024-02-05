//
//  ProfileActionView.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import UIKit

final class ProfileActionView: View<ProfileActionModel> {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = Icons.chevronRight
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: Label = {
        let lbl = Label()
        lbl.font = .systemFont(ofSize: 17)
        lbl.textColor = .text1
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private let actionButton: Button = {
        let btn = Button()
        return btn
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .background6
        return view
    }()
    
    
    // MARK: - Lifecycle
    
    /// Bind
    override func bind(_ viewModel: ProfileActionModel) {
        super.bind(viewModel)
        
        actionButton.onTap
            .assign(value: viewModel.onSelectCommand)
            .store(in: &bag)
        
        viewModel.titleDriver
            .assign(to: \.text, on: titleLabel)
            .store(in: &bag)
    }
    
    /// Layout setups
    override func setupLayouts() {
        super.setupLayouts()
        
        let stackView = UIStackView(axis: .horizontal, spacing: 10, alignment: .center)
        
        addSubview(containerView)
        containerView.addSubviews([stackView, dividerView, actionButton])
        stackView.addArrangedSubviews([titleLabel, arrowImageView])
        
        containerView.snp.make { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.make { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        dividerView.snp.make { make in
            make.leading.equalTo(16)
            make.bottom.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        actionButton.snp.make { make in
            make.edges.equalToSuperview()
        }
        
        arrowImageView.snp.make { make in
            make.width.equalTo(8)
            make.height.equalTo(32)
        }
    }
    
}
