//
//  HolderModel.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 31.03.2026.
//

import Foundation
import SwiftData

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
    /// Размер долга в этой части траты
    var amount: Int
    /// Является ли плательщиком
    var isPayer: Bool

    @Transient var spendingId: UUID {
        spending?.id ?? UUID()
    }

    init(id: UUID = UUID(), contributorId: UUID, contributorName: String, amount: Int, isPayer: Bool, spending: SpendingModel? = nil) {
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

extension HolderModel: IdentifiableModel {}
