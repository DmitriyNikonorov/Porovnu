//
//  NavigationBarModifier.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 04.02.2026.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    var type: ScreenType
    let leadingButtonAction: NavigationBarButtonActionType?
    let trailingButtonAction: NavigationBarButtonActionType?
    init(
        model: NavigationBarModel
    ) {
        self.type = model.type
        self.leadingButtonAction = model.leadingButtonAction
        self.trailingButtonAction = model.trailingButtonAction
    }

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(
                Color.appColor(.background),
                for: .navigationBar
            )
            .toolbar {
                switch type {
                case let .home(title):
                    homeToolbar(title: title)

                case let .creationEvent(title):
                    creationEventToolbar(title: title)

                case let .event(title):
                    eventScreenToolbar(title: title)

                case let .editEvent(title):
                    editEventScreenToolbar(title: title)

                case let .editSpending(title):
                    editSpendingScreenToolbar(title: title)
                }
            }
    }

    @ToolbarContentBuilder
    private func homeToolbar(title: String) -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.appColor(.orangeBrand))
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            if let trailingButtonAction, trailingButtonAction.isShowFirstAction.wrappedValue {
                Button {
                    trailingButtonAction.firstAction?()
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.appColor(.orangeBrand))
                }
            }
        }
    }

    @ToolbarContentBuilder
    private func creationEventToolbar(title: String) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if let leadingButtonAction, leadingButtonAction.isShowFirstAction.wrappedValue {
                Button {
                    leadingButtonAction.firstAction?()
                } label: {
                    Text("Отмена")
                        .foregroundStyle(Color.appColor(.orangeBrand))
                }
            }




        }

        ToolbarItem(placement: .principal) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.appColor(.orangeBrand))
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            if let action = trailingButtonAction?.firstAction {
                Button("Создать", action: action)
                    .foregroundStyle(Color.appColor(.orangeBrand))
            }
        }
    }

    @ToolbarContentBuilder
    private func eventScreenToolbar(title: String) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if let leadingButtonAction, leadingButtonAction.isShowFirstAction.wrappedValue {
                Button {
                    leadingButtonAction.firstAction?()
                } label: {
                    Text("Назад")
                        .foregroundStyle(Color.appColor(.orangeBrand))
                }
            }
        }

        ToolbarItem(placement: .principal) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.appColor(.orangeBrand))
        }

        ToolbarItem(placement: .topBarTrailing) {
            if let action = trailingButtonAction?.firstAction {
                Button {
                    action()
                } label: {
                    AppImages.listClipboard.image
                        .foregroundStyle(Color.appColor(.orangeBrand))
                }
            }
        }
    }

    @ToolbarContentBuilder
//    private func editEventScreenToolbar(title: Binding<String>) -> some ToolbarContent {
    private func editEventScreenToolbar(title: String) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if let action = leadingButtonAction?.firstAction {
                Button {
                    action()
                } label: {
                    AppImages.listClipboard.image
                        .foregroundStyle(Color.appColor(.orangeBrand))
                }
            }
        }

        ToolbarItem(placement: .principal) {
//            Text(title.wrappedValue)
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.appColor(.orangeBrand))
        }

        ToolbarItemGroup(placement: .navigationBarTrailing) {
            if let trailingButtonAction = trailingButtonAction {
                // ПЕРВАЯ кнопка (сохранить)
                if trailingButtonAction.isShowFirstAction.wrappedValue == true {
                    Button {
                        trailingButtonAction.firstAction?()
                    } label: {
                        AppImages.save.image
                            .foregroundStyle(Color.appColor(.orangeBrand))
                    }
                }

                // ВТОРАЯ кнопка (дополнительная)
                if trailingButtonAction.isShowSecondAction.wrappedValue == true {
                    Button {
                        trailingButtonAction.secondAction?()
                    } label: {
                        AppImages.edit.image
                            .foregroundStyle(Color.appColor(.orangeBrand))
                    }
                }

            }
        }
    }

    @ToolbarContentBuilder
    private func editSpendingScreenToolbar(title: String) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if let leadingButtonAction, leadingButtonAction.isShowFirstAction.wrappedValue {
                Button {
                    leadingButtonAction.firstAction?()
                } label: {
                    Text("Назад")
                        .foregroundStyle(Color.appColor(.orangeBrand))
                }
            }
        }


        ToolbarItem(placement: .principal) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.appColor(.orangeBrand))
        }
    }
}
