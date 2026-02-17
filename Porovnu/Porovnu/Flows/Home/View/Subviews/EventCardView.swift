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
                .padding(.top, 16)
                .padding(.horizontal, 16)

            // Участники
            HStack {
                AppImages.person2Fill.image
                    .font(.caption)
                    .foregroundStyle(Color.appColor(.orangeBrand))

                Text("\(event.contributorsCount) участников")
                    .font(.caption)
                    .foregroundStyle(Color.appColor(.textTertiary))

                Spacer()

                // Дата создания (если есть в модели)
//                if let date = event.createdAt {
//                    Text(date, style: .date)
//                        .font(.caption2)
//                        .foregroundStyle(.white.opacity(0.6))
//                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
