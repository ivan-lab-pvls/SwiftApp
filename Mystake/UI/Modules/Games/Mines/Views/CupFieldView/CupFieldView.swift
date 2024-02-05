//
//  CupFieldView.swift
//  Mystake
//
//  Created by Vladko on 21.01.2024.
//

import UIKit
import Combine

final class CupFieldView: View<CupFieldViewModel> {
    
    // MARK: - UI Components
    
    private let cupImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let ballImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = Icons.ball
        return iv
    }()
    
    
    // MARK: - View lifecycle
    
    /// Bind
    override func bind(_ viewModel: CupFieldViewModel) {
        super.bind(viewModel)
        
        viewModel.imageDriver
            .assign(to: \.image, on: cupImageView)
            .store(in: &bag)
        
        viewModel.ballExistDriver
            .map { !$0 }
            .assign(to: \.isHidden, on: ballImageView)
            .store(in: &bag)
        
        viewModel.showedDriver
            .filter { $0 }
            .sink { [weak self] _ in
                self?.showCup()
            }.store(in: &bag)
        
        viewModel.showedDriver
            .filter { !$0 }
            .sink { [weak self] _ in
                self?.hideCup()
            }.store(in: &bag)
    }
    
    /// Layout setups
    override func setupLayouts() {
        super.setupLayouts()
        
        addSubviews([ballImageView, cupImageView])
        
        cupImageView.snp.make { make in
            make.edges.equalToSuperview()
        }
        
        ballImageView.snp.make { make in
            make.bottom.equalToSuperview().offset(-2)
            make.centerX.equalToSuperview()
            make.size.equalTo(26)
        }
    }
    
}

// MARK: - Animation
extension CupFieldView {
    
    /// Show cup
    private func showCup() {
        UIView.animate(withDuration: 0.3) { [self] in
            cupImageView.transform = .identity
                .translatedBy(x: -20, y: -40)
                .rotated(by: -0.26)
        }
    }
    
    /// Hide cup
    private func hideCup() {
        UIView.animate(withDuration: 0.3) { [self] in
            cupImageView.transform = .identity
        }
    }
    
}
