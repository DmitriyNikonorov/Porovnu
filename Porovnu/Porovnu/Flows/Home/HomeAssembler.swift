//
//  HomeAssembler.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

protocol HomeAssembler {
    func resolveHomeView(model: HomeViewModel) -> HomeView
    func resolve() -> HomeViewModel
}

extension HomeAssembler where Self: DefaultAssembler {

    func resolveHomeView(model: HomeViewModel) -> HomeView {
        HomeView(viewModel: model)
    }

    func resolve() -> HomeViewModel {
        HomeViewModel(dataBaseManager: resolveDataBaseManager())
    }
}
