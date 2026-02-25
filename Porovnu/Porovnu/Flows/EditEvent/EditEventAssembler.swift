//
//  EditEventAssembler.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 14.02.2026.
//

protocol EditEventAssembler {
    func resolveEditEventView(viewModel: EditEventViewModel) -> EditEventView
//    func resolveEditEventViewModel(dto: EditEventDto, assembler: SpendingAssembler) -> EditEventViewModel
    func resolveEditEventViewModel(assembler: SpendingAssembler) -> EditEventViewModel
}

extension EditEventAssembler {
    func resolveEditEventView(viewModel: EditEventViewModel) -> EditEventView {
        EditEventView(viewModel: viewModel)
    }
}

extension EditEventAssembler where Self: DefaultAssembler {
    func resolveEditEventViewModel(assembler: SpendingAssembler) -> EditEventViewModel {
        EditEventViewModel(assembler: assembler, dataBaseManager: resolveDataBaseManager())
    }
}
