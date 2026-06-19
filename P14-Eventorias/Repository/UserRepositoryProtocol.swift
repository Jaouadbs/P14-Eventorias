//
//  UserRepositoryProtocol.swift
//  P14-Eventorias
//
//  Created by Jaouad on 09/06/2026.
//

import Foundation

/// Protocole des capacités requises pour la gestion des données de profil utilisateur.
protocol UserRepositoryProtocol: Sendable {
    func fetchProfile(uid: String) async throws -> UserProfile
    func updateNotifications(uid: String, enabled: Bool) async throws
}
