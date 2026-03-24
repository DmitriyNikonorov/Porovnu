//
//  EventsListAssembler.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

import Foundation

protocol EventsListAssembler {
    func resolveEventsListView(model: EventsListViewModel) -> EventsListView
    func resolveEventsListViewModel(dto: EventListDto) -> EventsListViewModel
}

extension EventsListAssembler where Self: DefaultAssembler {

    func resolveEventsListView(model: EventsListViewModel) -> EventsListView {
        EventsListView(viewModel: model)
    }

    func resolveEventsListViewModel(dto: EventListDto) -> EventsListViewModel {
        EventsListViewModel(dto: dto, dataBaseManager: resolveDataBaseManager())
    }
}
