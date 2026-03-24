//
//  CreateEventViewModel.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

import SwiftUI
import SwiftData

struct ContributorShort: Identifiable {
    let id = UUID()
    var name: String
}

extension Collection {
    var isNotEmpty: Bool {
        !isEmpty
    }
}


@Observable
final class CreateEventViewModel: ViewModel {

    private var dataBaseManager: DataBaseManagerProtocol
    var eventName = String()
    var contributors: [ContributorShort] = [ContributorShort(name: "")]

    init(dataBaseManager: DataBaseManagerProtocol) {
        self.dataBaseManager = dataBaseManager
        super.init()
    }

    func createEvent() -> Event? {
        let contributors = contributors
            .filter {
                !$0.name.isEmpty
            }
            .map {
                Contributor(name: $0.name.trim(), spendings: [])
            }

        guard
            contributors.isNotEmpty,
            eventName.isNotEmpty
        else {
            return nil
        }

        let event = Event(
            name: eventName,
            contributors: contributors
        )

        dataBaseManager.saveEvent(event: event)
        return event
    }

    func deleteContributor(at index: Int) {
        guard canDeleteContributor(at: index) else { return }

        contributors.remove(at: index)
    }

    func addContributor() {
        contributors.append(ContributorShort(name: ""))
    }

    func canDeleteContributor(at index: Int) -> Bool {
        return contributors.count > 1
    }
}
