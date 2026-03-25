//
//  VisibilityTrackerModifier.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 25.03.2026.
//

import SwiftUI

struct VisibilityTrackerModifier: ViewModifier {

    @Binding var isVisible: Bool
    let coordinateSpace: String

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            updateVisibility(with: geometry)
                        }
                        .onChange(of: geometry.frame(in: .named(coordinateSpace)).minY) {
                            updateVisibility(with: geometry)
                        }
                }
            )
    }

    private func updateVisibility(with geometry: GeometryProxy) {
        let frame = geometry.frame(in: .named(coordinateSpace))

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let screenHeight = windowScene.screen.bounds.height
            let isCurrentlyVisible = frame.maxY > 140 && frame.minY < screenHeight - 150
            isVisible = isCurrentlyVisible
        }
    }
}

extension View {
    func visibilityTracker(isVisible: Binding<Bool>, coordinateSpace: String) -> some View {
        modifier(VisibilityTrackerModifier(isVisible: isVisible, coordinateSpace: coordinateSpace))
    }
}
