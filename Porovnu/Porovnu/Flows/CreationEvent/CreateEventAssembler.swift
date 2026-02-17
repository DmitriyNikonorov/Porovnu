//
//  CreateEventAssembler.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

protocol CreateEventAssembler {
    func resolveCreateEventView() -> CreateEventView
    func resolve() -> CreateEventViewModel
}

extension CreateEventAssembler {
    func resolveCreateEventView() -> CreateEventView {
        CreateEventView(viewModel: resolve())
    }

    func resolve() -> CreateEventViewModel {
        CreateEventViewModel()
    }
}
