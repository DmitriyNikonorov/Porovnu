//
//  SpendingAssembler.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 15.02.2026.
//

protocol SpendingAssembler {
    func resolveSpendingView(viewModel: SpendingViewModel) -> SpendingView
//    func resolveSpendingViewModel(
//        creditor: Contributor,
//        contributors: [Contributor],
//        spending: Spending?,
//        onSave: @escaping (Spending?) -> Void
//    ) -> SpendingViewModel
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

//    func resolveSpendingViewModel(
//        creditor: Contributor,
//        contributors: [Contributor],
//        spending: Spending?,
//        onSave: @escaping (Spending?) -> Void
//    ) -> SpendingViewModel {
//        SpendingViewModel(
//            creditor: creditor,
//            contributors: contributors,
//            spending: spending,
//            dataBaseManager: resolveDataBaseManager(),
//            onSave: onSave
//        )
//    }
    func resolveSpendingViewModel(
        dto: EditSpendingDto
    ) -> SpendingViewModel {
        SpendingViewModel(
            dto: dto,
            dataBaseManager: resolveDataBaseManager()
        )
    }
}
