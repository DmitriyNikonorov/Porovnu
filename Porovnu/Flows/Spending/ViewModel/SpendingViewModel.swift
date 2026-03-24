//
//  SpendingViewModel.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 15.02.2026.
//

import SwiftUI

@Observable
final class SpendingViewModel: ViewModel {

    private let dataBaseManager: DataBaseManagerProtocol
    private let creditor: Contributor

    private let onSave: ((Spending?) -> Void)?
    private var spendingId: UUID
    private var summAmount: Double = .zero


    var spending: Spending?
    var holders = [Holder]()
    var selectedHolders = [Holder]()
    let contributors: [Contributor]

    var creditorName: String
    var spendingName: String
    var spendingTotalAmount: Double
    var spendingDiscription: String

    var showAmountError = false

    init(
        dto: EditSpendingDto,
        dataBaseManager: DataBaseManagerProtocol
    ) {
        self.creditor = dto.creditor

        let newContributors = dto.contributors.enumerated().map { item in
            Contributor(
                id: item.element.id,
                name: item.element.name.isEmpty ? "Участник \(item.offset + 1)" : item.element.name,
                spendings: item.element.spendings
            )
        }

        self.contributors = newContributors
        self.spending = dto.spending

        creditorName = creditor.name
        spendingTotalAmount = dto.spending?.totalAmount ?? .zero
        spendingName = dto.spending?.name ?? ""
        spendingDiscription = "Coming soon"
        spendingId = dto.spending?.id ?? UUID()
        self.dataBaseManager = dataBaseManager
        self.onSave = dto.callback
        super.init()
        createHolders()
    }

    func unselectHolder(holder: Holder) {
        if let index = selectedHolders.firstIndex(where: { $0.id == holder.id }) {
            let holder = selectedHolders.remove(at: index)
            holders.append(holder)
        }
    }
    

    func selectHolder(holder: Holder) {
        if let index = holders.firstIndex(where: { $0.id == holder.id }) {
            let holder = holders.remove(at: index)
            selectedHolders.append(holder)
        }
    }

    func selectAllHolders() {
        if holders.isNotEmpty {
            selectedHolders.append(contentsOf: holders)
            holders.removeAll()
        }
    }

    func distributeSpendingForAll() {
        if !spendingTotalAmount.isZero,
           selectedHolders.isNotEmpty {
            let amountPerHolder = (spendingTotalAmount / Double(selectedHolders.count)).floorTo(2)
            selectedHolders = selectedHolders.map {
                Holder(
                    id: $0.id,
                    spendingId: $0.spendingId,
                    contributorId: $0.contributorId,
                    contributorName: $0.contributorName,
                    amount: amountPerHolder,
                    isPayer: $0.isPayer
                )
            }
        }
    }


    func createHolders() {
        if let spending {
            selectedHolders = spending.holders

            let selectedHoldersIDs = Set(spending.holders.map { $0.contributorId })
            let filteredContributors = contributors.filter { !selectedHoldersIDs.contains($0.id) }

            holders = filteredContributors.map {
                Holder(
                    spendingId: spending.id,
                    contributorId: $0.id,
                    contributorName: $0.name,
                    amount: 0,
                    isPayer: $0.id == creditor.id
                )
            }
        } else {
            holders = contributors.map {
                Holder(
                    spendingId: spendingId,
                    contributorId: $0.id,
                    contributorName: $0.name,
                    amount: 0,
                    isPayer: $0.id == creditor.id
                )
            }
        }
    }

    func save() -> SpendingSaveResult {
        guard spendingName.isNotEmpty else {
            return .noSpendingName
        }

        guard spendingTotalAmount >= (selectedHolders.reduce(0) { $0 + $1.amount }) else {
            return .notCorrentSumm
        }

        let spending = Spending(
            id: spendingId,
            contributorId: creditor.id,
            name: spendingName,
            totalAmount: spendingTotalAmount,
            holders: selectedHolders
        )

        onSave?(spending)
        return .success
    }
}
