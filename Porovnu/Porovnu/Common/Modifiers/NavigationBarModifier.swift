//
//  NavigationBarModifier.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 04.02.2026.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    var type: ScreenType
    let leadingButtonAction: (() -> Void)?
    let trailingButtonAction: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(
                Color.appColor(.background),
                for: .navigationBar
            )
//                    .toolbarColorScheme(.light, for: .navigationBar) // ← опционально
            .toolbar {
                switch type {
                case .home(let title):
                    homeToolbar(title: title)

                case .creationEvent(let title):
                    creationEventToolbar(title: title)

                case .event(let title):
                    eventScreenToolbar(title: title)
                }
            }
    }



    @ToolbarContentBuilder
    private func homeToolbar(title: String) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.appColor(.orangeBrand))
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            if let trailingButtonAction {
                Button(action: trailingButtonAction) {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.appColor(.orangeBrand))
                }
            }
        }
    }

    @ToolbarContentBuilder
    private func creationEventToolbar(title: String) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if let leadingButtonAction {
                Button("Отмена", action: leadingButtonAction)
                    .foregroundStyle(Color.appColor(.orangeBrand))
            }
        }

        ToolbarItem(placement: .principal) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.appColor(.orangeBrand))
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            if let trailingButtonAction {
                Button("Создать", action: trailingButtonAction)
                    .foregroundStyle(Color.appColor(.orangeBrand))
            }
        }
    }

    @ToolbarContentBuilder
    private func eventScreenToolbar(title: String) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if let leadingButtonAction {
                Button("Назад", action: leadingButtonAction)
                    .foregroundStyle(Color.appColor(.orangeBrand))
            }
        }

        ToolbarItem(placement: .principal) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.appColor(.orangeBrand))
        }
    }
}
