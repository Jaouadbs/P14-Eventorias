//
//  FirebaseUserRepository.swift
//  P14-Eventorias
//
//  Created by Jaouad on 10/06/2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

/// Repo utilisateur avec Firebase Authentication et Firestore.
final class FirebaseUserRepository:  UserRepositoryProtocol {
    
    // MARK: - Propriétés Privées
    /// Référence vers la collection "users" dans Firestore.
    private var  collection: CollectionReference {
        Firestore.firestore().collection("users")
    }
    
    // MARK: - Méthodes
    /// Récupère le profil de l'utilisateur en combinant FirebaseAuth (fallback) et Firestore (source de vérité).
    func fetchProfile(uid: String) async throws -> UserProfile {
        let authUser = Auth.auth().currentUser
        
        //Base depuis Auth(Tjrs disponible apres connexion)
        let profile = UserProfile(
            id: uid,
            name: authUser?.displayName ?? "",
            email: authUser?.email ?? "",
            photoURL: authUser?.photoURL,
            notificationsEnabled: true
        )
        // Tentative de récupération du document Firestore
        let doc = try await collection.document(uid).getDocument()
        
        // Décodage via le DTO si le document existe
        guard doc.exists, let dto = try? doc.data(as: UserProfilDTO.self) else {
            return profile
        }
        // Utilisation de la méthode de mapping du DTO avec repli sur Auth si un champ est manquant
        let domainProfile = dto.toDomain(id: uid)
        
        return UserProfile(
            id: uid,
            name: domainProfile.name.isEmpty ? profile.name : domainProfile.name,
            email: domainProfile.email.isEmpty ? profile.email : domainProfile.email,
            photoURL: domainProfile.photoURL ?? profile.photoURL,
            notificationsEnabled: dto.notificationsEnabled ?? profile.notificationsEnabled
        )
    }
    
    /// Met à jour les préférences de notification de l'utilisateur dans son document Firestore.
    func updateNotifications(uid: String, enabled: Bool) async throws {
        try await collection.document(uid)
            .setData(["notificationsEnabled": enabled], merge: true)
    }
}
// MARK: - Data Transfer Object

/// Représentation  des données stockées dans Firestore
private struct UserProfilDTO: Codable {
    var name: String?
    var email: String?
    var photoURL: String?
    var notificationsEnabled: Bool?
    
    /// Convertit le DTO en modèle métier propre à l'application
    func toDomain(id: String) -> UserProfile {
        UserProfile(
            id: id,
            name: name ?? "",
            email: email ?? "",
            photoURL: photoURL.flatMap { URL(string: $0) },
            notificationsEnabled: notificationsEnabled ?? true
        )
    }
}
