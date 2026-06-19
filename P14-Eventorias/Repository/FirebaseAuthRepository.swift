//
//  FirebaseAuthRepository.swift
//  P14-Eventorias
//
//  Created by Jaouad on 04/06/2026.
//

import Foundation
import FirebaseAuth

/// Repo authentification exploitant directement le SDK Firebase Authentication.
///
/// la classe gère le cycle de vie de la session de l'utilisateur (connexion, inscription, déconnexion)
final class FirebaseAuthRepository: AuthRepositoryProtocol {

    // MARK: - Méthodes du Protocole

    /// Récupère l'utilisateur actuellement connecté si une session locale active existe.
    func currentUser() -> AppUser? {
        Auth.auth().currentUser.map(AppUser.init(firebaseUser:))
    }

    /// Connecte un utilisateur existant auprès de Firebase à l'aide de ses identifiants.
    func signIn(email: String, password: String) async throws -> AppUser {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return AppUser(firebaseUser: result.user)
    }

    /// Crée un nouveau compte utilisateur dans la base Firebase Authentication.
    func signUp(email: String, password: String) async throws -> AppUser {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return AppUser(firebaseUser: result.user)
    }

    /// Ferme la session Firebase active sur l'appareil.
    func signOut()throws {
        try Auth.auth().signOut()
    }
}

// MARK: - Extension de Mapping firebase
private extension AppUser {

    init(firebaseUser user: User) {
        self.init(
            id:          user.uid,
            email:       user.email ?? "",
            displayName: user.displayName,
            photoURL:    user.photoURL
        )
    }
}
