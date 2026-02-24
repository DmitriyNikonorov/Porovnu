//
//  TabSegmentedView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 22.02.2026.
//

import SwiftUI

enum PagaIndicatorType: String, CaseIterable {
    case spendings
    case debts
}

struct PageView<SpendingsContent: View, DebtsContent: View>: View {
    @Binding var selectedType: PagaIndicatorType
    let spendingsContent: SpendingsContent
    let debtsContent: DebtsContent

    init(selectedType: Binding<PagaIndicatorType>,
         @ViewBuilder spendingsContent: () -> SpendingsContent,
         @ViewBuilder debtsContent: () -> DebtsContent
    ) {
        self._selectedType = selectedType
        self.spendingsContent = spendingsContent()
        self.debtsContent = debtsContent()
    }

    var body: some View {
        ZStack {
            contentView
            VStack {
                PagaIndicator(selectedPage: $selectedType)
                Spacer()
            }

        }
    }

    private var contentView: some View {
        TabView(selection: $selectedType) {
            spendingsContent
                .tag(PagaIndicatorType.spendings)

            debtsContent
                .tag(PagaIndicatorType.debts)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}
