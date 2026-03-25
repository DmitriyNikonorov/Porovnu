//
//  ContributorTotalInfo.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 23.02.2026.
//

import Foundation

struct ContributorTotalInfo: Hashable, Identifiable {
    static func == (lhs: ContributorTotalInfo, rhs: ContributorTotalInfo) -> Bool {
        lhs.id == rhs.id
    }

    let id: UUID
    /// Имя участника
    let name: String
    /// На какую суму поучаствовал в мероприятии (все Spending)
    var totalSpendings: Double {
        totalSpendingOnOtherContributors + selfSpendings
    }
    /// Какую сумму потратил на других(сколько дал в долг, сумма всех Holder.amount, где Holder.contributorId != id)
    let totalSpendingOnOtherContributors: Double
    /// Какую сумму потратил на себя(сумма всех Holder.amount, где Holder.contributorId == id)
    let selfSpendings: Double
    /// Какую сумму взял в долг за мероприятие(сума всех Holder.amount, где Holder.contributorId == id у других  Contributor)
    let totalDebt: Double
    /// Какую сумму должен с учетом взаиморасчетов
    let selfDebt: Double

    /// Массив долгов (Имя кому должен, сумма долга)
    let debts: [InfoItem]

    var debtsCount: Double {
        abs(debts.reduce(0) { $0 + $1.amount })
    }


    /// Массив трат (Имя кто должен, сумма долга)
    let spendings: [InfoItem]

    var spendingsCount: Double {
        spendings.reduce(0) { $0 + $1.amount }
    }

    /// Сколько потратил на мероприятие сам + взял в долг
    var totalSelfSpendings: Double {
        selfSpendings + abs(totalDebt)
    }
}

struct InfoItem: Hashable, Identifiable {
    let id: UUID

    let contributorId: UUID
    let contributorName: String
    let amount: Double

    init(id: UUID = UUID(), contributorId: UUID, contributorName: String, amount: Double = .zero) {
        self.id = id
        self.contributorId = contributorId
        self.contributorName = contributorName
        self.amount = amount
    }

    init(item: InfoItem, amount: Double) {
        self.init(id: item.id, contributorId: item.contributorId, contributorName: item.contributorName, amount: amount)
    }
}


extension ContributorTotalInfo: CustomStringConvertible {
    var description: String {
        """
        👤 \(name) [\(id.uuidString.prefix(8))]
        💰 Всего потрачено: \(totalSpendings.formatted(.currency(code: "RUB")))
        🤝 На других: \(totalSpendingOnOtherContributors.formatted(.currency(code: "RUB")))
        👤 На себя: \(selfSpendings.formatted(.currency(code: "RUB")))
        💸 Долг (общий): \(totalDebt.formatted(.currency(code: "RUB")))
        ⚖️ Должен лично: \(selfDebt.formatted(.currency(code: "RUB")))
        
        📊 ДОЛГИ (кому должен):
        \(debts.isEmpty ? "  — нет долгов" : debts.map { "  • \($0.contributorName): \($0.amount.formatted(.currency(code: "RUB")))" }.joined(separator: "\n"))
        
        📊 ТРАТЫ (кто должен):
        \(spendings.isEmpty ? "  — нет долгов" : spendings.map { "  • \($0.contributorName): \($0.amount.formatted(.currency(code: "RUB")))" }.joined(separator: "\n"))
        """
    }
}
