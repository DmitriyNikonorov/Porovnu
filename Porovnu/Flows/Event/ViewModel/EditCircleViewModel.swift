//
//  EditCircleViewModel.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 05.02.2026.
//

import SwiftUI
import SwiftData

@Observable
final class EditCircleViewModel: ViewModel {

    private let dataBaseManager: DataBaseManagerProtocol
    let assembler: SpendingAssembler

    var event: Event

    /// Траты каждого участника. id участника: [Его Траты]
    private var allSpendings = [UUID: [Spending]]()
    /// Траты по которым участник является должником. id участника: [Трата по которой он должник]
    private var contributorsDebts = [UUID: [Spending]]()

    /// Достается из SwiftData и маппится в словарь
    /// Быстрый доступ к тратам по id
    private var spendingsDict = [UUID: Spending]()

    var selectedWord: String = ""
    var words: [String] { 
        event.contributors.map(\.name)
    }

    func updateEvent(event: Event) {
        self.event = Event(
                id: event.id,
                name: event.name,
                contributors: event.contributors.map { contributor in
                    Contributor(
                        id: contributor.id,
                        name: contributor.name,
                        spendings: contributor.spendings.map { spending in
                            Spending(id: spending.id, contributorId: spending.contributorId, name: spending.name, totalAmount: spending.totalAmount, holders: spending.holders.map { holder in
                                Holder(id: holder.id, spendingId: holder.spendingId, contributorId: holder.contributorId, contributorName: holder.contributorName, amount: holder.amount, isPayer: holder.isPayer) })
                        }
                    )
                }
            )
    }


    var selectContributor: Contributor {
        event.contributors.first(where: { $0.name == selectedWord }) ?? Contributor(name: "Unknown", spendings: [])
    }

    init(event: Event, assembler: SpendingAssembler, dataBaseManager: DataBaseManagerProtocol) {
        self.event = event

        // MARK: - Тестовый мок данных
//        self.event = Event(name: "Test", contributors: mock())
        self.assembler = assembler
        self.dataBaseManager = dataBaseManager
        super.init()
    }

    func saveSpending(_ spending: Spending) {
        guard
            let contributorIndex = event.contributors.firstIndex(where: { $0.id == selectContributor.id })
        else {
            return
        }

        var spendings = selectContributor.spendings
        spendings.append(spending)
        let newSelectContributor = Contributor(id: selectContributor.id, name: selectContributor.name, spendings: spendings)

        var contributors = event.contributors
        contributors[contributorIndex] = newSelectContributor
        event = Event(id: event.id, name: event.name, contributors: contributors)
    }
}

// MARK: - Private

private extension EditCircleViewModel {
    func calculateSpendings() {
        // Пока берем первого участника, потом брать того кто isUser
        // Маппим траты каждого участника
        allSpendings = Dictionary(uniqueKeysWithValues: event.contributors.map { ($0.id, $0.spendings) })

        /// При подсчете трат составляется словарь в рамках модуля, где ключ - id участника, значением - массив с Тратами.
        /// Это пригодится, чтобы показать детализацию трат для каждого участника.
        ///  Для отображения всех трат не нужно сразу использовать взаимозачет, надо показывать суммы по каждой транзакции. И общую сумму долгов, из которой уже вычитается общая сумма трат при взаимозачете, и общая сумма будет с взаимозачетом
        allSpendings.forEach { creditorId, spendings in
            let holders = spendings.flatMap { $0.holders }
            holders.forEach { holder in
                if let spending = spendingsDict[holder.spendingId] {
                    contributorsDebts[holder.contributorId, default: []].append(spending)
                }
            }
        }

        let updatedContributors = event.contributors.reduce(into: [Contributor]()) { result, contributor in
            if let debts = contributorsDebts[contributor.id] {

                // FIXME: - 
//                contributor.caclulateTotalDebts(for: debts)
                result.append(contributor)
            }
        }

        event = event.updateContributors(with: updatedContributors)
    }
}

//func mock() -> [Contributor] {
//
//    let mashaId = UUID()
//    let svetaId = UUID()
//    let vikaId = UUID()
//
//    let masha = Contributor(id: mashaId, name: "Маша", spendings: [])
//    let sveta = Contributor(id: svetaId, name: "Света", spendings: [])
//    let vika = Contributor(id: vikaId, name: "Вика", spendings: [])
//
//
//    // MARK: - masha
//
//    let spendingId_1 = UUID()
//    let holder_1_spending_1 = Holder(spendingId: spendingId_1, contributorId: masha.id, contributorName: masha.name, amount: 1000, isPayer: true)
//    let holder_2_spending_1 = Holder(spendingId: spendingId_1, contributorId: sveta.id, contributorName: sveta.name, amount: 1000, isPayer: false)
//    let holder_3_spending_1 = Holder(spendingId: spendingId_1, contributorId: vika.id, contributorName: vika.name, amount: 3000, isPayer: false)
//
//    let spending_1 = Spending(
//        id: spendingId_1,
//        contributorId: masha.id,
//        name: "Еда",
//        totalAmount: 5000,
//        holders: [
//            holder_1_spending_1,
//            holder_2_spending_1,
//            holder_3_spending_1
//        ]
//    )
//
//    let spendingId_2 = UUID()
//    let holder_1_spending_2 = Holder(spendingId: spendingId_2, contributorId: masha.id, contributorName: masha.name,amount: 2000, isPayer: true)
//    let holder_2_spending_2 = Holder(spendingId: spendingId_2, contributorId: sveta.id, contributorName: sveta.name,amount: 2000, isPayer: false)
//    let holder_3_spending_2 = Holder(spendingId: spendingId_2, contributorId: vika.id, contributorName: vika.name,amount: 2000, isPayer: false)
//
//    let spending_2 = Spending(
//        id: spendingId_2,
//        contributorId: masha.id,
//        name: "Вино",
//        totalAmount: 6000,
//        holders: [
//            holder_1_spending_2,
//            holder_2_spending_2,
//            holder_3_spending_2
//        ]
//    )
//    masha.spendings = [spending_1, spending_2]
//
//    // MARK: - sveta
//
//    let spendingId_3 = UUID()
//    let holder_2_spending_3 = Holder(spendingId: spendingId_3, contributorId: sveta.id, contributorName: sveta.name, amount: 1000, isPayer: true)
//    let holder_3_spending_3 = Holder(spendingId: spendingId_3, contributorId: vika.id, contributorName: vika.name, amount: 2000, isPayer: false)
//
//    let spending_3 = Spending(
//        id: spendingId_3,
//        contributorId: sveta.id,
//        name: "Закуски",
//        totalAmount: 3000,
//        holders: [
//            holder_2_spending_3,
//            holder_3_spending_3
//        ]
//    )
//
//    let spendingId_4 = UUID()
//    let holder_1_spending_4 = Holder(spendingId: spendingId_4, contributorId: masha.id, contributorName: masha.name, amount: 500, isPayer: false)
//    let holder_2_spending_4 = Holder(spendingId: spendingId_4, contributorId: sveta.id, contributorName: sveta.name, amount: 1000, isPayer: true)
//    let holder_3_spending_4 = Holder(spendingId: spendingId_4, contributorId: vika.id, contributorName: vika.name, amount: 700, isPayer: false)
//
//    let spending_4 = Spending(
//        id: spendingId_4,
//        contributorId: sveta.id,
//        name: "Разное в дороге",
//        totalAmount: 2200,
//        holders: [
//            holder_1_spending_4,
//            holder_2_spending_4,
//            holder_3_spending_4
//        ]
//    )
//
//    let spendingId_5 = UUID()
//    let holder_1_spending_5 = Holder(spendingId: spendingId_5, contributorId: sveta.id, contributorName: sveta.name, amount: 500, isPayer: true)
//
//    let spending_5 = Spending(
//        id: spendingId_5,
//        contributorId: sveta.id,
//        name: "Кофе в дороге",
//        totalAmount: 500,
//        holders: [
//            holder_1_spending_5
//        ]
//    )
//
//    sveta.spendings = [
//        spending_3,
//        spending_4,
//        spending_5
//    ]
//
//    return [
//        masha,
//        sveta,
//        vika
//    ]
//}
