//
//  Double+Extensions.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 17.02.2026.
//

import Foundation

extension Double {
    static func amountFrom(_ string: String) -> Double? {
        Double(string.replacingOccurrences(of: ",", with: "."))
    }
}
