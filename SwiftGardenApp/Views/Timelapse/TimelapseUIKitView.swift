//
//  TimelapseUIKitView.swift
//  SwiftGardenApp
//
//  Created by Yugo Sugiyama on 2023/08/16.
//

import UIKit
import SwiftUI
import SwiftExtensions

struct TimelapseRepresentable: UIViewRepresentable {
    typealias UIViewType = TimelapseUIKitView
    @Binding var images: [UIImage]
    
    func makeUIView(context: Context) -> UIViewType {
        return TimelapseUIKitView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.setImaegs(images: images)
    }
}

final class TimelapseUIKitView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.addConstraint(type: .height(height: 48))
        return button
    }()
    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("Stop", for: .normal)
        button.addConstraint(type: .height(height: 48))
        return button
    }()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private(set) var images: [UIImage] = [] {
        didSet {
            activityIndicatorView.isHidden = !images.isEmpty
            imageView.animationImages = images
            imageView.image = images.first
            imageView.animationDuration = TimeInterval(floatLiteral: Double(images.count) * 0.2)
            startButton.isHidden = images.isEmpty
            stopButton.isHidden = images.isEmpty
        }
    }
    
    init(images: [UIImage] = []) {
        super.init(frame: .zero)
        self.images = images
        
        startButton.addAction(.init(handler: { [weak self] _ in
            self?.imageView.startAnimating()
        }), for: .touchUpInside)
        stopButton.addAction(.init(handler: { [weak self] _ in
            self?.imageView.stopAnimating()
        }), for: .touchUpInside)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        addEdgeConstrainedSubView(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(startButton)
        stackView.addArrangedSubview(stopButton)
        
        addEdgeConstrainedSubView(activityIndicatorView)
    }
    
    func setImaegs(images: [UIImage]) {
        self.images = images
    }
}
