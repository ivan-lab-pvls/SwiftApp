//
//  ProfileViewModel.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import UIKit
import Combine

final class ProfileViewModel: ViewModel {
    
    // MARK: - Inputs
    
    /// On add image
    let onUpdateImageCommand = PassthroughSubject<UIImage?, Never>()
    
    
    // MARK: - Outputs
    
    /// User image
    private let userImage = CurrentValueSubject<UIImage?, Never>(nil)
    var userImageDriver: Driver<UIImage?, Never> { userImage.asDriver() }
    
    /// Policy model
    private var policyModel = CurrentValueSubject<ProfileActionModel, Never>(.init(title: "Privacy Policy"))
    var policyModelDriver: Driver<ProfileActionModel, Never> { policyModel.asDriver() }
    
    /// Terms model
    private var termsModel = CurrentValueSubject<ProfileActionModel, Never>(.init(title: "Terms Of Use"))
    var termsModelDriver: Driver<ProfileActionModel, Never> { termsModel.asDriver() }
    
    /// Show policy
    let onShowPolicy = PassthroughSubject<Void, Never>()
    
    /// Show terms
    let onShowTerms = PassthroughSubject<Void, Never>()
    
    
    // MARK: - Properties
    
    /// User service
    private let userService = UserService.shared
    
    
    // MARK: - Initialization
    
    /// Bind actions
    override func bindActions() {
        super.bindActions()
        
        onUpdateImageCommand
            .compactMap { $0 }
            .sink(userService.updateUserImage)
            .store(in: &bag)
        
        policyModel.value.onSelect
            .assign(value: onShowPolicy)
            .store(in: &bag)
        
        termsModel.value.onSelect
            .assign(value: onShowTerms)
            .store(in: &bag)
    }
    
    /// Bind data
    override func bindData() {
        super.bindData()
        
        userService.userImage
            .assign(value: userImage)
            .store(in: &bag)
    }
    
}
