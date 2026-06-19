//
//  RootView.swift
//  P14-Eventorias
//
//  Created by Jaouad on 04/06/2026.
//  Vue Racine

import Foundation
import SwiftUI

// MARK: - Vue Racine (Aiguillage)
// Point d'ancrage de l'interface utilisateur

struct RootView: View {
    // MARK: -  Injection de dépendances
    let authRepository: AuthRepositoryProtocol
    let eventRepository: EventRepositoryProtocol
    let userRepository: UserRepositoryProtocol
    
    @Environment(SessionStore.self) private var session

    var body: some View {
        Group {
            if session.isAuthenticated {
                MainTabView(eventRepository: eventRepository, userRepository: userRepository)

            } else {
                SignInView(authRepository: authRepository) { user in
                    session.setUser(user)
                }
            }
        }
    }
}

