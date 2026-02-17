//
//  EditEventAssembler.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 14.02.2026.
//

protocol EditEventAssembler {
    func resolveEditEventView(viewModel: EditEventViewModel) -> EditEventView
    func resolveEditEventViewModel(dto: EditEventDto, assembler: SpendingAssembler) -> EditEventViewModel
}

extension EditEventAssembler {
    func resolveEditEventView(viewModel: EditEventViewModel) -> EditEventView {
        EditEventView(viewModel: viewModel)
    }
}

extension EditEventAssembler where Self: DefaultAssembler {
    func resolveEditEventViewModel(dto: EditEventDto, assembler: SpendingAssembler) -> EditEventViewModel {
        EditEventViewModel(dto: dto, assembler: assembler, dataBaseManager: resolveDataBaseManager())
    }
}
