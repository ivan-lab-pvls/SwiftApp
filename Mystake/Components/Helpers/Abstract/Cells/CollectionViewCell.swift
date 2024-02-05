//
//  CollectionViewCell.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import UIKit
import Combine

class CollectionViewCell<M: ViewModel>: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// View model
    private(set) var viewModel: M!
    
    /// Cancellable bag
    internal var bag = Set<AnyCancellable>()
    
    
    // MARK: - Initializations
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    /// Initialization with coder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    /// Common initialization
    private func commonInit() {
        setupView()
        setupLayouts()
    }
    
    
    // MARK: - Setups
    
    /// Model binding
    func bind(_ viewModel: M) {
        self.viewModel = viewModel
        bag.removeAll()
    }
    
    /// View setups
    internal func setupView() {
        backgroundColor = .clear
    }
    
    /// Layouts setups
    internal func setupLayouts() {}
    
}
