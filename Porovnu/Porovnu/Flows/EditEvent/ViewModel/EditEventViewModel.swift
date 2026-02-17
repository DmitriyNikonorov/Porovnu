//
//  EditEventViewModel.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 14.02.2026.
//

import SwiftUI

@Observable
final class EditEventViewModel: ViewModel {

//    private var event: Event
    private var eventSnapshot: Event
    private var currentContributors = [Contributor]()
    private var currentEventName: String = ""

    private let dataBaseManager: DataBaseManagerProtocol
    private let assembler: SpendingAssembler
    private var onSave: ((Event?) -> Void)?

    private var isEventNameChanged = false
    private var isAnyContributorNameChanged = false
    private var isAnySpendingChanged = false

    var hasAnyChanged: Bool {
        get {
            isEventNameChanged ||
            isAnyContributorNameChanged ||
            isAnySpendingChanged
        }
    }

    var contributors: [Contributor] {
        get {
            self.currentContributors
        }
        set {
            currentContributors = newValue
            isAnyContributorNameChanged = !newValue.allSatisfy { new in
                eventSnapshot.contributors.first(where: { $0.id == new.id })?.name == new.name
            }

            isAnySpendingChanged = !newValue.allSatisfy { new in
                eventSnapshot.contributors.first(where: { $0.id == new.id })?.spendings == new.spendings
            }
        }
    }

    var eventName: String {
        get {
            self.currentEventName
        }
        set {
            self.currentEventName = newValue
            isEventNameChanged = newValue != eventSnapshot.name
        }
    }


    var showAlert = false
    var showBackNavigationAlert = false

    init(dto: EditEventDto, assembler: SpendingAssembler, dataBaseManager: DataBaseManagerProtocol) {
//        self.event = event
        eventSnapshot = Event(id: dto.event.id, name: dto.event.name, contributors: dto.event.contributors)
        currentContributors = dto.event.contributors.map { Contributor(id: $0.id, name: $0.name, spendings: $0.spendings) }
        currentEventName = dto.event.name
        self.onSave = dto.onSave

        self.assembler = assembler
        self.dataBaseManager = dataBaseManager
        super.init()
    }

    func saveEventName() {
        
    }

    func updateSpending(_ spending: Spending, for contributor: Contributor) {
        guard
            let spendingIndex = contributor.spendings.firstIndex(where: { $0.id == spending.id })
        else {
            return
        }

        contributor.spendings[spendingIndex] = spending
        updateContributors(with: contributor)
        dataBaseManager.updateSpendingWithHolders(spending: spending, contribution: contributor)
    }

    func saveEvent() -> Bool {
        let event = Event(
            id: eventSnapshot.id,
            name: currentEventName,
            contributors: currentContributors
        )
        dataBaseManager.save(
            EventModel(
                event: event
            )
        )
        onSave?(event)

        currentContributors.forEach {
            print($0)
        }
        resetChanger()
        return true
    }

    var spendingDeleteDict = [UUID: Spending]()

    func deleteSpending(spending: Spending, for contributor: Contributor) {
        contributor.spendings.removeAll(where: { $0.id == spending.id})
        updateContributors(with: contributor)
        dataBaseManager.deleteById(SpendingModel.self, id: spending.id)
        isAnySpendingChanged = true
    }

    func updateContributors(with contributor: Contributor) {
        guard
            let contributorIndex = contributors.firstIndex(where: { $0.id == contributor.id })
        else {
            return
        }

        contributors[contributorIndex] = contributor
    }

    func resetChanger() {
        isEventNameChanged = false
        isAnyContributorNameChanged = false
        isAnySpendingChanged = false
    }

    func canGoBack() -> Bool {
        guard hasAnyChanged else {
            return true
        }

        showBackNavigationAlert = true
        return false
    }
}
