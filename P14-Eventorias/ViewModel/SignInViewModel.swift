//
//  SignInViewModel.swift
//  P14-Eventorias
//
//  Created by Jaouad on 05/06/2026.
//

import Foundation
import Observation

// MARK: - ViewModel de Connexion (Sign In)
// L'écran de connexion,  les saisies utilisateur et  le succès de l'authentification
@MainActor
@Observable
final class SignInViewModel {
    // MARK: - Propriétés Observables
    var email = ""
    var password = ""
    var isLoading = false
    var errorMessage: String?
    
    // MARK: - Dépendances Privées
    private let repository : AuthRepositoryProtocol
    private let onAuthenticated: (AppUser) -> Void
    
    // MARK: - Initialiseur
    /// Initialise le ViewModel avec le système d'authentification et le callback de réussite.
    init(
        repository: AuthRepositoryProtocol,
        onAuthenticated: @escaping (AppUser) -> Void
    ){
        self.repository = repository
        self.onAuthenticated = onAuthenticated
    }
    
    /// Règle de validation permettant d'activer ou désactiver le bouton "Se connecter" dans l'UI.
    var canSubmit: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty && !password.isEmpty
    }
    
    // MARK: - Logique Métier / Actions
    /// Exécute la tentative de connexion auprès du dépôt d'authentification.
    func signIn() async {
        guard canSubmit else {
            errorMessage = AuthError.emptyFields.localizedDescription
            return
        }
        isLoading = true
        errorMessage = nil
        // Garantie que l'indicateur de chargement s'arrête à la fin de la fonction, succès ou échec
        defer { isLoading = false }
        
        do {
            let user = try await repository.signIn(email: email, password: password)
            onAuthenticated(user)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
