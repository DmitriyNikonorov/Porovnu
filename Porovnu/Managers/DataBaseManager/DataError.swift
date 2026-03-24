//
//  DataError.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 21.02.2026.
//

import Foundation

enum DataError: Error, LocalizedError {
    case noContext
    case contributorNotFound(UUID)
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .noContext:
            "Нет modelContext"

        case .contributorNotFound(let id):
            "Contributor \(id) не найден"

        case .saveFailed:
            "Ошибка сохранения"
        }
    }
}
