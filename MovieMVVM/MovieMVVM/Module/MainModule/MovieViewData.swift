// MovieViewData.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Состояния главного экрана
enum MovieViewData {
    case loading
    case success([Movie])
    case failure(error: Error)
}
