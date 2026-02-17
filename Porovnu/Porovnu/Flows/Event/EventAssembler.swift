//
//  EventAssembler.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

protocol EventAssembler {
    func resolveEventView(viewModel: EventViewModel) -> EventView
    func resolveEventViewModel(event: Event, assembler: SpendingAssembler) -> EventViewModel
}

extension EventAssembler {
    func resolveEventView(viewModel: EventViewModel) -> EventView {
        EventView(viewModel: viewModel)
    }
}

extension EventAssembler where Self: DefaultAssembler {
    func resolveEventViewModel(event: Event, assembler: SpendingAssembler) -> EventViewModel {
        EventViewModel(event: event, assembler: assembler, dataBaseManager: resolveDataBaseManager())
    }
}
