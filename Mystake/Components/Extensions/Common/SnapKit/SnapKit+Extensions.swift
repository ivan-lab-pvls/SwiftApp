//
//  SnapKit+Extensions.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import SnapKit

extension ConstraintViewDSL {
    
    /// Make constraints
    func make(closure: (ConstraintMaker) -> Void) {
        makeConstraints(closure)
    }
    
    /// Remake constraints
    func remake(closure: (ConstraintMaker) -> Void) {
        remakeConstraints(closure)
    }
    
}
