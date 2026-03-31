//
//  EventModel.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

import Foundation
import SwiftData

@Model
final class EventModel {
    @Attribute(.unique)
    var id: UUID

    var name: String

    @Relationship(deleteRule: .nullify, inverse: \ContributorModel.events)
    var contributors: [ContributorModel] = []

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }

    convenience init(event: Event) {
        self.init(id: event.id, name: event.name)
    }
}

// MARK: - IdentifiableModel

extension EventModel: IdentifiableModel {}
