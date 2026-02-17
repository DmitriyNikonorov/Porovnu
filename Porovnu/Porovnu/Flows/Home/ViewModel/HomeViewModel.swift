//
//  HomeViewModel.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 02.02.2026.
//

import SwiftUI
import SwiftData

@Observable
final class HomeViewModel: ViewModel {
    private var startDisneyPage = 0
    private var startArtPage = 0

    private var artPage = 0
    private var disneyPage = 0

    private var artCanLoad = true
    private var disneyCanLoad = true

    private var modelContainer: ModelContainer?
    private var modelContext: ModelContext?

    var events = [EventShort]()
    var fullEvents = [Event]()


    override init() {
        super.init()
        setupModelContainer()
    }

    func fetchModels() {
        guard let modelContext else {
            return
        }

        do {
            let descriptor = FetchDescriptor<EventModel>()
            let eventModels = try modelContext.fetch(descriptor)
            events = eventModels.map {
                EventShort(id: $0.id, name: $0.name, contributors: $0.contributors.count )
            }
            fullEvents = eventModels.map { event in
                Event(dataBaseModel: event)
            }
            debugPrint("✅ models was fetched in HomeView")
        } catch {
            debugPrint("Fetch error: \(error)")
        }
    }

    func fetchModels(by id: UUID) -> Event? {
        guard let modelContext else {
            return nil
        }

        let dataModel = modelContext.fetchModelById(EventModel.self, id: id)

        return dataModel.map { Event(dataBaseModel: $0) }
    }



}

// MARK: - Private

protocol IdentifiableModel: PersistentModel {
    var id: UUID { get }
}

extension EventModel: IdentifiableModel {}

extension ModelContext {
    func fetchModelById<T: PersistentModel>(_ type: T.Type, id: UUID) -> T? where T: IdentifiableModel {
        do {
            let predicate = #Predicate<T> { $0.id == id }
            let descriptor = FetchDescriptor(predicate: predicate)
            return try fetch(descriptor).first
        } catch {
            debugPrint("Fetching model error: \(error)")
            return nil
        }

    }
}


private extension HomeViewModel {
    private func setupModelContainer() {
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
    }

}

@MainActor
final class DataManager {
    
}


//@MainActor
//class DataManager {
//    static let shared = DataManager()
//    private let modelContext: ModelContext
//
//    init(modelContext: ModelContext) {
//        self.modelContext = modelContext
//    }
//
//    func fetchEvents() async throws -> [EventModel] {
//        let descriptor = FetchDescriptor<EventModel>(
//            sortBy: [SortDescriptor(\.name)]
//        )
//        return try modelContext.fetch(descriptor)
//    }
//}
//
//// ViewModel использует DataManager:
//@Observable
//class EventsViewModel {
//    var events: [EventModel] = []
//
//    func loadEvents() async throws {
//        events = try await DataManager.shared.fetchEvents()
//    }
//}
