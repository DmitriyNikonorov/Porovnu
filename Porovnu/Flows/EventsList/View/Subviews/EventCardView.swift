//
//  EventCardView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

import SwiftUI

struct EventCardView: View {
    let event: EventShort

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Название мероприятия
            Text(event.name)
                .font(.headline)
                .foregroundStyle(Color.appColor(.textSecondary))
                .lineLimit(2)

            // Участники
            HStack {
                AppImages.person2Fill.image
                    .font(.caption)
                    .foregroundStyle(Color.appColor(.orangeBrand))

                Text("\(event.contributorsCount) участников")
                    .font(.caption)
                    .foregroundStyle(Color.appColor(.textTertiary))

                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.appColor(.backgroundTertiary))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.appColor(.orangeBrand).opacity(0.3), lineWidth: 1)
                )
        )
    }
}
