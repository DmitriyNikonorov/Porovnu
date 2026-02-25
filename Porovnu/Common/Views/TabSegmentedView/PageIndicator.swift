//
//  PageIndicator.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 22.02.2026.
//

import SwiftUI

struct PagaIndicator: View {
    @Binding var selectedPage: PagaIndicatorType

    var body: some View {
        HStack(spacing: 8) {
            ForEach(PagaIndicatorType.allCases, id: \.self) { type in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(selectedPage == type ?
                                     Color.appColor(.blueBrand) :
                                        Color.appColor(.grayBrand).opacity(0.5)
                    )
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .opacity(0.9)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    Color.appColor(.backgroundSecondary)
                )
                .blur(radius: 8)
        )
    }
}
