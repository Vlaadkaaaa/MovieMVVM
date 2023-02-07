// UIButton+Extension.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// Расширение для создания градиента на кнопке
extension UIButton {
    func applyGradient(colors: [CGColor]) {
        backgroundColor = nil
        layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.7, y: 0.7)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 35
        layer.insertSublayer(gradientLayer, at: 0)
        imageView?.tintColor = .white
        contentVerticalAlignment = .center
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
    }
}
