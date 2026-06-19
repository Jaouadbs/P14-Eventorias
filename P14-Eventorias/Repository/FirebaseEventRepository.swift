//
//  FirebaseEventRepository.swift
//  P14-Eventorias
//
//  Created by Jaouad on 08/06/2026.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import CoreLocation
import MapKit


/// Repo événements communiquant avec Cloud Firestore et Firebase Storage.
final class FirebaseEventRepository: EventRepositoryProtocol {

    // MARK: - Propriétés Privées

    /// Référence vers la collection "events" dans Firestore.
    private var collection: CollectionReference {
        Firestore.firestore().collection("events")
    }

    // MARK: - Méthodes de Lecture

    /// Récupère les événements depuis Firestore en appliquant un filtrage par préfixe ou un tri chronologique.
    func fetchEvents(searchText: String, sort: EventSort) async throws -> [Event] {
        let term = searchText.lowercased()
        let snapshot: QuerySnapshot

        if term.isEmpty {
            // Pas de recherche -> tri par date côté serveur
            snapshot = try await collection
                .order(by: "date", descending: sort == .dateDescending)
                .getDocuments()
        } else {
            // Recheche par préfixe coté serveur (champ "titleLowercased)
            snapshot = try await collection
                .whereField("titleLowercased", isGreaterThanOrEqualTo: term)
                .whereField("titleLowercased", isLessThan: term + "\u{f8ff}")
                .getDocuments()
        }

        // Décodage et conversion des DTOs Firestore vers le modèle Domaine
        let events = snapshot.documents.compactMap { doc in
            try? doc.data(as: FirestoreEvent.self).toDomain(id: doc.documentID)
        }
        // sur un résultat déja filtré coté serveur, le tri par date se fait en mémoire
        return events.sorted {
            sort == .dateAscending ? $0.date < $1.date : $0.date > $1.date
        }
    }

    // MARK: - Méthodes d'Écriture

    /// Crée et enregistre un nouvel événement, gère l'upload média et résout les coordonnées géographiques de l'adresse.
    func createEvent(_ draft: EventDraft, imageData: Data?) async throws {
        // Coordonnés via MapKit (le hors ligne n'est pas géré, cf; cahier)
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = draft.address
        // on cible uniquement des adresses physiques
        searchRequest.resultTypes = .address

        let search = MKLocalSearch(request: searchRequest)
        let response = try? await search.start()
        let coordinate = response?.mapItems.first?.location.coordinate

        // Upload de la photo sur Firebase Storage
        var imageURLString: String?
        if let data = imageData {
            // Chemin, unique de l'image
            let ref = Storage.storage().reference()
                .child("event_images/\(UUID().uuidString).jpg")

            // Déclaration de type de MIME
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            // Envoie des data avec la metadata
            _ = try await ref.putDataAsync(data, metadata: metadata)

            // Recup l'URL de téléchargement
            imageURLString = try await ref.downloadURL().absoluteString
        }

        // Organizer = Utilisateur courant
        let (organizerName, organizerPhotoURL) = await currentOrganizerInfo()

        // Ecritture FireStore(titleLowercased pour la recherche de préfixe
        let dto = FirestoreEvent(
            title:              draft.title,
            titleLowercased:    draft.title.lowercased(),
            description:        draft.description,
            date:               draft.date,
            address:            draft.address,
            imageURL:           imageURLString,
            organizerName:      organizerName,
            organizerPhotoURL:  organizerPhotoURL,
            latitude:           coordinate?.latitude,
            longitude:          coordinate?.longitude
        )
        let data = try Firestore.Encoder().encode(dto)
        try await collection.document().setData(data)
    }

    // MARK: - Utilitaires Privés

    /// Extrait les informations nominales et l'avatar de l'organisateur depuis Firestore (avec fallback Auth).
    private func currentOrganizerInfo() async -> (name: String?, photoURL: String?) {
        let user =  Auth.auth().currentUser
        guard let uid = user?.uid else { return (nil,nil) }

        let doc = try? await Firestore.firestore().collection("users").document(uid).getDocument()
        let name = (doc?.get("name") as? String) ?? user?.displayName
        let photo = (doc?.get("photoURL") as? String) ?? user?.photoURL?.absoluteString
        return(name,photo)
    }
}
// MARK: - Data Transfer Object (DTO)

/// Représentation  d'un événement au format Cloud Firestore.
private struct FirestoreEvent: Codable {
    var title               : String
    var titleLowercased     : String
    var description         : String
    var date                : Date             // Timestamp format date dans Firestore
    var address             : String
    var imageURL            : String?
    var organizerName       : String?
    var organizerPhotoURL   : String?
    var latitude            : Double?
    var longitude           : Double?

    /// Transforme le format brut Firestore en entité métier exploitable par l'UI.
    func toDomain(id: String) -> Event {
        Event(
            id:                 id,
            title:              title,
            description:        description,
            date:               date,
            address:            address,
            imageURL:           imageURL.flatMap{ URL(string: $0)},
            organizerName:      organizerName,
            organizerPhotoURL:  organizerPhotoURL.flatMap{ URL(string: $0)},
            latitude:           latitude,
            longitude:          longitude
        )
    }

}
