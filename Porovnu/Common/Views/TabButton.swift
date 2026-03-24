//
//  TabButton.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 07.02.2026.
//

import SwiftUI

struct TabButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                tab.image
                    .font(.system(size: 22, weight: .medium))
                    .symbolVariant(isSelected ? .fill : .none)
                    .frame(width: 28, height: 28)

                Text(tab.title)
                    .font(.system(size: 11, weight: .medium))
                    .scaleEffect(isSelected ? 1.0 : 0.9)
            }
            .foregroundColor(isSelected ? .appColor(.orangeBrand) : .appColor(.grayBrand))
            .frame(maxWidth: .infinity)
        }
    }
}
