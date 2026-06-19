//
//  AuthRepositoryProtocol.swift
//  P14-Eventorias
//
//  Created by Jaouad on 04/06/2026.
//

import Foundation

/// Protocole pour les fonctionnalités d'authentification et de gestion de session.
protocol AuthRepositoryProtocol: Sendable {

    /// Renvoie l'utilisateur actuellement authentifié sur l'appareil, s'il existe.
    func currentUser() -> AppUser? 
    func signIn (email: String, password: String) async throws -> AppUser
    func signUp (email: String, password: String) async throws -> AppUser
    func signOut() throws
}
