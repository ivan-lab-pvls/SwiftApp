//
//  NavigationController.swift
//  Mystake
//
//  Created by Vladko on 17.01.2024.
//

import UIKit
import Combine

class NavigationController: UINavigationController {
    
    
    // MARK: - Properties
    
    /// Cancellable bag
    internal var bag = Set<AnyCancellable>()
    
    
    /// On did load
    internal let onDidLoad = PassthroughSubject<Void, Never>()
    
    /// On will appear
    internal let onWillAppear = PassthroughSubject<Void, Never>()
    
    /// On will disappear
    internal let onWillDisappear = PassthroughSubject<Void, Never>()
    
    
    // MARK: - Properties
    
    /// Headline
    var headline: String = "" {
        didSet {
            setupNavigation()
        }
    }
    
    override var viewControllers: [UIViewController] {
        didSet {
            setupNavigation()
        }
    }
    
    
    // MARK: - Initialization
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        print("Init: ", viewControllers)
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
        setupNavigation()
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
    
    /// Setup navigation
    internal func setupNavigation() {
        viewControllers.forEach {
            let lbl = Label()
            lbl.textColor = .white
            lbl.font = .systemFont(ofSize: 16, weight: .bold)
            lbl.text = headline
            
            let bv = BalanceView()
            bv.bind(.init())
            
            let btn = Button(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
            btn.setImage(Icons.chevronLeft, for: .normal)
            btn.onTap
                .sink { [weak self] in self?.popViewController(animated: true) }
                .store(in: &bag)
            
            $0.navigationItem.leftBarButtonItems = viewControllers.count > 1 ? [.init(customView: btn), .init(customView: lbl)] : [.init(customView: lbl)]
            $0.navigationItem.rightBarButtonItem = .init(customView: bv)
        }
    }
    
}
