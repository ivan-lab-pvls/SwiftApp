//
//  CupSelectionView.swift
//  Mystake
//
//  Created by Vladko on 21.01.2024.
//

import UIKit
import Combine

final class CupSelectionView: View<CupSelectionViewModel> {
    
    // MARK: - UI Components
    
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .text1
        lbl.text = "Your cup"
        return lbl
    }()
    
    private let button1: Button = {
        let btn = Button()
        btn.font = .systemFont(ofSize: 14, weight: .medium)
        btn.textColor = .text1
        btn.title = "1"
        btn.layer.cornerRadius = 17
        return btn
    }()
    
    private let button2: Button = {
        let btn = Button()
        btn.font = .systemFont(ofSize: 14, weight: .medium)
        btn.textColor = .text1
        btn.title = "2"
        btn.layer.cornerRadius = 17
        return btn
    }()
    
    private let button3: Button = {
        let btn = Button()
        btn.font = .systemFont(ofSize: 14, weight: .medium)
        btn.textColor = .text1
        btn.title = "3"
        btn.layer.cornerRadius = 17
        return btn
    }()
    
    private let button4: Button = {
        let btn = Button()
        btn.font = .systemFont(ofSize: 14, weight: .medium)
        btn.textColor = .text1
        btn.title = "4"
        btn.layer.cornerRadius = 17
        return btn
    }()
    
    private let button5: Button = {
        let btn = Button()
        btn.font = .systemFont(ofSize: 14, weight: .medium)
        btn.textColor = .text1
        btn.title = "5"
        btn.layer.cornerRadius = 17
        return btn
    }()
    
    
    // MARK: - Lifecycle
    
    /// Bind view model
    override func bind(_ viewModel: CupSelectionViewModel) {
        super.bind(viewModel)
        
        Publishers.MergeMany(
            button1.onTap.just(0),
            button2.onTap.just(1),
            button3.onTap.just(2),
            button4.onTap.just(3),
            button5.onTap.just(4)
        )
            .assign(value: viewModel.onSelectCommand)
            .store(in: &bag)
        
        viewModel.selectedIndexDriver
            .map { $0 == 0 ? .background3 : .background2 }
            .assign(to: \.backgroundColor, on: button1)
            .store(in: &bag)
        
        viewModel.selectedIndexDriver
            .map { $0 == 1 ? .background3 : .background2 }
            .assign(to: \.backgroundColor, on: button2)
            .store(in: &bag)
        
        viewModel.selectedIndexDriver
            .map { $0 == 2 ? .background3 : .background2 }
            .assign(to: \.backgroundColor, on: button3)
            .store(in: &bag)
        
        viewModel.selectedIndexDriver
            .map { $0 == 3 ? .background3 : .background2 }
            .assign(to: \.backgroundColor, on: button4)
            .store(in: &bag)
        
        viewModel.selectedIndexDriver
            .map { $0 == 4 ? .background3 : .background2 }
            .assign(to: \.backgroundColor, on: button5)
            .store(in: &bag)
    }
    
    /// Autolayouts setups
    override func setupLayouts() {
        super.setupLayouts()
        
        let stackView = UIStackView(axis: .horizontal, spacing: 8)
        
        addSubview(stackView)
        stackView.addArrangedSubviews([titleLabel, button1, button2, button3, button4, button5])
        
        stackView.snp.make { make in
            make.edges.equalToSuperview()
        }
        
        button1.snp.make { make in
            make.size.equalTo(34)
        }
        
        button2.snp.make { make in
            make.size.equalTo(34)
        }
        
        button3.snp.make { make in
            make.size.equalTo(34)
        }
        
        button4.snp.make { make in
            make.size.equalTo(34)
        }
        
        button5.snp.make { make in
            make.size.equalTo(34)
        }
    }
    
}
