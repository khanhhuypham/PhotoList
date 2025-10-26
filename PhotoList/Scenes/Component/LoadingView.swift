//
//  LoadingView.swift
//  PhotoList
//
//  Created by Pham Khanh Huy on 23/10/25.
//

import UIKit


class LoadingView: UIView {
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    private var isPresenting = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        alpha = 0.0
        setupIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupIndicator() {
        addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func present() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            
            if self.isPresenting { return }
            
            self.frame = window.bounds
            window.addSubview(self)
            self.fadeIn()
        }
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            guard self.isPresenting else { return }
            self.fadeOut()
        }
    }
    
    private func fadeIn() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1.0
        } completion: { _ in
            self.isPresenting = true
        }
    }
    
    private func fadeOut() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0.0
        } completion: { _ in
            self.isPresenting = false
            self.removeFromSuperview()
        }
    }
}


final class Loading {
    static let shared = LoadingView()
    
    static func show() {
        DispatchQueue.main.async {
            shared.present()
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            shared.dismiss()
        }
    }
}
