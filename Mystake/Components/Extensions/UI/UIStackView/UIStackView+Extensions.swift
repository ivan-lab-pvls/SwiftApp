//
//  UIStackView+Extensions.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit

extension UIStackView {
    
    /// Add arranged subviews
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
    
    /// Init with parameters
    convenience
    init(axis: NSLayoutConstraint.Axis,
         spacing: CGFloat = 0,
         alignment: Alignment = .fill,
         distribution: Distribution = .fill)
    {
        self.init()
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
    
}
