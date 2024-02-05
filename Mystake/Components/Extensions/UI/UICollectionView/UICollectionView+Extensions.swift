//
//  UICollectionView+Extensions.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit

extension UICollectionView {
    
    /// Register collection view cell
    func register<T: UICollectionViewCell>(_ type: T.Type) {
        register(type, forCellWithReuseIdentifier: String(describing: type.self))
    }
    
    /// Register
    func registerHeader<T: UICollectionReusableView>(_ type: T.Type) {
        register(type, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: "\(type.self)")
    }
    
    /// Dequeue table view cell
    func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: String(describing: type.self), for: indexPath) as! T
    }
    
    /// Dequeue header
    func dequeueReusableHeader<T: UICollectionReusableView>(_ type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                withReuseIdentifier: "\(type.self)",
                                                for: indexPath) as! T
    }
    
}
