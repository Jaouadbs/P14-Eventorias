//
//  UserProfile.swift
//  P14-Eventorias
//
//  Created by Jaouad on 09/06/2026.
//

import Foundation

/// Modèle représentant le profil d'un utilisateur.
struct UserProfile: Identifiable, Equatable, Sendable {
    let id:                   String
    var name:                 String
    var email:                String
    var photoURL:             URL?
    var notificationsEnabled: Bool
}
