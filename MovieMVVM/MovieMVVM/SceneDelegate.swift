// SceneDelegate.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let navController = UINavigationController(rootViewController: MovieViewController())
        window.rootViewController = navController
        self.window = window
        window.backgroundColor = .systemBackground
        window.makeKeyAndVisible()
    }
}
