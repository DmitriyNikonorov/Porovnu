//
//  Contributor.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

import Foundation

final class Contributor: Hashable {
    static func == (lhs: Contributor, rhs: Contributor) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    let id: UUID
    let name: String
    let spendings: [Spending] // траты учатника
//    let debts: [Transaction] // долги участника

    init(id: UUID = UUID(), name: String, spendings: [Spending]) {
        self.id = id
        self.name = name
        self.spendings = spendings
    }

    convenience init(dataBaseModel: ContributorModel) {
        let spendings = dataBaseModel.spendings.map {
            Spending(dataBaseModel: $0)
        }
        self.init(id: dataBaseModel.id, name: dataBaseModel.name, spendings: spendings)
    }




    /// Словарь трат - [id должника: общая сумма трат]
    var spendingDict = [UUID: Double]()
    /// Словарь долгов - [id кредитора: общая сумма долга]
    var debtsDict = [UUID: Double]()
    /// Словарь балансов
    var balanceDict = [UUID: Double]()

    var totalSpending: Double = .zero
    var totalDebts: Double = .zero

    var balance: Double {
        totalSpending - totalDebts
    }

    /// Подсчет всех трат этого участника, сумма записывается с "+"
    /// Составляется словарь, где ключ - id участника на которого он потратил, значение - все траты на этого участника
    func calculateTotalSpending() {
        for spending in spendings {
            for holder in spending.holders {
                spendingDict[holder.contributorId, default: 0] += holder.amount
                totalSpending += holder.amount
            }
        }
    }

    /// Подсчет всех долго этого участника по тратам, в которых от фигурирует сумма записывается с "-"
    /// Составляется словарь, где ключ - id участника перед которым долг, значение - все долги перед этим участником
    func caclulateTotalDebts(for spendings: [Spending]) {
        for spending in spendings {
            let contributorId = spending.contributorId

            for holder in spending.holders {
                guard holder.id == id else {
                    continue
                }

                debtsDict[spending.contributorId, default: 0.0] -= holder.amount
                totalDebts += holder.amount
            }
        }
    }

    /// Финальные балансы с утетом взаимных трат
    func calculateBalances() {
        balanceDict = spendingDict.merging(debtsDict, uniquingKeysWith: +)
    }
}
