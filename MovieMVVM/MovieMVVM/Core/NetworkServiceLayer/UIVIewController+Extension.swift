// UIVIewController+Extension.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// Экстеншен для универсального алерта
extension UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let actionTitle = "Ок"
        static let addTitle = "Введите ключ для получения доустпа"
        static let addActionTitle = "Добавить"
        static let defaultTitle = "Ошибка"
    }

    // MARK: - Public methods

    func showAlert(title: String? = Constants.defaultTitle, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alercAction = UIAlertAction(title: Constants.actionTitle, style: .default, handler: nil)
        alert.addAction(alercAction)
        present(alert, animated: true)
    }
}
