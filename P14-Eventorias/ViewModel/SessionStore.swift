//
//  SessionStore.swift
//  P14-Eventorias
//
//  Created by Jaouad on 08/06/2026.
//


import Foundation
import Observation

// MARK: - Gestionnaire de Session Utilisateur
// Etat de connexion de l'application, gère la persistance au démarrage et synchronise l'interface utilisateur avec l'état de l'authentification.
/// Etat de session partagé entre les onglets (injecté via Environment).
@MainActor
@Observable
final class SessionStore {
    
    /// L'utilisateur actuellement connecté (nil si aucun utilisateur n'est authentifié).
    private(set) var currentUser: AppUser?
    
    private let authRepository: AuthRepositoryProtocol
    
    /// Initialise le gestionnaire de session et tente de restaurer une connexion existante.
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
        self.currentUser = authRepository.currentUser()     // session persistante au lancement
    }
    
    var isAuthenticated: Bool { currentUser != nil }
    
    
    // MARK: - Logique Métier / Actions Globaux
    
    /// Définit manuellement l'utilisateur actuel
    func setUser(_ user: AppUser) {
        currentUser = user
    }
    
    /// Déconnecte l'utilisateur du dépôt d'authentification et réinitialise l'état local.
    func signOut() {
        try? authRepository.signOut()
        currentUser = nil
    }
}
