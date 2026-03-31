//
//  SpendingModel.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 31.03.2026.
//

import Foundation
import SwiftData

@Model
final class SpendingModel {
    /// ID траты
    @Attribute(.unique)
    var id: UUID
    /// Чья это трата
    @Relationship(deleteRule: .nullify)
    var contributor: ContributorModel?
    /// Название траты
    var name: String
    /// Сумма траты
    var totalAmount: Int
    /// Должники по трате
    @Relationship(deleteRule: .cascade, inverse: \HolderModel.spending)
    var holders: [HolderModel]

    @Transient var contributorId: UUID {
        guard let id = contributor?.id else {
            debugPrint("🔴 Spending with id: \(id) has no contributor.id")
            return UUID()
        }

        return id
    }

    init(id: UUID = UUID(), name: String, totalAmount: Int, holders: [HolderModel], contributor: ContributorModel? = nil) {
        self.id = id
        self.contributor = contributor
        self.name = name
        self.totalAmount = totalAmount
        self.holders = holders
    }

    init(id: UUID = UUID(), name: String, totalAmount: Int) {
        self.id = id
        self.name = name
        self.totalAmount = totalAmount
        self.holders = []
    }

    convenience init(spending: Spending) {
        self.init(id: spending.id, name: spending.name, totalAmount: spending.totalAmount)
    }
}

// MARK: - IdentifiableModel

extension SpendingModel: IdentifiableModel {}
