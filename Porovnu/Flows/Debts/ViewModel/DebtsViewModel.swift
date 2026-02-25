//
//  DebtsViewModel.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 22.02.2026.
//

import Observation

@Observable
final class DebtsViewModel: ViewModel {

    // MARK: - Private properties

    private let event: Event

    // MARK: - Init

    init(event: Event) {
        self.event = event
        super.init()
    }



}
