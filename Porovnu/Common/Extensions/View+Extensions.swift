//
//  View+Extensions.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 04.02.2026.
//

import SwiftUI

struct NavigationBarButtonActionType {
    let firstAction: (() -> Void)?
    let isShowFirstAction: Binding<Bool>

    let secondAction: (() -> Void)?
    let isShowSecondAction: Binding<Bool>

    init(
        firstAction: (() -> Void)? = nil,
        isShowFirstAction: Binding<Bool> = .constant(true),
        secondAction: (() -> Void)? = nil,
        isShowSecondAction: Binding<Bool> = .constant(true)
    ) {
        self.firstAction = firstAction
        self.secondAction = secondAction
        self.isShowFirstAction = isShowFirstAction
        self.isShowSecondAction = isShowSecondAction
    }
}
struct NavigationBarModel {
    let type: ScreenType
    let leadingButtonAction: NavigationBarButtonActionType?
    let trailingButtonAction: NavigationBarButtonActionType?

    init(
        type: ScreenType,
        leadingButtonAction: NavigationBarButtonActionType? = nil,
        trailingButtonAction: NavigationBarButtonActionType? = nil
    ) {
        self.type = type
        self.leadingButtonAction = leadingButtonAction
        self.trailingButtonAction = trailingButtonAction
    }

    var isLeadingFirstActionExistAndShow: Bool {
        if let leadingButtonAction, leadingButtonAction.isShowFirstAction.wrappedValue {
            return true
        }
        return false
    }

    var isLeadingSecondActionExistAndShow: Bool {
        if let leadingButtonAction, leadingButtonAction.isShowSecondAction.wrappedValue {
            return true
        }
        return false
    }

    var isTrailingFirstActionExistAndShow: Bool {
        if let trailingButtonAction, trailingButtonAction.isShowFirstAction.wrappedValue {
            return true
        }
        return false
    }

    var isTrailingSecondActionExistAndShow: Bool {
        if let trailingButtonAction, trailingButtonAction.isShowSecondAction.wrappedValue {
            return true
        }
        return false
    }
}


extension View {

    // MARK: - Navigation bar

    func navigationBar(
        model: NavigationBarModel
    ) -> some View {
        modifier(
            NavigationBarModifier(
                model: model
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


    func frame(_ frame: Frame) -> some View {
        self.frame(
            width: frame.size,
            height: frame.size,
            alignment: frame.alignment
        )
    }
}
