//
//  TabBarController.swift
//  Mystake
//
//  Created by Vladko on 17.01.2024.
//

import UIKit
import Combine

class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
    /// Cancellable bag
    internal var bag = Set<AnyCancellable>()
    
    
    /// On did load
    internal let onDidLoad = PassthroughSubject<Void, Never>()
    
    /// On will appear
    internal let onWillAppear = PassthroughSubject<Void, Never>()
    
    /// On will disappear
    internal let onWillDisappear = PassthroughSubject<Void, Never>()
    
    
    // MARK: - Initialization
    
    /// Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Initialization with coder
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View lifecycle
    
    /// View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupView()
        setupLayout()
        onDidLoad.send()
    }
    
    /// View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onWillAppear.send()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onWillDisappear.send()
    }
    
    
    // MARK: - Setups
    
    /// Setup model
    internal func bind() {
        bag.removeAll()
    }
    
    /// View setups
    internal func setupView() {
        view.backgroundColor = .background1
    }
    
    /// Setup layout
    internal func setupLayout() {}
    
}
