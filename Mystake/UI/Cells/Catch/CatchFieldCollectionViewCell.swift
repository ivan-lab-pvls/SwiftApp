//
//  CatchFieldCollectionViewCell.swift
//  Mystake
//
//  Created by Vladko on 20.01.2024.
//

import UIKit
import Combine

final class CatchFieldCollectionViewCell: CollectionViewCell<CatchFieldCollectionViewModel> {
    
    // MARK: - UI Components
    
    private let gradientView: GradientView = {
        let view = GradientView(gradient: .solid(color: .clear))
        return view
    }()
    
    private let numberLabel: Label = {
        let lbl = Label()
        lbl.font = .systemFont(ofSize: 16, weight: .semibold)
        lbl.textColor = .text1
        lbl.textAlignment = .center
        return lbl
    }()
    
    
    // MARK: - View lifecycle
    
    /// Bind
    override func bind(_ viewModel: CatchFieldCollectionViewModel) {
        super.bind(viewModel)
        
        viewModel.numberDriver
            .map { String($0) }
            .assign(to: \.text, on: numberLabel)
            .store(in: &bag)
        
        viewModel.gradientDriver
            .assign(to: \.gradient, on: gradientView)
            .store(in: &bag)
    }
    
    /// Layout setups
    override func setupLayouts() {
        super.setupLayouts()
        
        contentView.addSubviews([gradientView, numberLabel])
        
        gradientView.snp.make { make in
            make.edges.equalToSuperview()
        }
        
        numberLabel.snp.make { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.frame.height / 2
        contentView.layer.masksToBounds = true
    }
    
}
