//
//  GradientView.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit

final class GradientView: UIView {
    
    // MARK: - Properties
    
    /// Gradient
    var gradient: Gradient {
        didSet {
            commonInit()
        }
    }
    
    /// Gradient layer
    private var gradientLayer: CAGradientLayer?
    
    
    // MARK: - Lifecycle
    
    /// Initialization
    init(gradient: Gradient) {
        self.gradient = gradient
        super.init(frame: .zero)
        commonInit()
    }
    
    /// Initialization with frame
    override init(frame: CGRect) {
        self.gradient = .solid(color: .clear)
        super.init(frame: frame)
        commonInit()
    }
    
    /// Initialization with coder
    required init?(coder: NSCoder) {
        self.gradient = .solid(color: .clear)
        super.init(coder: coder)
        commonInit()
    }
    
    
    /// Common init
    private func commonInit() {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = gradient.linearGradient
        gradientLayer?.frame = bounds
        layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
    
}
