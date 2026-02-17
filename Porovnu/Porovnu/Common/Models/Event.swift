//
//  Event.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 02.02.2026.
//

import Foundation

struct Event: Identifiable, Hashable {
    let id: UUID
    let name: String
    let contributors: [Contributor]

    init(id: UUID = UUID(), name: String, contributors: [Contributor]) {
        self.id = id
        self.name = name
        self.contributors = contributors
    }

    init(dataBaseModel: EventModel) {
        let contributors = dataBaseModel.contributors.map {
            Contributor(dataBaseModel: $0)
        }
        self.init(id: dataBaseModel.id, name: dataBaseModel.name, contributors: contributors)
    }
}

struct EventShort: Identifiable, Hashable {
    let id: UUID
    let name: String
    let contributorsCount: Int

    init(id: UUID = UUID(), name: String, contributors: Int) {
        self.id = id
        self.name = name
        self.contributorsCount = contributors
    }
}

extension Event {
    func updateContributors(with newContributors: [Contributor]) -> Event {
        Event(id: id, name: name, contributors: newContributors)
    }
}

// Нужно ли?
enum TransactionType {
    case spending, debt
}

// Нужно ли?
// Долг между двумя участниками
struct Debt {
    let fromId: UUID  // Кто должен
    let toId: UUID    // Кому должен
    var amount: Double
}
