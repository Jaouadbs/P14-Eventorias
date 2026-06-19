//
//  MockUserRepository.swift
//  P14-Eventorias
//
//  Created by Jaouad on 10/06/2026.
//

import Foundation

/// Mock du dépôt utilisateur pour les tests et les Previews
final class MockUserRepository : UserRepositoryProtocol {

    private let shouldFail : Bool

    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }

    // MARK: - Méthodes du Protocole

    /// Simule la récupération d'un profil utilisateur avec une légère latence.
    func fetchProfile(uid: String) async throws -> UserProfile {
        try await Task.sleep(for: .microseconds(300))
        if shouldFail { throw URLError(.badServerResponse)}
        return UserProfile(
            id: uid,
            name: "Christopher Evans",
            email: "christopherevans@gmail.com",
            photoURL: URL(string: "https://images.unsplash.com/photo-1534528741775-53994a69daeb"), //  URL d'image de test
            notificationsEnabled: true
        )
    }
    /// Simule la mise à jour des préférences de notification de l'utilisateur.
    func updateNotifications(uid: String, enabled: Bool) async throws {
        try await Task.sleep(for: .milliseconds(200))
        if shouldFail {
            throw URLError(.networkConnectionLost)
        }
    }
}
