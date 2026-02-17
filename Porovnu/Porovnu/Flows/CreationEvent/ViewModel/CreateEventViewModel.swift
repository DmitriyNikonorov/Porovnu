//
//  CreateEventViewModel.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

import SwiftUI
import SwiftData

@Observable
final class CreateEventViewModel: ViewModel {
    var eventName = ""
    var contributorsNames: [String] = [""]

    var modelContainer: ModelContainer?
    var modelContext: ModelContext?

    override init() {
        super.init()
        setupModelContainer()
    }

    func createEvent() -> Event {
        let contributors = contributorsNames
            .filter {
                !$0.isEmpty
            }
            .map {
                Contributor(name: $0, spendings: [])
            }

        let event = Event(
            name: eventName,
            contributors: contributors
        )
        saveModel(model: event)
        return event
    }



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

    func saveModel(model: Event) {
        do {
            modelContext?.insert(EventModel(event: model))
            try modelContext?.save()
            print("✅ save event in database")
        } catch {
            print(error)
        }
    }
}



