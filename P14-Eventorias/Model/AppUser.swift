//
//  AppUser.swift
//  P14-Eventorias
//
//  Created by Jaouad on 04/06/2026.
//

import Foundation

/// Modèle représentant l'identité de l'utilisateur actuellement authentifié.
struct AppUser: Identifiable,Equatable, Sendable {

    let id:             String
    let email:          String
    var displayName:    String?
    var photoURL:       URL?
}

// MARK: - Données Previews
extension AppUser {
    static let preview = AppUser(
        id:          "preview-uid",
        email:       "jeandupont@gmail.com",
        displayName: "Jean Dupont"
    )
}
