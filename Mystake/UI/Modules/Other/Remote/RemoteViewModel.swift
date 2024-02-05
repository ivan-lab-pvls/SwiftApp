//
//  RemoteViewModel.swift
//  Mystake
//
//  Created by Vladko on 23.01.2024.
//

import Foundation
import Combine

final class RemoteViewModel: ViewModel {
    
    // MARK: - Outputs
    
    /// URL
    private let url = CurrentValueSubject<URL?, Never>(nil)
    var urlDriver: Driver<URL?, Never> { url.asDriver() }
    
    
    // MARK: - Properties
    
    /// Source
    private let source: CurrentValueSubject<String?, Never>
    
    
    // MARK: - Initialization
    
    /// Intiialization
    init(source: String) {
        self.source = .init(source)
        super.init()
    }
    
    /// Bind data
    override func bindData() {
        super.bindData()
        
        source
            .map { $0 ?? "" }
            .map { URL(string: $0) }
            .assign(value: url)
            .store(in: &bag)
    }
    
}
