//
//  UITableView+Extensions.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit

extension UITableView {
    
    /// Register table view cell
    func register<T: UITableViewCell>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: String(describing: type.self))
    }
    
    /// Dequeue table view cell
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type) -> T {
        dequeueReusableCell(withIdentifier: String(describing: type.self)) as! T
    }
    
    /// Dequeue table view cell
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: String(describing: type.self), for: indexPath) as! T
    }
    
}
