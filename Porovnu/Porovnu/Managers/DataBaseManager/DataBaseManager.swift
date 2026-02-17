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
    func insertInContext<T: PersistentModel>(_ model: T)
    func saveContextIfNeeded()

    func save<T: PersistentModel>(_ model: T)
    func deleteById<T: PersistentModel>(_ type: T.Type, id: UUID) where T: IdentifiableModel

    func fetchEvents() async -> [Event]
    func fetchEventsShort() async -> [EventShort]
    func fetchContributors() async -> [Contributor]
    func fetchSpending() async -> [Spending]
    func fetchHolder() async -> [HolderModel]

    func fetchEvent(by: UUID) async -> Event?
    func fetchContributor(by: UUID) async -> Contributor?
    func fetchSpending(by: UUID) async -> Spending?
    func fetchHolder(by: UUID) async -> Holder?

    func updateSpendingWithHolders(spending: Spending, contribution: Contributor)

    func updateContribotor(contributor: Contributor)
    func updateEvent(event: Event)
}

@MainActor
final class DataBaseManager: DataBaseManagerProtocol {

    private(set) var lastContextChange: Date = .distantPast
// Возожно оставить только чтото одно
    func hasChanges() -> Bool {
        modelContext?.hasChanges ?? false
    }

    static let shared = DataBaseManager()
    private var modelContainer: ModelContainer?
    private var modelContext: ModelContext?

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
        print("DataManager initialize")
    }


    func insertInContext<T: PersistentModel>(_ model: T) {
        modelContext?.insert(model)
    }

    func saveContextIfNeeded() {
        do {
            try modelContext?.save()
        } catch {
            debugPrint("Save context error: \(error)")
        }
    }

    func save<T: PersistentModel>(_ model: T) {
        modelContext?.saveModel(model)
        lastContextChange = Date()
    }

    func deleteById<T: PersistentModel>(_ type: T.Type, id: UUID) where T: IdentifiableModel {
        modelContext?.deleteModelById(type, id: id)
        lastContextChange = Date()
    }


    func fetchEvents() async -> [Event] {
        guard let modelContext else {
            return []
        }

        return modelContext
            .fetchModels(EventModel.self)
            .map {
                Event(dataBaseModel: $0)
            }
    }

    func fetchEventsShort() async -> [EventShort] {
        guard let modelContext else {
            return []
        }

        return modelContext
            .fetchModels(EventModel.self)
            .map {
                EventShort(id: $0.id, name: $0.name, contributorsCount: $0.contributors.count)
            }
    }

    func fetchContributors() async -> [Contributor] {
        guard let modelContext else {
            return []
        }

        return modelContext
            .fetchModels(ContributorModel.self)
            .map {
                Contributor(dataBaseModel: $0)
            }
    }

    func fetchSpending() async -> [Spending] {
        guard let modelContext else {
            return []
        }

        return modelContext
            .fetchModels(SpendingModel.self)
            .map {
                Spending(dataBaseModel: $0)
            }
    }

    func fetchHolder() async -> [HolderModel] {
        guard let modelContext else {
            return []
        }

        return modelContext.fetchModels(HolderModel.self)
    }

    func fetchEvent(by id: UUID) async -> Event? {
        guard let modelContext else {
            return nil
        }

        return modelContext.fetchModelById(EventModel.self, id: id).map { Event(dataBaseModel: $0) }
    }

    func fetchContributor(by id: UUID) async -> Contributor? {
        guard let modelContext else {
            return nil
        }

        return modelContext.fetchModelById(ContributorModel.self, id: id).map { Contributor(dataBaseModel: $0) }
    }

    func fetchSpending(by id: UUID) async -> Spending? {
        guard let modelContext else {
            return nil
        }

        return modelContext.fetchModelById(SpendingModel.self, id: id).map { Spending(dataBaseModel: $0) }
    }

    func fetchHolder(by id: UUID) async -> Holder? {
        guard let modelContext else {
            return nil
        }

        return modelContext.fetchModelById(HolderModel.self, id: id).map {
            Holder(
                id: $0.id,
                spendingId: $0.spendingId,
                contributorId: $0.contributorId,
                contributorName: $0.contributorName,
                amount: $0.amount,
                isPayer: $0.isPayer
            )
        }
    }

    func updateContribotor(contributor: Contributor) {
        let contributorId = contributor.id
        do {
            guard
                let modelContext,
                let contributorModel = try modelContext.fetch(
                    FetchDescriptor<ContributorModel>(predicate: #Predicate { $0.id == contributorId })
                ).first
            else {
                return
            }

            contributorModel.name = contributor.name
            try modelContext.save()
        } catch {
            print("error \(error)")
        }
    }

    func updateEvent(event: Event) {
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
            try modelContext.save()
        } catch {
            print("error \(error)")
        }
    }


    func updateSpendingWithHolders(spending: Spending, contribution: Contributor) {
        let spendingId = spending.id
        do {
            guard
                let modelContext,
                let spendingModel = try modelContext.fetch(
                    FetchDescriptor<SpendingModel>(predicate: #Predicate { $0.id == spendingId })
                ).first
            else {
                throw NSError(domain: "DataBaseManager", code: 0, userInfo: ["Fetch Error": spending])
            }

            let holdersToDelete = spendingModel.holders.filter { holderModel in
                !spending.holders.contains(where: { $0.id == holderModel.id })
            }

            for holder in holdersToDelete {
                modelContext.delete(holder)
            }

            spendingModel.name = spending.name
            spendingModel.totalAmount = spending.totalAmount
//            spendingModel.holders.removeAll(where: { holdersToDelete.contains($0) })
            try modelContext.save()
        } catch {
            print("error \(error)")
        }
    }


//    func saveOrUpdate<T: PersistentModel & Identifiable>(_ modelData: T,
//                                                       id: UUID) throws {
//        // Проверяем — существует ли уже?
//        if let existingModel = try modelContext.fetch(
//            FetchDescriptor<T>(predicate: #Predicate { $0.id == id })
//        ).first {
//            // ✅ Обновляем существующую
//            existingModel.name = modelData.name
//            existingModel.totalAmount = modelData.totalAmount
//        } else {
//            // ✅ Создаем новую
//            modelContext.insert(modelData)
//        }
//        try modelContext.save()
//    }
}
