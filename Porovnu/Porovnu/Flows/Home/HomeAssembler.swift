//
//  HomeAssembler.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

protocol HomeAssembler {
    func resolveHomeView() -> HomeView
    func resolve() -> HomeViewModel
}

extension HomeAssembler {
    func resolveHomeView() -> HomeView {
        HomeView(viewModel: resolve())
    }

    func resolve() -> HomeViewModel {
        HomeViewModel()
    }
}
