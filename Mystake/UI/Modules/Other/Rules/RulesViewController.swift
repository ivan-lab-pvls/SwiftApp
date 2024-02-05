//
//  RulesViewController.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import UIKit
import Atributika

final class RulesViewController: ViewController {
    
    // MARK: - UI Components
    
    private let textLabel: Label = {
        let lbl = Label()
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .text1
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    // MARK: - Properties
    
    /// View model
    private let viewModel: RulesViewModel
    
    
    // MARK: - Initialization
    
    /// Initialization
    init(game: Game) {
        viewModel = .init(game: game)
        super.init()
    }
    
    /// Initialization with coder
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View lifecycle
    
    /// View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navigation = navigationController as? NavigationController
        navigation?.headline = "RULES"
    }
    
    /// Model binding
    override func bind() {
        super.bind()
        
        viewModel.textDriver
            .compactMap { $0 }
            .sink { [weak self] in
                self?.setupText($0)
            }.store(in: &bag)
    }
    
    /// Layout setups
    override func setupLayout() {
        super.setupLayout()
        
        view.addSubview(textLabel)
        
        textLabel.snp.make { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
}

// MARK: - Setups
extension RulesViewController {
    
    /// Setup text
    private func setupText(_ text: String) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.minimumLineHeight = 16
        paragraph.maximumLineHeight = 16
        
        let base = Attrs()
            .paragraphStyle(paragraph)
        
        textLabel.attributedText = text
            .styleBase(base)
            .attributedString
    }
    
}
