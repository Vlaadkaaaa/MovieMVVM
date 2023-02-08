// SceneDelegate.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: ApplicationCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
        let bilder = Bilder()
        let navController = UINavigationController()
        coordinator = ApplicationCoordinator(navigationController: navController, bilder: bilder)
        coordinator?.start()
    }
}
