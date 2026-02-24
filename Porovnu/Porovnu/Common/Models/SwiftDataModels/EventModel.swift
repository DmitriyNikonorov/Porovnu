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

@Model
final class SpendingModel {
    @Attribute(.unique)
    var id: UUID
    /// Чья это трата
    @Relationship(deleteRule: .nullify)
    var contributor: ContributorModel?
    /// название траты
    var name: String
    /// сумма всей траты
    var totalAmount: Double
    /// Должники по трате
    @Relationship(deleteRule: .cascade, inverse: \HolderModel.spending)
    var holders: [HolderModel]

    @Transient var contributorId: UUID {
        // FIXME: - не консистентно
        contributor?.id ?? UUID()
    }

    init(id: UUID = UUID(), name: String, totalAmount: Double, holders: [HolderModel], contributor: ContributorModel? = nil) {
        self.id = id
        self.contributor = contributor
        self.name = name
        self.totalAmount = totalAmount
        self.holders = holders
    }

    init(id: UUID = UUID(), name: String, totalAmount: Double) {
        self.id = id
        self.name = name
        self.totalAmount = totalAmount
        self.holders = []
    }

    convenience init(spending: Spending) {
        self.init(id: spending.id, name: spending.name, totalAmount: spending.totalAmount)
    }
}

@Model
final class HolderModel {
    @Attribute(.unique)
    var id: UUID
    /// Родительская трата
    @Relationship(deleteRule: .nullify)
    var spending: SpendingModel?
    /// На кого потратили
    var contributorId: UUID
    /// Имя на кого потратили
    var contributorName: String
    /// Размер долго в этой части траты
    var amount: Double
    /// Является ли плательщиком
    var isPayer: Bool

    @Transient var spendingId: UUID {
        spending?.id ?? UUID()
    }

    init(id: UUID = UUID(), contributorId: UUID, contributorName: String, amount: Double, isPayer: Bool, spending: SpendingModel? = nil) {
        self.id = id
        self.spending = spending
        self.contributorId = contributorId
        self.contributorName = contributorName
        self.amount = amount
        self.isPayer = isPayer
    }

    convenience init(holder: Holder, spending: SpendingModel) {
         self.init(
             id: holder.id,
             contributorId: holder.contributorId,
             contributorName: holder.contributorName,
             amount: holder.amount,
             isPayer: holder.isPayer,
             spending: spending  // ← ГОТОВЫЙ spending из контекста!
         )
     }
}


// MARK: - IdentifiableModel

extension EventModel: IdentifiableModel {}
extension ContributorModel: IdentifiableModel {}
extension SpendingModel: IdentifiableModel {}
extension HolderModel: IdentifiableModel {}
