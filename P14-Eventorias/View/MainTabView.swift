//
//  MainTabView.swift
//  P14-Eventorias
//
//  Created by Jaouad on 09/06/2026.
//

import SwiftUI

/// Vue principale de navigation par onglets (Bottom Bar).
struct MainTabView: View {
    let eventRepository: EventRepositoryProtocol
    let userRepository: UserRepositoryProtocol
    @Environment(SessionStore.self) private var session

    var body: some View {
        TabView {
            // MARK: Onglet 1 - Liste des Événements
            Tab("Events", systemImage: "calendar") {
                NavigationStack {
                    EventListView(repository: eventRepository)}
            }
            // MARK: Onglet 2 - Profil Utilisateur
            Tab("Profile", systemImage: "person"){
                NavigationStack {
                    ProfileView(
                        uid: session.currentUser?.id ?? "",
                        userRepository: userRepository
                    )
                }
            }
        }
        // Onglet selectionné en rouge comme la maquette
        .tint(.appPrimary)
    }
}

#Preview {
    MainTabView(eventRepository: MockEventRepository(), userRepository: MockUserRepository())
        .environment(SessionStore(authRepository: MockAuthRepository(loggedIn: .preview)))
        .preferredColorScheme(.dark)
}
