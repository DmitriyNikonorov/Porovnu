//
//  ProfileView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 07.02.2026.
//

import SwiftUI

struct ProfileView: View {

    @Environment(NavigationCoordinator.self) private var navigationCoordinator

    var body: some View {
        Text(Localized.ProfileView.profile)
            .navigationBarTitle(Localized.ProfileView.profile)
            .navigationBarItems(trailing: Button(Localized.ProfileView.logout) {
//                self.navagationCoordinator.navigate(to:
            })
    }
}
