//
//  AppDelegate.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Setup firebase
        setupFirebase()
        
        // Setup services
        setupServices()
        
        /// Setup navigation
        setupNavigation()
        
        return true
    }

}

extension AppDelegate {
    
    /// Setup firebase
    private func setupFirebase() {
        FirebaseApp.configure()
    }
    
    /// Setup services
    private func setupServices() {
        let _ = UserService.shared
    }
    
    /// Setup navigation
    private func setupNavigation(){
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        navigationBarAppearance.shadowColor = nil
        navigationBarAppearance.backgroundColor = .background2
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    
}
