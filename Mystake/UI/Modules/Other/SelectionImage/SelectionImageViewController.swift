//
//  SelectionImageViewController.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import UIKit
import Combine
import Photos
import AVFoundation

final class SelectionImageViewController: ViewController {
    
    // MARK: - Properties
    
    /// View model
    private let viewModel: SelectionImageViewModel
    
    /// On select image
    private let onSelect: PassthroughSubject<UIImage?, Never>
    
    /// On closed selection
    private let onClosed: PassthroughSubject<Void, Never>?
    
    
    // MARK: - Initialization
    
    /// Initialization
    init(onSelect: PassthroughSubject<UIImage?, Never>, onClosed: PassthroughSubject<Void, Never>?) {
        self.viewModel = .init()
        self.onSelect = onSelect
        self.onClosed = onClosed
        super.init()
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    /// Initialization with coder
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - View lifecycle
    
    /// View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        showSelection()
    }
    
    /// View setups
    override func setupView() {
        super.setupView()
        view.backgroundColor = .clear
    }
    
}

// MARK: - Private actions
extension SelectionImageViewController {
    
    /// Show selection
    func showSelection() {
        var isLibraryAvaliable = false
        var isCameraAvaliable = false
        
        let group = DispatchGroup()
        
        group.enter()
        requestPhotoLibraryAccess { avaliable in
            isLibraryAvaliable = avaliable
            group.leave()
        }
        
        group.enter()
        requestCameraAccess { avaliable in
            isCameraAvaliable = avaliable
            group.leave()
        }
        
        group.notify(queue: .main) {
            let actions: [SelectionImageActionSource] = [
                .init(action: .camera, isAvaliable: isCameraAvaliable),
                .init(action: .library, isAvaliable: isLibraryAvaliable)
            ]
            
            self.showActionsSelection(actions)
        }
    }
    
}

// MARK: - Private actions
extension SelectionImageViewController {
    
    /// Request photo library access
    private func requestPhotoLibraryAccess(callback: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            callback(status == .authorized)
        }
    }
    
    /// Request photo library access
    private func requestCameraAccess(callback: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            callback(response)
        }
    }
    
    /// Show actions selection
    private func showActionsSelection(_ sources: [SelectionImageActionSource]) {
        let isPhone = UIDevice.current.userInterfaceIdiom == .phone
        let style: UIAlertController.Style = isPhone ? .actionSheet : .alert
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: style)
        
        let actions = sources.map { source in
            UIAlertAction(title: source.action.title, style: .default) { _ in
                if source.isAvaliable {
                    self.showImagePicker(by: source.action)
                } else {
                    self.showSettingsAlert()
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.close()
        }
        
        (actions + [cancel]).forEach {
            alert.addAction($0)
        }
        
        show(alert, as: .modal)
    }
    
    /// Show image picker
    private func showImagePicker(by action: SelectionImageAction) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.presentationController?.delegate = self
        imagePicker.sourceType = action.sourceType
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image"]
        show(imagePicker, as: .modal)
    }
    
    /// Show settings alert
    private func showSettingsAlert() {
        let title = "No access"
        let description = "To be able to choose a photo, go to settings and grant access"
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
            self.close()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.close()
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        show(alert, as: .modal)
    }
    
    /// Close module
    private func close(with image: UIImage? = nil) {
        self.onSelect.send(image?.fixedOrientation)
        self.onClosed?.send()
        dismiss()
    }
    
}

// MARK: - UIImagePickerControllerDelegate
extension SelectionImageViewController: UIImagePickerControllerDelegate {
    
    /// Image picker did finish picking media
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let image = info[.editedImage] as? UIImage
        imagePickerDidSelectImage(image)
    }
    
    /// Image picker did cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerDidSelectImage(nil)
    }
    
    /// Image picked did select image
    func imagePickerDidSelectImage(_ image: UIImage?) {
        dismiss {
            self.close(with: image)
        }
    }
    
}

// MARK: - UINavigationControllerDelegate, UIAdaptivePresentationControllerDelegate
extension SelectionImageViewController: UINavigationControllerDelegate, UIAdaptivePresentationControllerDelegate {
    
    /// Adaptive presentation style
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .fullScreen
    }
    
    /// Presentation controller did dismiss
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        close()
    }
    
}
