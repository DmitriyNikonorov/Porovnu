//
//  DebtsAssembler.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

protocol DebtsAssembler {
    func resolveDebtsViewModel(event: Event) -> DebtsViewModel
}

extension DebtsAssembler where Self: DefaultAssembler {
    func resolveDebtsViewModel(event: Event) -> DebtsViewModel {
        DebtsViewModel(event: event)
    }
}
