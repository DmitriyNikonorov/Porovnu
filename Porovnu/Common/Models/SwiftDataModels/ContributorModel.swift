//
//  ContributorModel.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 31.03.2026.
//

import Foundation
import SwiftData

@Model
final class ContributorModel {
    @Attribute(.unique)
    var id: UUID

    var name: String

    @Relationship(deleteRule: .cascade, inverse: \SpendingModel.contributor)
    var spendings: [SpendingModel] = []

    @Relationship(deleteRule: .nullify)
    var events: [EventModel] = []

     init(id: UUID = UUID(), name: String) {
         self.id = id
         self.name = name
     }

     convenience init(contributor: Contributor) {
         self.init(id: contributor.id, name: contributor.name)
     }
}

// MARK: - IdentifiableModel

extension ContributorModel: IdentifiableModel {}
