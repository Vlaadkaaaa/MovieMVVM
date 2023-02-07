// MovieViewData.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

///
enum MovieViewData {
    case loading
    case success([Movie])
    case failure(error: Error)
}
