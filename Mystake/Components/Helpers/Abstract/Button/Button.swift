//
//  Button.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit

class Button: UIButton {
    
    // MARK: - UI Components
    
    private let gradientView: GradientView = {
        let view = GradientView()
        view.isUserInteractionEnabled = false
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    

    // MARK: - Properties
    
    /// Font
    var font: UIFont? {
        get { titleLabel?.font }
        set { titleLabel?.font = newValue }
    }
    
    /// Text color
    var textColor: UIColor? {
        get { titleColor(for: .normal) }
        set {
            setTitleColor(newValue, for: .normal)
            setTitleColor(newValue?.withAlphaComponent(0.5), for: .highlighted)
            setTitleColor(newValue?.withAlphaComponent(0.5), for: .disabled)
        }
    }
    
    /// Title (notmal state)
    var title: String? {
        get { title(for: .normal) }
        set { setTitle(newValue, for: .normal) }
    }
    
    /// Image (notmal state)
    var image: UIImage? {
        get { image(for: .normal) }
        set { setImage(newValue, for: .normal) }
    }
    
    /// Image padding
    var imagePadding: CGFloat? {
        didSet { setupPadding() }
    }
    
    /// Horizontal padding
    var horizontalPadding: CGFloat? {
        didSet { setupPadding() }
    }
    
    /// Image size
    var imageSize: ImageSize = .none {
        didSet {
            setImage(image(for: .normal), for: .normal)
            setImage(image(for: .selected), for: .selected)
        }
    }
    
    /// Gradient
    var gradient: Gradient? = nil {
        didSet {
            gradientView.gradient = gradient ?? .solid(color: .clear)
        }
    }
    
    
    // MARK: - Overrided properties
    
    /// Is enabled
    override var isEnabled: Bool {
        didSet { alpha = isEnabled ? 1 : 0.65 }
    }
    
    /// Corner radius
    var cornerRadius: CGFloat {
        get { gradientView.layer.cornerRadius }
        set { gradientView.layer.cornerRadius = newValue }
    }
    
    var borderColor: CGColor? {
        get { gradientView.layer.borderColor }
        set { gradientView.layer.borderColor = newValue }
    }
    
    override var backgroundColor: UIColor? {
        get { gradientView.backgroundColor }
        set { gradientView.backgroundColor = newValue }
    }
    
    
    // MARK: - Initialization
    
    /// Initialization with frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    /// Initialization with coder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    /// Common initialization
    private func commonInit() {
        layer.masksToBounds = true
        setupLayouts()
    }
    
    
    // MARK: - Lifecycle
    
    /// Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        sendSubviewToBack(gradientView)
        setupPadding()
    }
    
    /// Set image for state
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        var imageSize: CGSize?
        
        switch self.imageSize {
        case .to(let size):
            imageSize = size
        case .none:
            break
        }
        
        if let imageSize {
            let image = image?.resizedImage(with: imageSize)
            super.setImage(image, for: state)
        } else {
            super.setImage(image, for: state)
        }
    }
    
}

// MARK: - Setups
extension Button {
    
    /// Setup padding
    internal func setupPadding() {
        guard imagePadding != nil || horizontalPadding != nil else { return }
        
        let rtl = semanticContentAttribute == .forceRightToLeft
        let horizontalPadding = horizontalPadding ?? 0
        let padding = image == nil ? 0 : imagePadding ?? 0
        
        contentEdgeInsets = rtl ?
            .init(left: padding + horizontalPadding, right: horizontalPadding) :
            .init(left: horizontalPadding, right: padding + horizontalPadding)
        
        titleEdgeInsets = rtl ?
            .init(left: -padding, right: padding) :
            .init(left: padding, right: -padding)
    }
    
    /// Layouts setups
    internal func setupLayouts() {
        gradientView.frame = bounds
        addSubview(gradientView)
        sendSubviewToBack(gradientView)
    }
    
}
