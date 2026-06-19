//
//  MockAuthRepository.swift
//  P14-Eventorias
//
//  Created by Jaouad on 04/06/2026.
//

import Foundation

/// Mock d'authentification pour les tests unitaires et les Previews
final class MockAuthRepository: AuthRepositoryProtocol {
    // MARK: - Propriétés de Configuration
    private let result: Result<AppUser, Error>
    private var storedUser: AppUser?

    // MARK: - Initialiseur
    init(
        result: Result<AppUser, Error> = .success(.preview),
        loggedIn: AppUser? = nil
    ) {
        self.result = result
        self.storedUser = loggedIn
    }

    // MARK: - Méthodes du Protocole

    /// Renvoie l'utilisateur actuellement connecté, ou "nil" si aucune session n'est active.
    func currentUser() -> AppUser? {
        storedUser
    }

    /// Simule une tentative de connexion par e-mail/mot de passe avec une latence réseau .
    func signIn(email: String, password: String) async throws -> AppUser {
        try await Task.sleep(for: .milliseconds(600))  // simule la latence réseau

        let user = try result.get()
        storedUser = user
        return user
    }

    /// Simule une tentative d'inscription en réutilisant la logique et le résultat de "signIn."
    func signUp(email: String, password: String) async throws -> AppUser {
        try await signIn(email: email, password: password)
    }

    /// Simule la fermeture de la session utilisateur.
    func signOut() throws {
        // l'utilisateur stocké passe à nil pour simuler la déconnexion lors des tests.
                storedUser = nil
    }
}
