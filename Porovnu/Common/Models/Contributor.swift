//
//  Contributor.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

import Foundation

struct Contributor: Hashable, Identifiable {
    static func == (lhs: Contributor, rhs: Contributor) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.spendings == rhs.spendings
    }
    
    let id: UUID
    var name: String
    var spendings: [Spending]
    
    init(id: UUID = UUID(), name: String = String(), spendings: [Spending] = []) {
        self.id = id
        self.name = name
        self.spendings = spendings
    }
    
    init(dataBaseModel: ContributorModel) {
        let spendings = dataBaseModel.spendings.map {
            Spending(dataBaseModel: $0)
        }
        self.init(id: dataBaseModel.id, name: dataBaseModel.name, spendings: spendings)
    }
}

// MARK: - CustomStringConvertible

extension Contributor: CustomStringConvertible {
    var description: String {
        """
        👤 Contributor[
          id: \(id.uuidString.prefix(8))...
          name: "\(name)"
          spendings: \(spendings.count)
        ]
        """
    }
}
