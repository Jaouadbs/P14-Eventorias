//
//  AuthError.swift
//  P14-Eventorias
//
//  Created by Jaouad on 04/06/2026.
//

import Foundation

/// Erreurs spécifiques liées a l'authentification et de validation de compte.
enum AuthError: LocalizedError {
    
    // MARK: - Cas d'Erreurs
    case invalidCredentials
    case emptyFields
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials: 
            return "Email ou mot de passe incorrect."
        case .emptyFields:
            return "Merci de renseigner tous les champs."
        case .unknown(let msg):
            return msg
        }
    }
}
