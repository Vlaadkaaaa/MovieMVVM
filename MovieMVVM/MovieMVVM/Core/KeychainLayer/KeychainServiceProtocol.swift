// KeychainServiceProtocol.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Протокол для   менеджера работы с критическими данными
protocol KeychainServiceProtocol {
    func saveKey(name: String)
    func fetchKey(name: String) -> String
}
