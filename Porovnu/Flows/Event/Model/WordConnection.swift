//
//  WordConnection.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 13.02.2026.
//

import Foundation

/// Модель для связи между словами
struct WordConnection: Identifiable {
    let id = UUID()
    let sourceWord: String
    let targetWords: [String]

    init(sourceWord: String, targetWords: [String]) {
        self.sourceWord = sourceWord
        self.targetWords = targetWords
    }
}
