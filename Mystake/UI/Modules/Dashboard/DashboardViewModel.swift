//
//  DashboardViewModel.swift
//  Mystake
//
//  Created by Vladko on 17.01.2024.
//

import UIKit
import Combine

final class DashboardViewModel: ViewModel {
    
    // MARK: - Outputs
    
    /// Controllers
    private let controllers = CurrentValueSubject<[UIViewController], Never>([])
    var controllersDriver: Driver<[UIViewController], Never> { controllers.asDriver() }
    
    
    // MARK: - Initialization
    
    /// Intialization
    override init() {
        super.init()
        setupControllers()
    }
    
}

// MARK: - Setups
extension DashboardViewModel {
    
    /// Setup controllers
    private func setupControllers() {
        let homeViewController = HomeViewController()
        let homeNavigationController = NavigationController(rootViewController: homeViewController)
        homeNavigationController.tabBarItem.title = "Home"
        homeNavigationController.tabBarItem.image = Icons.home
        
        let profileViewController = ProfileViewController()
        let profileNavigationController = NavigationController(rootViewController: profileViewController)
        profileNavigationController.tabBarItem.title = "Profile"
        profileNavigationController.tabBarItem.image = Icons.profile1
        
        controllers.send([
            homeNavigationController,
            profileNavigationController
        ])
    }
    
}
