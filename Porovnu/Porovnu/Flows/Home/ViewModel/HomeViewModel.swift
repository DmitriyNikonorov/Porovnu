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

    private var dataBaseManager: DataBaseManagerProtocol
    private var lastFetchTime: Date = .distantPast
    private var isFirstLaunch = true
    var events = [EventShort]()

    init(dataBaseManager: DataBaseManagerProtocol) {
        self.dataBaseManager = dataBaseManager
        super.init()
    }

    func fetchModels() async {
        if isFirstLaunch {
            events = await dataBaseManager.fetchEventsShort()
            isFirstLaunch = false
            return
        }


        guard dataBaseManager.lastContextChange > lastFetchTime else {
            return
        }

        Task {
            events = await dataBaseManager.fetchEventsShort()
            lastFetchTime = Date()
        }
    }

    func fetchModels(by id: UUID) async -> Event? {
        return await dataBaseManager.fetchEvent(by: id)
    }

    func deleteModel(by id: UUID) {
        let x = EventModel.self
        events.removeAll(where: { $0.id == id })
        dataBaseManager.deleteById(EventModel.self, id: id)
    }
}


