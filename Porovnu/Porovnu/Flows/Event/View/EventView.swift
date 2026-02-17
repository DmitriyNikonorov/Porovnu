//
//  EventView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 02.02.2026.
//

import SwiftUI

struct EventView: View {
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    @State var viewModel: EventViewModel

    var body: some View {
        List {
            Section("Название мероприятия") {
                Text(viewModel.event.name)
                    .font(.headline)
            }

            Section("Участники") {
                if viewModel.event.contributors.isEmpty {
                    Text("Нет участников")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.event.contributors.indices, id: \.self) { index in
                        HStack {
                            Text("\(index + 1).")
                                .foregroundStyle(.secondary)
                            Text(viewModel.event.contributors[index].name)
                        }
                    }
                }
            }
        }
        .navigationBar(
            for: .creationEvent(title: viewModel.event.name),
            leadingButtonAction: navigationCoordinator.navigateToRoot
        )
    }
}
