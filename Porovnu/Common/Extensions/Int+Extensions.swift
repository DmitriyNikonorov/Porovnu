//
//  Int+Extensions.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 31.03.2026.
//

import Foundation

extension Int {
    static func amountFrom(_ string: String) -> Int? {
        guard
            let doubleAmount = Double(string.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "."))
        else {
            return nil
        }

        return Int(doubleAmount * 100)
    }


    var isZero: Bool {
        self == 0
    }
}
