// MovieCoordinator.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// Координатор для главного экрана
final class MovieCoordinator: BaseCoordinator {
    // MARK: - Public Property

    var onFinishFlowHandler: VoidHandler?

    // MARK: - Private Properties

    private var bilder: BilderProtocol
    private var navigationController: UINavigationController?

    // MARK: - Init

    init(navigationController: UINavigationController? = nil, bilder: BilderProtocol) {
        self.navigationController = navigationController
        self.bilder = bilder
    }

    // MARK: - Public methods

    override func start() {
        showMainModule()
    }

    // MARK: - Private Methods

    private func showMainModule() {
        guard let controller = bilder.createMainModule() as? MovieViewController else { return }
        controller.toDetailViewControllerHandler = { [weak self] movie in
            guard let self else { return }
            self.showDetailModule(movie: movie)
        }
        let rootVC = UINavigationController(rootViewController: controller)
        setAsRoot(rootVC)
        navigationController = rootVC
    }

    private func showDetailModule(movie: Movie) {
        let detailController = bilder.createDetailModule(movie: movie)
        navigationController?.pushViewController(detailController, animated: true)
    }
}
