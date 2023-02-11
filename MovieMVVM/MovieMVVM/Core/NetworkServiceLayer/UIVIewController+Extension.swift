// UIVIewController+Extension.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// Экстеншен для универсального алерта
extension UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let actionTitle = "Ок"
        static let addTitle = "Введите ключ для получения доустпа"
        static let addKetPlaceholder = "Введите ключ"
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

    func saveKeyAlert(completion: @escaping StringHandler) {
        let alert = UIAlertController(title: Constants.addTitle, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.addActionTitle, style: .default) { _ in
            guard let key = alert.textFields?.first?.text else { return }
            completion(key)
        })
        alert.addTextField { tf in
            tf.placeholder = Constants.addKetPlaceholder
            tf.isSecureTextEntry = true
        }
        present(alert, animated: true)
    }
}
