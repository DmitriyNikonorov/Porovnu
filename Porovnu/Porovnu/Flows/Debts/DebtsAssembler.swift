//
//  DebtsAssembler.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

protocol DebtsAssembler {
    func resolveDebtsView(viewModel: EditCircleViewModel) -> DebtsView
    func resolveDebtsViewModel(event: Event) -> DebtsViewModel
}

extension EventAssembler {
    func resolveDebtsView(viewModel: DebtsViewModel) -> DebtsView {
        DebtsView(viewModel: viewModel)
    }
}

extension DebtsAssembler where Self: DefaultAssembler {
    func resolveDebtsViewModel(event: Event) -> DebtsViewModel {
        DebtsViewModel(event: event)
    }
}
