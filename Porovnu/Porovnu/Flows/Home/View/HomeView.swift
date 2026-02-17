//
//  ContentView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 02.02.2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    //    @Environment(\.modelContext) private var modelContext
    //    @Query private var items: [Item]
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    @State private var showLeftAlert: Bool = false
    @State private var showRightAlert: Bool = false

    @State var viewModel: HomeViewModel

    var body: some View {
        List {
            ForEach(viewModel.events) { event in
                EventCardView(event: event)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .onTapGesture {
                        print("🖖 \(event.name)")
                        guard let event = viewModel.fetchModels(by: event.id) else {
                            return
                        }
                        navigationCoordinator.navigate(to:.eventDetails(event))
                    }
            }
            .onDelete(perform: deleteItems)
        }
        .contentMargins(.top, 24, for: .scrollContent)
        .background(Color.appColor(.backgroundSecondary))
        .listStyle(.plain)
        .foregroundStyle(Color.appColor(.backgroundSecondary))
        .navigationBar(
            for: .home(title: "Мероприятия"),
            trailingButtonAction: navigationCoordinator.goToCreateEvent
        )
        .onAppear {
            viewModel.fetchModels()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        //        withAnimation {
        //            for index in offsets {
        //                modelContext.delete(items[index])
        //            }
        //        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
