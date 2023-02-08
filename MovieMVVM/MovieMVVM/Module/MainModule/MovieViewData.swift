// MovieViewData.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import Foundation

/// Состояния главного экрана
enum MovieViewData {
    /// Получение данных
    case loading
    /// Успешная загрузка
    case success([Movie])
    /// Ошибка
    case failure(error: Error)
}
