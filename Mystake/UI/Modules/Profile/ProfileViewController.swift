//
//  ProfileViewController.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import UIKit
import Combine

final class ProfileViewController: ViewController {
    
    // MARK: - UI Components
    
    private let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = Icons.profile2
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 61
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let addImageButton: Button = {
        let btn = Button()
        btn.image = Icons.plus
        return btn
    }()
    
    private let policyView: ProfileActionView = {
        let view = ProfileActionView()
        return view
    }()
    
    private let termsView: ProfileActionView = {
        let view = ProfileActionView()
        return view
    }()
    
    
    // MARK: - Properties
    
    /// View model
    private let viewModel: ProfileViewModel
    
    /// On image selected
    private let onImageSelected = PassthroughSubject<UIImage?, Never>()
    
    
    // MARK: - Initialization
    
    /// Initialization
    override init() {
        viewModel = .init()
        super.init()
    }
    
    /// Initialization with coder
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View lifecycle
    
    /// Model binding
    override func bind() {
        super.bind()
        
        addImageButton.onTap
            .sink { [weak self] in
                self?.addUserImage()
            }.store(in: &bag)
        
        onImageSelected
            .assign(value: viewModel.onUpdateImageCommand)
            .store(in: &bag)
        
        viewModel.userImageDriver
            .map { $0 ?? Icons.profile2 }
            .assign(to: \.image, on: userImageView)
            .store(in: &bag)
        
        viewModel.policyModelDriver
            .sink(policyView.bind)
            .store(in: &bag)
        
        viewModel.termsModelDriver
            .sink(termsView.bind)
            .store(in: &bag)
        
        viewModel.onShowPolicy
            .sink { [weak self] in
                self?.showPrivacyPolicy()
            }.store(in: &bag)
        
        viewModel.onShowTerms
            .sink { [weak self] in
                self?.showTermsOfRules()
            }.store(in: &bag)
    }
    
    override func setupView() {
        super.setupView()
        let navigation = navigationController as? NavigationController
        navigation?.headline = "MY PROFILE"
    }
    
    /// Layout setups
    override func setupLayout() {
        super.setupLayout()
        
        let actionsStackView = UIStackView(axis: .vertical)
        
        view.addSubviews([userImageView, addImageButton, actionsStackView])
        actionsStackView.addArrangedSubviews([policyView, termsView])
        
        userImageView.snp.make { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(122)
        }
        
        addImageButton.snp.make { make in
            make.trailing.bottom.equalTo(userImageView).inset(-3)
            make.size.equalTo(34)
        }
        
        actionsStackView.snp.make { make in
            make.top.equalTo(userImageView.snp.bottom).offset(45)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        policyView.snp.make { make in
            make.height.equalTo(60)
        }
        
        termsView.snp.make { make in
            make.height.equalTo(60)
        }
    }
    
}

// MARK: - Public actions
extension ProfileViewController {
    
    /// Add user image
    private func addUserImage() {
        showImageSelection(onSelect: onImageSelected)
    }
    
}

// MARK: - Flow
extension ProfileViewController {
    
    /// Show image selection
    private func showImageSelection(onSelect: PassthroughSubject<UIImage?, Never>) {
        show(SelectionImageViewController(onSelect: onSelect, onClosed: nil), as: .modal)
    }
    
    /// Show privacy policy
    func showPrivacyPolicy() {
        // TODO: add privacy policy redirect
    }
    
    /// Show terms of rules
    func showTermsOfRules() {
        // TODO: add terms of rules redirect
    }
    
}
