//
//  DataBaseManager.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 09.02.2026.
//

import Foundation
import SwiftData



protocol DataBaseManagerProtocol {

    var lastContextChange: Date { get }
    func deleteById<T: PersistentModel>(_ type: T.Type, id: UUID) where T: IdentifiableModel

    func fetchEvents() -> [Event]
    func fetchEventsShort() -> [EventShort]

    func fetchEvent(by: UUID) -> Event?
    func saveEvent(event: Event)
    func updateEvent(event: Event)
    func updateEventProperties(event: Event)
}

@MainActor
final class DataBaseManager: DataBaseManagerProtocol {
    static let shared = DataBaseManager()

    // MARK: - Provate properties

    private(set) var lastContextChange: Date = .distantPast
    private var modelContainer: ModelContainer?
    private var modelContext: ModelContext?

    // MARK: - Init

    init() {
        do {
            let schema = Schema([
                EventModel.self,
                ContributorModel.self,
                SpendingModel.self,
                HolderModel.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

            if let container = modelContainer {
                modelContext = ModelContext(container)
            }
        } catch {
            debugPrint("Failed to create model container: \(error)")
        }
        debugPrint("DataManager initialize")
    }

    // MARK: - Delete <T>

    func deleteById<T: PersistentModel>(_ type: T.Type, id: UUID) where T: IdentifiableModel {
        do {
            modelContext?.deleteModelById(type, id: id)
            try saveContext()
        } catch {
            debugPrint("error \(error)")
        }
    }


    // MARK: - Event Fetch

    func fetchEvents() -> [Event] {
        guard let modelContext else {
            return []
        }

        return modelContext
            .fetchModels(EventModel.self)
            .map {
                Event(dataBaseModel: $0)
            }
    }

    func fetchEventsShort() -> [EventShort] {
        guard let modelContext else {
            return []
        }

        return modelContext
            .fetchModels(EventModel.self)
            .map {
                EventShort(id: $0.id, name: $0.name, contributorsCount: $0.contributors.count)
            }
    }

    func fetchEvent(by id: UUID) -> Event? {
        guard let modelContext else {
            return nil
        }

        return modelContext.fetchModelById(EventModel.self, id: id).map { Event(dataBaseModel: $0) }
    }

    // MARK: - Event Save

    func saveEvent(event: Event) {
        do {
            let newEventModel = EventModel(event: event)
            modelContext?.insert(newEventModel)

            for contributor in event.contributors {
                let contributorModel = ContributorModel(contributor: contributor)
                modelContext?.insert(contributorModel)

                newEventModel.contributors.append(contributorModel)
                contributorModel.events.append(newEventModel)

                try syncSpendings(contributorModel: contributorModel, contributor: contributor)
            }

            try saveContext()

        } catch {
            debugPrint("error \(error)")
        }
    }


    // MARK: - Event Update

    func updateEvent(event: Event) {
        do {
            guard
                let eventModel = try fetchEventModel(for: event.id)
            else {
                let newEventModel = EventModel(event: event)
                modelContext?.insert(newEventModel)

                for contributor in event.contributors {
                    let contributorModel = ContributorModel(contributor: contributor)
                    modelContext?.insert(contributorModel)

                    newEventModel.contributors.append(contributorModel)
                    contributorModel.events.append(newEventModel)

                    try syncSpendings(contributorModel: contributorModel, contributor: contributor)
                }

                try saveContext()
                return
            }

            /// Update event
            eventModel.name = event.name

            /// Dict for search
            let contributorModelsDict = Dictionary(uniqueKeysWithValues: eventModel.contributors.map { ($0.id, $0) })

            /// Delete contributors
            let contributorModelsToDelete = eventModel.contributors.filter { cont in
                !event.contributors.contains(where: { $0.id == cont.id })
            }

            contributorModelsToDelete.forEach {
                modelContext?.delete($0)
            }

            /// Update contributors
            for contributor in event.contributors {
                if let model = contributorModelsDict[contributor.id] {
                    model.name = contributor.name
                    try syncSpendings(contributorModel: model, contributor: contributor)
                } else {
                    /// Save new contributors
                    let newContributorModel = ContributorModel(contributor: contributor)
                    eventModel.contributors.append(newContributorModel)
                    newContributorModel.events.append(eventModel)
                    modelContext?.insert(newContributorModel)
                    try syncSpendings(contributorModel: newContributorModel, contributor: contributor)
                }
            }

            try saveContext()
            debugPrint("🤖 try to update Spendings")
        } catch {
            debugPrint("error \(error)")
        }
    }

    func updateEventProperties(event: Event) {
        let eventId = event.id
        do {
            guard
                let modelContext,
                let eventModel = try modelContext.fetch(
                    FetchDescriptor<EventModel>(predicate: #Predicate { $0.id == eventId })
                ).first
            else {
                return
            }

            eventModel.name = event.name
            try saveContext()
        } catch {
            debugPrint("error \(error)")
        }
    }
}


// MARK: - Private

private extension DataBaseManager {
    func saveContext() throws {
        guard let modelContext else {
            throw DataError.noContext
        }
        try modelContext.save()
        self.lastContextChange = Date()
    }

    func fetchContributorModels(for contributorIds: [UUID]) throws -> [ContributorModel] {
        guard let modelContext else {
            throw DataError.noContext
        }

        let contributorModels = try modelContext.fetch(
            FetchDescriptor<ContributorModel>(predicate: #Predicate<ContributorModel> { model in
                contributorIds.contains(model.id)
            })
        )

        return contributorModels
    }

    func fetchEventModel(for eventId: UUID) throws -> EventModel? {
        guard let modelContext else {
            throw DataError.noContext
        }

//        guard let eventModel = try modelContext.fetch(
//            FetchDescriptor<EventModel>(predicate: #Predicate<EventModel> { model in
//                eventId == model.id
//            })
//        ).first else {
////            throw DataError.contributorNotFound(eventId)
//            return nil
//        }

        return try modelContext.fetch(
            FetchDescriptor<EventModel>(predicate: #Predicate<EventModel> { model in
                eventId == model.id
            })
        ).first
    }


    func syncSpendings(contributorModel: ContributorModel, contributor: Contributor) throws {
        guard let modelContext else {
            throw DataError.noContext
        }
        /// Updata Spendings
        var holdersToDelete = [HolderModel]()
        var spendingModelsToDelete = [SpendingModel]()

        for spendingModel in contributorModel.spendings {
            guard let spending = contributor.spendings.first(where: { $0.id == spendingModel.id }) else {
                spendingModelsToDelete.append(spendingModel)
                continue
            }

            let spendingHolderIds = Set(spending.holders.map(\.id))
            let holderToDelete = spendingModel.holders.filter { holder in
                !spendingHolderIds.contains(holder.id)
            }
            holdersToDelete.append(contentsOf: holderToDelete)

            for newHolderData in spending.holders {
                if let existing = spendingModel.holders.first(where: { $0.id == newHolderData.id }) {
                    existing.amount = newHolderData.amount
                    existing.isPayer = newHolderData.isPayer
                } else {
                    let newHolder = HolderModel(
                        id: newHolderData.id,
                        contributorId: newHolderData.contributorId,
                        contributorName: newHolderData.contributorName,
                        amount: newHolderData.amount,
                        isPayer: newHolderData.isPayer,
                        spending: spendingModel
                    )
                    modelContext.insert(newHolder)
                    spendingModel.holders.append(newHolder)
                }
            }

            spendingModel.name = spending.name
            spendingModel.totalAmount = spending.totalAmount
        }

        /// Delete holders
        holdersToDelete.forEach {
            modelContext.delete($0)
        }

        /// Delete Spendings
        spendingModelsToDelete.forEach {
            modelContext.delete($0)
        }

        /// Save New Spendings
        let spendingToSave = contributor.spendings.filter { spending in
            !contributorModel.spendings.contains(where: { $0.id == spending.id })
        }

        for spending in spendingToSave {
            let spendingModel = SpendingModel(spending: spending)  // ← Без contributor!
            modelContext.insert(spendingModel)
            contributorModel.spendings.append(spendingModel)
            spendingModel.contributor = contributorModel  // ← ПОСЛЕ insert!

            // Holders
            for holderData in spending.holders {
                let holderModel = HolderModel(
                    id: holderData.id,
                    contributorId: holderData.contributorId,
                    contributorName: holderData.contributorName,
                    amount: holderData.amount,
                    isPayer: holderData.isPayer,
                    spending: spendingModel  // ← ГОТОВЫЙ spendingModel!
                )
                modelContext.insert(holderModel)
                spendingModel.holders.append(holderModel)
            }
        }
    }
}
