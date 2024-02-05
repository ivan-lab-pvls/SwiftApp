//
//  RemoteViewController.swift
//  Mystake
//
//  Created by Vladko on 23.01.2024.
//

import UIKit
import WebKit

final class RemoteViewController: ViewController {
    
    // MARK: - UI Components
    
    /// Web view
    private let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let view = WKWebView(frame: .zero, configuration: config)
        return view
    }()
    
    
    // MARK: - Properties
    
    private let viewModel: RemoteViewModel
    
    
    // MARK: - Initialization
    
    /// Intialization
    init(source: String) {
        self.viewModel = .init(source: source)
        super.init()
    }
    
    /// Initialization with coder
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View lifecyle
    
    /// Model binding
    override func bind() {
        super.bind()
        
        viewModel.urlDriver
            .compactMap { $0 }
            .map { URLRequest(url: $0) }
            .sink(webView.load)
            .store(in: &bag)
    }
    
    /// Lyouts setups
    override func setupLayout() {
        super.setupLayout()
        
        view.addSubview(webView)
        
        webView.snp.make { make in
            make.edges.equalToSuperview()
        }
    }

}
