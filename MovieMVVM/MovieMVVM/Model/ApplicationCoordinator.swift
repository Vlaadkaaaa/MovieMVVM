// ApplicationCoordinator.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Главный координатор
final class ApplicationCoordinator: BaseCoordinator {
    // MARK: - Public Property

    var bilder: BilderProtocol?

    // MARK: - Init

    convenience init(biler: BilderProtocol?) {
        self.init()
        bilder = biler
    }

    // MARK: - Public Method

    override func start() {
        toMovieCoordinator()
    }

    // MARK: - Private Method

    private func toMovieCoordinator() {
        guard let bilder else { return }
        let coordinator = MovieCoordinator(bilder: bilder)
        coordinator.onFinishFlowHandler = { [weak self, weak coordinator] in
            guard let self else { return }
            self.removeDependency(coordinator)
            self.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }
}
