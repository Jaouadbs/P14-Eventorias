//
//  Event.swift
//  P14-Eventorias
//
//  Created by Jaouad on 08/06/2026.
//

import Foundation

/// Modèle  représentant un événement complet
struct Event: Identifiable, Equatable,Hashable, Sendable {
    let id:                 String
    var title:              String
    var description:        String
    var date:               Date
    var address:            String
    var imageURL:           URL?              // Photo de l'évévement
    var organizerName:      String?
    var organizerPhotoURL:  URL?     // avatar affiché dans la liste
    var latitude:           Double?
    var longitude:          Double?
}

extension Event {
    static let preview = Event(
        id:              "preview-1",
        title:           "Art exhibition",
        description:     "Join us for an exclusive Art Exhibition…",
        date:            .now,
        address:         "123 Rue de l'Art, Paris, 75003, France",
        organizerName:   "Emily Johnson",
        latitude:        48.8566,
        longitude:       2.3522
    )
}
