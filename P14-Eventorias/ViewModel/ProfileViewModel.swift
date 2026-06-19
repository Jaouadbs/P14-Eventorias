//
//  ProfileViewModel.swift
//  P14-Eventorias
//
//  Created by Jaouad on 10/06/2026.
//

import Foundation
import Observation

/// ViewModel  de l'écran de profil utilisateur.

@MainActor
@Observable
final class ProfileViewModel {

    // MARK: - États de la Vue
    enum ViewState {
        case loading,
             loaded(UserProfile),
             error
    }

    // MARK: - Propriétés Observables
    private(set) var state: ViewState = .loading
    var notificationsEnabled = false
    
    private let uid: String
    private let repository: UserRepositoryProtocol

    // MARK: - Initialiseur
    init(uid: String, repository: UserRepositoryProtocol) {
        self.uid = uid
        self.repository = repository
    }

    // MARK: - Logique Métier / Actions

    /// Charge les données du profil utilisateur depuis le serveur.
    func load() async {
        state = .loading
        do {
            let profile = try await repository.fetchProfile(uid: uid)
            notificationsEnabled = profile.notificationsEnabled
            state = .loaded(profile)
        } catch {
            state = .error
        }
    }

    /// Met à jour l'état des notifications côté local puis synchronise le choix sur le serveur.
    func setNotifications(_ enabled: Bool) async {
        notificationsEnabled = enabled

        //Un try? est appliqué ici pour ne pas bloquer l'UI locale
        try? await repository.updateNotifications(uid: uid, enabled: enabled)
    }
}
