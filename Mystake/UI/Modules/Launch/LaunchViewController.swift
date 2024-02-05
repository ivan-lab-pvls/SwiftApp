//
//  LaunchViewController.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit

final class LaunchViewController: ViewController {
    
    // MARK: - UI Components
    
    private let indicatorView: ActivityIndicatorView = {
        let iv = ActivityIndicatorView(gradient: .neon)
        iv.startAnimating()
        return iv
    }()
    
    
    // MARK: - Properties
    
    /// View model
    private let viewModel: LaunchViewModel
    
    
    // MARK: - Initialization
    
    /// Initialization
    override init() {
        viewModel = .init()
        super.init()
    }
    
    /// Initialization with coder
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View lifecycle
    
    /// Model binding
    override func bind() {
        super.bind()
        
        onDidLoad
            .assign(value: viewModel.onDidLoad)
            .store(in: &bag)
        
        viewModel.onShowDashboard
            .sink { [weak self] in
                self?.showDashboard()
            }.store(in: &bag)
    }
    
    /// Layout setups
    override func setupLayout() {
        super.setupLayout()
        
        view.addSubview(indicatorView)
        
        indicatorView.snp.make { make in
            make.center.equalToSuperview()
            make.size.equalTo(34)
        }
    }
    
}

// MARK: - Flow
extension LaunchViewController {
    
    /// Show home
    private func showDashboard() {
        let window = UIApplication.shared.keyWindow
        let rootViewController = UINavigationController()
        rootViewController.isNavigationBarHidden = true
        rootViewController.viewControllers = [DashboardViewController()]
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
}

