//
//  SpendingViewModel.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 15.02.2026.
//

import SwiftUI

@Observable
final class SpendingViewModel: ViewModel {

    // MARK: - Private properties

    private let dataBaseManager: DataBaseManagerProtocol
    private let creditor: Contributor

    private let onSave: ((Spending?) -> Void)?
    private var spendingId: UUID
    private var summAmount: Double = .zero

    // MARK: - Public properties

    var spending: Spending?
    var holders = [Holder]()
    var selectedHolders = [Holder]()
    let contributors: [Contributor]

    var creditorName: String
    var spendingName: String
    var spendingTotalAmount: Int
    var spendingDiscription: String
    var showAmountError = false

    var notDistributedSumm: Int {
        spendingTotalAmount - (selectedHolders.reduce(0) { $0 + $1.amount })
    }

    var showNotDistributedSumm: Bool {
        !notDistributedSumm.isZero && !spendingTotalAmount.isZero
    }

    // MARK: - Init

    init(
        dto: EditSpendingDto,
        dataBaseManager: DataBaseManagerProtocol
    ) {
        self.creditor = dto.creditor

        let newContributors = dto.contributors.enumerated().map { item in
            Contributor(
                id: item.element.id,
                name: item.element.name.isEmpty
                ? Localized.Common.contributorAmount(amount: item.offset + 1)
                : item.element.name,
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
            let resetHolder = Holder(
                id: holder.id,
                spendingId: holder.spendingId,
                contributorId: holder.contributorId,
                contributorName: holder.contributorName,
                amount: .zero,
                isPayer: holder.isPayer
            )
            holders.append(resetHolder)
        }
    }

    // MARK: - Public methods

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
            let amountArray = splitAmount(spendingTotalAmount, among: selectedHolders.count)
            selectedHolders = selectedHolders.enumerated().map {
                Holder(
                    id: $0.element.id,
                    spendingId: $0.element.spendingId,
                    contributorId: $0.element.contributorId,
                    contributorName: $0.element.contributorName,
                    amount: amountArray[$0.offset],
                    isPayer: $0.element.isPayer
                )
            }
        }
    }

    func save() -> SpendingSaveResult {
        guard spendingName.isNotEmpty else {
            return .noSpendingName
        }

        guard !spendingTotalAmount.isZero else {
            return .noSumm
        }

        guard !(selectedHolders.isEmpty && spendingTotalAmount.isZero == false) else {
            createAndSaveSpending()
            return .success
        }

        guard spendingTotalAmount == (selectedHolders.reduce(0) { $0 + $1.amount }) else {
            return .notCorrentSumm
        }

        createAndSaveSpending()
        return .success
    }
}

// MARK: - Private

private extension SpendingViewModel {
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

    func createAndSaveSpending() {
        let involvedHolders = selectedHolders.filter { !$0.amount.isZero }
        let spending = Spending(
            id: spendingId,
            contributorId: creditor.id,
            name: spendingName,
            totalAmount: spendingTotalAmount,
            holders: involvedHolders
        )

        onSave?(spending)
    }

    func splitAmount(_ totalAmount: Int, among people: Int) -> [Int] {
        guard people > 0 else {
            return []
        }

        let perPerson = totalAmount / people
        let remainder = totalAmount % people

        // Создаем массив с базовой суммой для каждого
        var result = Array(repeating: perPerson, count: people)

        // Распределяем остаток по одному копейке первым N людям
        for i in 0..<remainder {
            result[i] += 1
        }

        return result
    }
}
