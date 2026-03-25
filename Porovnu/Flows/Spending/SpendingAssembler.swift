//
//  SpendingAssembler.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 15.02.2026.
//

protocol SpendingAssembler {
    func resolveSpendingView(viewModel: SpendingViewModel) -> SpendingView
    func resolveSpendingViewModel(
        dto: EditSpendingDto
    ) -> SpendingViewModel
}

extension SpendingAssembler {

    func resolveSpendingView(viewModel: SpendingViewModel) -> SpendingView {
        SpendingView(viewModel: viewModel)
    }
}

extension SpendingAssembler where Self: DefaultAssembler {
    func resolveSpendingViewModel(
        dto: EditSpendingDto
    ) -> SpendingViewModel {
        SpendingViewModel(
            dto: dto,
            dataBaseManager: resolveDataBaseManager()
        )
    }
}
