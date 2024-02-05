//
//  UIViewController+Extensions.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit

extension UIViewController {
    
    /// Dismiss
    func dismiss() {
        dismiss(completion: nil)
    }
    
    /// Dismiss
    func dismiss(completion: (() -> Void)?) {
        if let navigationController {
            navigationController.popViewController(animated: true, completion: completion)
        } else {
            dismiss(animated: true, completion: completion)
        }
    }
    
    /// Show builder with inputs and outputs
    func show(_ controller: UIViewController, as type: PresentationType = .navigation) {
        switch type {
        case .navigation:
            push(controller)
        case .modal:
            present(controller)
        }
    }
    
    /// Push view controller
    private func push(_ viewController: UIViewController) {
        guard let navigationController else { return }
        
        let show = {
            if let topController = navigationController.topViewController {
                guard type(of: viewController) != type(of: topController) else { return }
            }
            
            if let viewController = viewController as? UINavigationController {
                var controllers = navigationController.viewControllers
                controllers.append(contentsOf: viewController.viewControllers)
                navigationController.setViewControllers(controllers, animated: true)
            } else {
                navigationController.show(viewController, sender: nil)
            }
        }
        
        if navigationController.presentedViewController != nil {
            navigationController.dismiss(animated: true, completion: show)
        } else {
            show()
        }
    }
    
    /// Present view controller
    private func present(_ viewController: UIViewController, transitioning: UIViewControllerTransitioningDelegate? = nil) {
        let lastController = navigationController?.viewControllers.last
        var lastPresentedController = lastController?.presentedViewController
        while lastPresentedController?.presentedViewController != nil {
            lastPresentedController = lastPresentedController?.presentedViewController
        }
        let topController = lastPresentedController ?? lastController ?? navigationController ?? self
        
        if let transitioning {
            viewController.transitioningDelegate = transitioning
            viewController.modalPresentationStyle = .custom
        }
        
        topController.present(viewController, animated: true, completion: nil)
    }
    
}
