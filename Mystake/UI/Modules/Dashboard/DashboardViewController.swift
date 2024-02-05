//
//  DashboardViewController.swift
//  Mystake
//
//  Created by Vladko on 17.01.2024.
//

import UIKit

final class DashboardViewController: TabBarController {
    
    // MARK: - Properties
    
    /// View Model
    private let viewModel: DashboardViewModel
    
    
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
    
    override func bind() {
        super.bind()
        
        viewModel.controllersDriver
            .mapOptional()
            .assignSafely(to: \.viewControllers, on: self)
            .store(in: &bag)
    }
    
    override func setupView() {
        super.setupView()
        let normalColor: UIColor = .background5
        let selectedColor: UIColor = .background3
        
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.normal.iconColor = normalColor
        tabBarItemAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]
        tabBarItemAppearance.selected.iconColor = selectedColor
        tabBarItemAppearance.selected.titleTextAttributes = [.foregroundColor : selectedColor]

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.inlineLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.backgroundColor = .background2
        
        tabBar.standardAppearance = tabBarAppearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
    }
    
}
