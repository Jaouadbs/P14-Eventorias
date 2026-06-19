//
//  EventSort.swift
//  P14-Eventorias
//
//  Created by Jaouad on 08/06/2026.
//

import Foundation

/// Options de tri  disponibles pour l'affichage des événements.
enum EventSort: String, CaseIterable, Identifiable, Sendable {

    // MARK: - Cas possibles
    case dateAscending
    case dateDescending


    // MARK: - Propriétés calculées
    var id: String { rawValue }

    var label : String {
        switch self {
        case .dateAscending:
            return "Date croissante"
        case .dateDescending:
            return "Date décroissante"
        }
    }
}
