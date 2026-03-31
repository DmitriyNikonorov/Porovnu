//
//  EditEventViewModel.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 14.02.2026.
//

import SwiftUI

@Observable
final class EditEventViewModel: ViewModel {

    // MARK: - Private properties

    private let dataBaseManager: DataBaseManagerProtocol
    private let assembler: SpendingAssembler

    private var eventSnapshot: Event?
    private var currentContributors = [Contributor]()
    private var currentEventName = String()
    private var isInitialEventLoaded = false

    private var isEventNameChanged = false {
        didSet {
            setChanged()
        }
    }
    private var isContributorCountChange = false {
        didSet {
            setChanged()
        }
    }
    private var isAnyContributorNameChanged = false {
        didSet {
            setChanged()
        }
    }
    private var isAnySpendingChanged = false {
        didSet {
            setChanged()
        }
    }

    private func setChanged() {
        isShowSaveBarButton = hasAnyChanged
    }

    /// Траты каждого участника. id участника: [Его Траты]
    private var spendingDict = [UUID: [Spending]]()
    /// Траты по которым Contributor - это Holder. id участника: [Трата по которой он Holder]
    private var debtsDict = [UUID: [Spending]]()
    /// Быстрый доступ к тратам по id
    private var spendingsDict = [UUID: Spending]()

    // MARK: - Public properties

    var contributorTotalInfoList: [ContributorTotalInfo] = []

    var noContributors: Bool {
        contributors.first(where: { $0.name.isNotEmpty }).isNil
    }

    var contributors: [Contributor] {
        get {
            currentContributors
        }
        set {
            currentContributors = newValue
            isAnyContributorNameChanged = !newValue.allSatisfy { new in
                eventSnapshot?.contributors.first(where: { $0.id == new.id })?.name == new.name
            }

            isContributorCountChange = newValue.count != eventSnapshot?.contributors.count

            isAnySpendingChanged = !newValue.allSatisfy { new in
                eventSnapshot?.contributors.first(where: { $0.id == new.id })?.spendings == new.spendings
            }
        }
    }

    var eventName: String {
        get {
            self.currentEventName
        }
        set {
            self.currentEventName = newValue
            isEventNameChanged = newValue != eventSnapshot?.name
        }
    }

    var canGoBack: Bool {
        !hasAnyChanged
    }

    var canDeleteContributor: Bool {
        currentContributors.count > 1
    }

    var isDebtsExist: Bool {
        currentContributors.contains {
            $0.spendings.isNotEmpty
        }
    }

    var isShowSaveBarButtonPreviousState = false
    var isShowSaveBarButton = false {
        didSet {
            isShowSaveBarButtonPreviousState = oldValue
        }
    }
    var isNewEvent = false

    var hasAnyChanged: Bool {
        isEventNameChanged ||
        isContributorCountChange ||
        isAnyContributorNameChanged ||
        isAnySpendingChanged
    }

    // MARK: - Init

    init(assembler: SpendingAssembler, dataBaseManager: DataBaseManagerProtocol) {
        self.assembler = assembler
        self.dataBaseManager = dataBaseManager
        super.init()
    }

    func loadInitialEvent() {
        guard !isInitialEventLoaded else {
            return
        }
        isInitialEventLoaded = true
        let eventId = UserDefaultsManager.fetchLastOpenedEventId() ?? UUID()
        setupEvent(to: eventId)
    }

    func setEventData(_ event: Event?) {
        isNewEvent = event.isNil

        let event = Event(
            id: event?.id ?? UUID(),
            name: event?.name ?? String(),
            contributors: event?.contributors ?? [Contributor()]
        )

        eventSnapshot = event
        currentContributors = event.contributors.map { Contributor(id: $0.id, name: $0.name, spendings: $0.spendings) }
        currentEventName = event.name
    }

    // MARK: - Event methods

    func setupEvent(to eventId: UUID) {
        let event = self.dataBaseManager.fetchEvent(by: eventId)
        setEventData(event)
        calculateEvent(event)
        UserDefaultsManager.setLastOpenedEventId(eventId)
    }

    func createNewEvent() {
        let newEvent = Event(contributors: [Contributor()])
        setEventData(newEvent)
        calculateEvent(newEvent)
    }

    // MARK: - Controbutor methods

    func addContributor() {
        contributors.append(Contributor())
    }

    func updateContributors(with contributor: Contributor) {
        guard
            let contributorIndex = currentContributors.firstIndex(where: { $0.id == contributor.id })
        else {
            return
        }

        contributors[contributorIndex] = Contributor(
            id: contributor.id,
            name: contributor.name,
            spendings: contributor.spendings
        )
    }

    func deleteContributor(at id: UUID) {
        guard canDeleteContributor else {
            return
        }

        contributors.removeAll(where: { $0.id == id })
    }

    // MARK: - Spendings methods

    func saveSpending(_ spending: Spending, contributor: Contributor) {
        var spendings = contributor.spendings
        spendings.append(spending)
        updateContributors(with: Contributor(id: contributor.id, name: contributor.name, spendings: spendings))
    }

    func updateSpending(_ spending: Spending, for contributor: Contributor) {
        guard
            let spendingIndex = contributor.spendings.firstIndex(where: { $0.id == spending.id })
        else {
            return
        }
        var spendings = contributor.spendings
        spendings[spendingIndex] = spending
        updateContributors(with: Contributor(id: contributor.id, name: contributor.name, spendings: spendings))
    }

    func deleteSpending(spending: Spending, for contributor: Contributor) {
        var spendings = contributor.spendings
        spendings.removeAll(where: { $0.id == spending.id})
        updateContributors(with: Contributor(id: contributor.id, name: contributor.name, spendings: spendings))
    }

    // MARK: - Save All

    func saveAllChanges() {
        guard let eventSnapshot else {
            return
        }

        guard hasAnyChanged else {
            return
        }

        let newContributors = currentContributors.enumerated().map { item in
            Contributor(
                id: item.element.id,
                name: item.element.name.isNotEmpty
                ? item.element.name
                : Localized.Common.contributorAmount(amount: item.offset + 1),
                spendings: item.element.spendings
            )
        }

        let updatedEvent = Event(
            id: eventSnapshot.id,
            name: currentEventName.isNotEmpty ? currentEventName : Localized.EditEventView.untitled,
            contributors: newContributors
        )

        if isEventNameChanged {
            dataBaseManager.updateEventProperties(event: updatedEvent)
        }

        if isAnySpendingChanged || isAnyContributorNameChanged || isContributorCountChange {
            dataBaseManager.updateEvent(event: updatedEvent)
        }

        self.eventSnapshot = updatedEvent
        calculateEvent(updatedEvent)
        UserDefaultsManager.setLastOpenedEventId(updatedEvent.id)
        resetAllChanges()
        if isNewEvent {
            isNewEvent = false
        }
    }

// MARK: - Reset All

    func resetAllChanges() {
        isEventNameChanged = false
        isAnyContributorNameChanged = false
        isAnySpendingChanged = false
        isContributorCountChange = false
    }
}

// MARK: - Private

private extension EditEventViewModel {

    func calculateEvent(_ event: Event?) {
        calculateSpendings(for: event)
        calculateDebts(contributors: event?.contributors ?? [])
    }


    // MARK: - Calculate Spendings

    func calculateSpendings(for event: Event?) {
        guard let event else {
            return
        }

        spendingDict = Dictionary(uniqueKeysWithValues: event.contributors.map { contributor in
            contributor.spendings.forEach { spending in
                spendingsDict[spending.id] = spending
            }

            return (contributor.id, contributor.spendings)
        })

        spendingDict.forEach { creditorId, spendings in
            let holders = spendings.flatMap { $0.holders }
            holders.forEach { holder in
                if
                    let spending = spendingsDict[holder.spendingId],
                    /// Проверка что должник по трате не является владельцем траты
                    holder.contributorId != creditorId {
                    debtsDict[holder.contributorId, default: []].append(spending)
                }
            }
        }
    }

    // MARK: - Calculate Debts

    func calculateDebts(contributors: [Contributor]) {
        var contributorTotalInfo: [ContributorTotalInfo] = []
        contributors.forEach { contributor in
            let debts = debtsDict[contributor.id]
            let infoModel = calculateTotalSpending(
                for: contributor.id,
                name: contributor.name,
                in: contributor.spendings,
                and: debts ?? []
            )
            contributorTotalInfo.append(infoModel)
        }

        contributorTotalInfoList = contributorTotalInfo
    }

    /// Подсчет всех трат этого участника, сумма записывается с "+"
    /// Составляется словарь, где ключ - id участника на которого он потратил, значение - все траты на этого участника
    func calculateTotalSpending(
        for contributorId: UUID,
        name: String,
        in creditSpendings: [Spending],
        and debtSpendings: [Spending]
    ) -> ContributorTotalInfo {
        var contributorsNamesDict = [UUID: String]()

        /// Словарь трат - [id должника: общая сумма трат]
        var spendingDict = [UUID: Int]()
        var totalSpendings: Int = 0
        var totalDebts: Int = 0
        var selfSpendings: Int = 0

        for spending in creditSpendings {
            if spending.holders.isEmpty {
                selfSpendings += spending.totalAmount
            } else {
                for holder in spending.holders {
                    if contributorId == holder.contributorId {
                        selfSpendings += holder.amount
                    } else {
                        spendingDict[
                            holder.contributorId,
                            default: 0
                        ] += holder.amount
                        totalSpendings += holder.amount
                        contributorsNamesDict[holder.contributorId] = holder.contributorName
                    }
                }
            }

        }

        for spending in debtSpendings {
            let creditorId = spending.contributorId

            for holder in spending.holders {
                guard
                    holder.contributorId == contributorId
                else {
                    continue
                }

                spendingDict[
                    creditorId,
                    default: 0
                ] -= holder.amount
                totalDebts -= holder.amount
                contributorsNamesDict[holder.contributorId] = holder.contributorName
            }
        }

        var infoList = [InfoItem]()
        for (contributorId, amount) in spendingDict {
            guard let contributorName = contributorsNamesDict[contributorId] else {
                continue
            }
            infoList.append(
                InfoItem(
                    contributorId: contributorId,
                    contributorName: contributorName,
                    amount: amount
                )
            )
        }
        let selfDebt = infoList.reduce(into: Int()) { result, element in
            result += element.amount
        }

        let spendingItems = infoList
            .filter {
                $0.amount > 0
            }
            .map {
                InfoItem(item: $0, amount: abs($0.amount))
            }

        let debtItems = infoList
            .filter {
                $0.amount < 0
            }
            .map {
                InfoItem(item: $0, amount: abs($0.amount))
            }

        return ContributorTotalInfo(
            id: contributorId,
            name: name,
            totalSpendingOnOtherContributors: totalSpendings,
            selfSpendings: selfSpendings,
            totalDebt: abs(totalDebts),
            selfDebt: selfDebt > 0 ? .zero : selfDebt,
            debts: debtItems,
            spendings: spendingItems
        )
    }
}
