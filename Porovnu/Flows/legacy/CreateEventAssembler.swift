//
//  CreateEventAssembler.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

protocol CreateEventAssembler {
    func resolveCreateEventView() -> CreateEventView
    func resolveCreateEventViewModel() -> CreateEventViewModel
}

extension CreateEventAssembler {
    func resolveCreateEventView() -> CreateEventView {
        CreateEventView(viewModel: resolveCreateEventViewModel())
    }
}

extension CreateEventAssembler where Self: DefaultAssembler {
    func resolveCreateEventViewModel() -> CreateEventViewModel {
        CreateEventViewModel(dataBaseManager: resolveDataBaseManager())
    }
}
