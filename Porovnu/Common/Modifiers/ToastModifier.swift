//
//  ToastModifier.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 25.03.2026.
//

import SwiftUI

struct ToastModifier<T: View>: ViewModifier {

    @Binding var showToast: Bool
    // let tostContent: T - это свойство модификатора, в котором хранится ТОСТ
    let tostContent: T

    // content: Content - это параметр метода body, сам view к которому применяется модификатор
    func body(content: Content) -> some View {
        ZStack {
            content //  ← первый content - это ОСНОВНОЙ экран (переданный через модификато)
            ZStack {
                if showToast {
                    tostContent  // ← второй content - это ТОСТ (свойство модификатора)
                } else {
                    EmptyView()
                }
            }
        }
    }
}

extension View {
    func showToast<T: View>(showToast: Binding<Bool>, content: T) -> some View {
        self.modifier(ToastModifier(showToast: showToast, tostContent: content))
    }
}
