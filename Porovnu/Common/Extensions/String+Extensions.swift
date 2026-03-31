//
//  String+Extensions.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 10.02.2026.
//

import Foundation

extension String {
    static func amountString(_ amount: Int) -> String {
        let decimalAmount = Decimal(amount) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ""
        return formatter.string(from: decimalAmount as NSDecimalNumber) ?? "0.00"
    }

    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
