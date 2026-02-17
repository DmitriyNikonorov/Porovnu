//
//  ProfileView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 07.02.2026.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var navagationCoordinator: NavigationCoordinator

    var body: some View {
        Text("Profile")
            .navigationBarTitle("Profile")
            .navigationBarItems(trailing: Button("Logout") {
//                self.navagationCoordinator.navigate(to:
            })
    }
}
