//
//  Double+Extensions.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 17.02.2026.
//

import Foundation

extension Double {
    static func amountFrom(_ string: String) -> Double? {
        Double(string.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "."))
    }

    func floorTo(_ places: Double) -> Double {
        let divisor = pow(10.0, places)
        return floor(self * divisor) / divisor
    }
}
