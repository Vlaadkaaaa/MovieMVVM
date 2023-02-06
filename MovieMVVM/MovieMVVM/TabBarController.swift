// TabBarController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Tab Bar
final class TabBarController: UITabBarController {
    // MARK: Private Constants

    private enum Constants {
        static let movieTitle = "Фильмы"
        static let profileTitle = "Профиль"
        static let movieImageName = "film.fill"
        static let popcornImageName = "popcorn.circle.fill"
        static let personImageName = "person.fill"
    }

    // MARK: Private Property

    private let movieVC = MovieViewController()
    private let personVC = PersonViewController()

    // MARK: - Lyfe Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        showMoviesTabBar()
    }

    // MARK: Private Methods

    private func showMoviesTabBar() {
        let movieNavController = UINavigationController(rootViewController: movieVC)
        let personNavController = UINavigationController(rootViewController: personVC)
        setViewControllers([movieNavController, personNavController], animated: true)
        movieNavController.tabBarItem = UITabBarItem(
            title: Constants.movieTitle,
            image: UIImage(systemName: Constants.movieImageName),
            tag: 0
        )
        personNavController.tabBarItem = UITabBarItem(
            title: Constants.profileTitle,
            image: UIImage(systemName: Constants.personImageName),
            tag: 1
        )
        tabBar.backgroundColor = .systemBackground
    }
}
