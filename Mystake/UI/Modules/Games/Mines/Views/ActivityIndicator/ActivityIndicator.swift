//
//  ActivityIndicator.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit

public class ActivityIndicatorView: UIView {
    
    // MARK: - UI Components

    /// Indicator
    private let indicator = CAShapeLayer()
    
    /// Gradient layer
    private var gradientLayer: CAGradientLayer?
    
    /// Animator
    private let animator = ActivityIndicatorAnimator()
    
    
    // MARK: - Properties
    
    /// Gradient
    private var gradient: Gradient

    /// Line width
    private let lineWidth: CGFloat = 5.0
    
    /// Is animating
    private var isAnimating = false
    
    
    // MARK: - Initialization
    
    /// Initialization
    init(gradient: Gradient) {
        self.gradient = gradient
        super.init(frame: .zero)
        self.setup()
    }

    override init(frame: CGRect) {
        self.gradient = .solid(color: .red)
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        self.gradient = .solid(color: .red)
        super.init(coder: aDecoder)
        self.setup()
    }
    
    // MARK: - Setups

    /// Setups
    private func setup() {
        indicator.strokeColor = UIColor.white.cgColor
        indicator.fillColor = nil
        indicator.lineWidth = lineWidth
        indicator.strokeStart = 0.0
        indicator.strokeEnd = 0.0
        
        gradientLayer = gradient.linearGradient
        gradientLayer?.frame = bounds
        gradientLayer?.mask = indicator
        layer.addSublayer(gradientLayer!)
    }
    
}

extension ActivityIndicatorView {
    
    /// Intrinsic content size
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 24, height: 24)
    }

    /// Layout subviews
    override public func layoutSubviews() {
        super.layoutSubviews()

        indicator.frame = bounds
        gradientLayer?.frame = bounds

        let diameter = bounds.size.min - indicator.lineWidth
        let path = UIBezierPath(center: bounds.center, radius: diameter / 2)
        indicator.path = path.cgPath
        gradientLayer?.mask = indicator
    }
    
}

// MARK: - Public actions
extension ActivityIndicatorView {
    
    /// Start animating
    func startAnimating() {
        guard !isAnimating else { return }

        animator.addAnimation(to: indicator)
        isAnimating = true
    }

    /// Stop animating
    func stopAnimating() {
        guard isAnimating else { return }

        animator.removeAnimation(from: indicator)
        isAnimating = false
    }
    
}
