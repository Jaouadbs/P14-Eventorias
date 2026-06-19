//
//  P14_EventoriasApp.swift
//  P14-Eventorias
//
//  Created by Jaouad on 04/06/2026.
//

import SwiftUI
import FirebaseCore

// MARK: - Point d'Entrée de l'Application

@main
struct P14_EventoriasApp: App {
    @State private var session: SessionStore
    private let authRepository: AuthRepositoryProtocol
    private let eventRepository: EventRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    
    init() {
        FirebaseApp.configure()         // avant accès à firebase
        
        // Mode test UI : on branche les mocks (hors-ligne, déconnecté)
        if CommandLine.arguments.contains("-UITest") {
            let auth = MockAuthRepository()           // loggedIn: nil → écran de connexion garanti
            self.authRepository  = auth
            self.eventRepository = MockEventRepository()
            self.userRepository  = MockUserRepository()
            _session = State(initialValue: SessionStore(authRepository: auth))
        } else {
            // Mode normal : Firebase
            let auth = FirebaseAuthRepository()
            self.authRepository  = auth
            self.eventRepository = FirebaseEventRepository()
            self.userRepository  = FirebaseUserRepository()
            _session = State(initialValue: SessionStore(authRepository: auth))
        }
    }

    // MARK: - Scène Principale
    var body: some Scene {
        WindowGroup {
            RootView(
                authRepository: authRepository,
                eventRepository: eventRepository,
                userRepository : userRepository
            )
            .environment(session)
            .preferredColorScheme(.dark)
        }
    }
}
