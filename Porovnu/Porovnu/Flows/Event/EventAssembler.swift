//
//  EventAssembler.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

protocol EventAssembler {
    func resolveEventView(event: Event) -> EventView
    func resolve(event: Event) -> EventViewModel
}

extension EventAssembler {
    func resolveEventView(event: Event) -> EventView {
        EventView(viewModel: resolve(event: event))
    }

    func resolve(event: Event) -> EventViewModel {
        EventViewModel(event: event)
    }
}
