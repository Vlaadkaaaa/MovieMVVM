// Handlers.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Псевлонимы типов
typealias CastsHandler = ([Cast]) -> Void
typealias MovieDataHandler = (MovieViewData) -> Void
typealias MovieDataStringHandler = (Movie, Data, String) -> Void
typealias StringHandler = (String) -> Void
typealias DataHandler = (Data) -> Void
typealias CastHandler = (String, String, Data) -> Void
typealias VoidHandler = () -> (Void)
