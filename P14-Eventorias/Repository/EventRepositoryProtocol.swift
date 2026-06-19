//
//  EventRepositoryProtocol.swift
//  P14-Eventorias
//
//  Created by Jaouad on 08/06/2026.
//

import Foundation

/// Protocole de manipulation des données d'événements.
protocol EventRepositoryProtocol: Sendable {

    /// Récupère la liste des événements correspondants aux critères de recherche et de tri.
    ///  Note: Conformément au cahier des charges, la recherche par mots-clés est exécutée
    /// directement côté serveur afin d'alléger la consommation de bande passante et de mémoire du client.
    func fetchEvents(searchText: String, sort: EventSort) async throws -> [Event]

    /// Crée et persiste un nouvel événement dans la base de données.
    func createEvent(_ draft: EventDraft, imageData: Data?) async throws

}
