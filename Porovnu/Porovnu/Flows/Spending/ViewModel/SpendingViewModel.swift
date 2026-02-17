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

    var spending: Spending?
    var holders = [Holder]()
    var selectedHolders = [Holder]()
    let contributors: [Contributor]


    var creditorName: String
    var spendingName: String
    var spendingTotalAmount: String
    var spendingDiscription: String

    private let onSave: ((Spending?) -> Void)?
    private var spendingId: UUID


    init(
        dto: EditSpendingDto,
        dataBaseManager: DataBaseManagerProtocol
    ) {
        self.creditor = dto.creditor
        self.contributors = dto.contributors
        self.spending = dto.spending

        creditorName = creditor.name
        spendingTotalAmount = dto.spending?.totalAmount == nil ? "" : String(dto.spending?.totalAmount ?? 0.0)
        spendingName = dto.spending?.name ?? ""
        spendingDiscription = "НЕ РЕАЛИЗОВАНО"
        spendingId = dto.spending?.id ?? UUID()
        self.dataBaseManager = dataBaseManager
        self.onSave = dto.callback
        super.init()
        createHolders()
    }

    func deleteRight(holder: Holder) {
//        if let index = selectedHolders.firstIndex(where: { $0.id == holder.id }) {
//            let holder = selectedHolders.remove(at: index)
//            holders.append(holder)
//        }
        if let index = selectedHolders.firstIndex(where: { $0.id == holder.id }) {
                    let holder = selectedHolders.remove(at: index)
                    holders.append(holder)
                }
    }


    

    func deleteLeft(holder: Holder) {
//        if let index = holders.firstIndex(where: { $0.id == holder.id }) {
//            let holder = holders.remove(at: index)
//            selectedHolders.append(holder)
//        }
        if let index = holders.firstIndex(where: { $0.id == holder.id }) {
                   let holder = holders.remove(at: index)
                   selectedHolders.append(holder)
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

    func save(completion: () -> Void) {
        let spending = Spending(
            id: spendingId,
            contributorId: creditor.id,
            name: spendingName,
//            totalAmount: Double(spendingTotalAmount.replacingOccurrences(of: ",", with: ".")) ?? 0.0,
            totalAmount: Double.amountFrom(spendingTotalAmount) ?? .zero,
            holders: selectedHolders
        )
        onSave?(spending)
        completion()
    }
}
