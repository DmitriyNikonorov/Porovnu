//
//  String+Extensions.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 10.02.2026.
//

import Foundation

extension String {

    static func amountString(_ amount: Double) -> String {
        String(format: "%.2f", amount)
    }

    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
