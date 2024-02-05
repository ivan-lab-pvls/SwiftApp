//
//  GradientLabel.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import UIKit

final class GradientLabel: Label {
    
    /// Gradient color
    private var gradient: Gradient
    
    /// Text color layer
    private let textColorLayer: CAGradientLayer = .init()
    
    
    // MARK: - Overrides
    
    /// Text
    override var text: String? {
        didSet {
            setupColors()
        }
    }
    
    
    // MARK: - Initialization
    
    /// Intialization
    init(gradient: Gradient) {
        self.gradient = gradient
        super.init(frame: .zero)
    }
    
    /// Intialization
    override init(frame: CGRect) {
        self.gradient = .solid(color: .clear)
        super.init(frame: frame)
        setup()
    }
    
    /// Intialization
    required init?(coder: NSCoder) {
        self.gradient = .solid(color: .clear)
        super.init(coder: coder)
        setup()
    }
    
    
    // MARK: - View lifecycle
    
    /// Intialization
    override func layoutSubviews() {
        super.layoutSubviews()
        setupColors()
    }
    
}

// MARK: - Setups
extension GradientLabel {
    
    /// View setups
    private func setup() {
        isAccessibilityElement = true
        setupColors()
    }
    
    /// Apply colors
    private func setupColors() {
        let gradient = setupGradientLayer(bounds: self.bounds)
        let color = UIColor(bounds: bounds, gradientLayer: gradient)
        
        textColor = color
        
        if let attributedText, let color {
            let attributedString = NSMutableAttributedString(attributedString: attributedText)
            attributedString.addAttribute(.foregroundColor, value: color, range: .init(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
    }
    
    /// Setup gradient layer
    private func setupGradientLayer(bounds: CGRect) -> CAGradientLayer {
        textColorLayer.frame = bounds
        textColorLayer.colors = gradient.colors.map{ $0.cgColor }
        textColorLayer.startPoint = gradient.startPoint
        textColorLayer.endPoint = gradient.endPoint
        return textColorLayer
    }
    
}

// MARK: - Public functions
extension GradientLabel {
    
    /// Update gradient
    func update(gradient: Gradient) {
        self.gradient = gradient
        setupColors()
    }
    
}

extension UIColor {
    
    /// Init gradient color
    convenience init?(bounds: CGRect, gradientLayer: CAGradientLayer) {
        let size = CGSize(width: max(gradientLayer.bounds.size.width, .leastNonzeroMagnitude),
                          height: max(gradientLayer.bounds.size.height, .leastNonzeroMagnitude))
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        gradientLayer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        self.init(patternImage: image)
    }
    
}
