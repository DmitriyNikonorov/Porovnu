//
//  EventsListViewModel.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 02.02.2026.
//

import SwiftUI
import SwiftData

@Observable
final class EventsListViewModel: ViewModel {
    private var dataBaseManager: DataBaseManagerProtocol
    private var lastFetchTime: Date = .distantPast
    private var isFirstLaunch = true
    var onSelect: (UUID) -> Void
    var onCreateNew: () -> Void
    var events = [EventShort]()

    init(dto: EventListDto, dataBaseManager: DataBaseManagerProtocol) {
        self.onSelect = dto.onSelect
        self.onCreateNew = dto.onCreateNew
        self.dataBaseManager = dataBaseManager
        super.init()
    }

    func fetchModels() {
        if isFirstLaunch {
            events = dataBaseManager.fetchEventsShort()
            isFirstLaunch = false
            return
        }

        guard dataBaseManager.lastContextChange > lastFetchTime else {
            return
        }
        events = dataBaseManager.fetchEventsShort()
        lastFetchTime = Date()
    }

    func fetchModels(by id: UUID) -> Event? {
        return dataBaseManager.fetchEvent(by: id)
    }

    func deleteModel(by id: UUID) {
        events.removeAll(where: { $0.id == id })
        dataBaseManager.deleteById(EventModel.self, id: id)
    }
}


