//
//  MineFieldCollectionViewCell.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import UIKit
import Combine

final class MineFieldCollectionViewCell: CollectionViewCell<MineFieldCollectionViewModel> {
    
    // MARK: - UI Components
    
    private let gradientView: GradientView = {
        let view = GradientView(gradient: .solid(color: .clear))
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .background2
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let placeholderImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = Icons.any
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    // MARK: - View lifecycle
    
    /// Bind
    override func bind(_ viewModel: MineFieldCollectionViewModel) {
        super.bind(viewModel)
        
        viewModel.imageDriver
            .assign(to: \.image, on: iconImageView)
            .store(in: &bag)
        
        viewModel.showedDriver
            .map { !$0 }
            .assign(to: \.isHidden, on: iconImageView)
            .store(in: &bag)
        
        viewModel.showedDriver
            .assign(to: \.isHidden, on: placeholderImageView)
            .store(in: &bag)
        
        Publishers.CombineLatest(
            viewModel.gradientDriver,
            viewModel.showedDriver
        )
        .map { $0.1 ? $0.0 : .solid(color: .background1) }
        .assign(to: \.gradient, on: gradientView)
        .store(in: &bag)
    }
    
    /// View setups
    override func setupView() {
        super.setupView()
        contentView.alpha = 0.9
    }
    
    /// Layout setups
    override func setupLayouts() {
        super.setupLayouts()
        
        contentView.addSubviews([gradientView, containerView])
        containerView.addSubviews([placeholderImageView, iconImageView])
        
        gradientView.snp.make { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.make { make in
            make.top.horizontalEdges.equalToSuperview().inset(1)
            make.bottom.equalToSuperview()
        }
        
        placeholderImageView.snp.make { make in
            make.center.equalToSuperview()
            make.width.equalTo(13)
            make.height.equalTo(19)
        }
        
        iconImageView.snp.make { make in
            make.top.equalTo(3.4)
            make.bottom.equalTo(-3.4)
            make.leading.equalTo(8)
            make.trailing.equalTo(-4.7)
        }
    }
    
}
