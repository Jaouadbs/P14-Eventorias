//
//  EventDraft.swift
//  P14-Eventorias
//
//  Created by Jaouad on 09/06/2026.
//

import Foundation

/// Modèle des données d'un événement en cours de création.
struct EventDraft: Equatable, Sendable {
    var title:          String
    var description:    String
    var date:           Date
    var address:        String
}
