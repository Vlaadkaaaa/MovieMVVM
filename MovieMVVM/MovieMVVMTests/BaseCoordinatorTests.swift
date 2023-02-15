// BaseCoordinatorTests.swift
// Copyright © Vlaadkaaaa. All rights reserved.

@testable import MovieMVVM
import XCTest

/// Тесты для координатора
final class BaseCoordinatorTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let countChildCoordinatorNumber = 1
    }

    // MARK: - Private Property

    private var mockCoordinator: MockCoordinator?
    private var baseCoordinator: BaseCoordinator?

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockCoordinator = MockCoordinator()
        baseCoordinator = BaseCoordinator()
    }

    func testAddDependency() {
        guard let mockCoordinator else { return }
        baseCoordinator?.addDependency(mockCoordinator)
        XCTAssertEqual(baseCoordinator?.childCoordinators.count, Constants.countChildCoordinatorNumber)
    }

    func testRemoveDependency() {
        guard let mockCoordinator else { return }
        baseCoordinator?.addDependency(mockCoordinator)
        guard let baseCoordinator else { return }
        XCTAssertFalse(baseCoordinator.childCoordinators.isEmpty)
        baseCoordinator.removeDependency(mockCoordinator)
        XCTAssertTrue(baseCoordinator.childCoordinators.isEmpty)
    }
}
