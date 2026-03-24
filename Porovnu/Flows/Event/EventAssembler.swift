//
//  EventAssembler.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

protocol EventAssembler {
    func resolveEventView(viewModel: EditCircleViewModel) -> EditCircleView
    func resolveEventViewModel(event: Event, assembler: SpendingAssembler) -> EditCircleViewModel
}

extension EventAssembler {
    func resolveEventView(viewModel: EditCircleViewModel) -> EditCircleView {
        EditCircleView(viewModel: viewModel)
    }
}

extension EventAssembler where Self: DefaultAssembler {
    func resolveEventViewModel(event: Event, assembler: SpendingAssembler) -> EditCircleViewModel {
        EditCircleViewModel(event: event, assembler: assembler, dataBaseManager: resolveDataBaseManager())
    }
}
