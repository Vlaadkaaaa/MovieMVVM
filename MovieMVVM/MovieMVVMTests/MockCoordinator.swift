// MockCoordinator.swift
// Copyright © Vlaadkaaaa. All rights reserved.

@testable import MovieMVVM
import UIKit

/// Мок координатор
final class MockCoordinator: BaseCoordinator {
    // MARK: - Piblic Method

    override func addDependency(_ coordinator: BaseCoordinator) {
        childCoordinators.append(coordinator)
    }

    override func removeDependency(_ coordinator: BaseCoordinator?) {
        childCoordinators.removeAll()
    }
}
