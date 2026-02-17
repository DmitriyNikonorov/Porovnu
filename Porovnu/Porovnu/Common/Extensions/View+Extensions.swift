//
//  View+Extensions.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 04.02.2026.
//

import SwiftUI

extension View {

    // MARK: - Navigation bar

    func navigationBar(for type: ScreenType, leadingButtonAction: (() -> Void)? = nil, trailingButtonAction: (() -> Void)? = nil) -> some View {
        modifier(
            NavigationBarModifier(
                type: type,
                leadingButtonAction: leadingButtonAction,
                trailingButtonAction: trailingButtonAction
            )
        )
    }

    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
