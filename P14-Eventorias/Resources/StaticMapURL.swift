//
//  StaticMapURL.swift
//  P14-Eventorias
//
//  Created by Jaouad on 09/06/2026.
//

import Foundation

/// construction d'URL pour générer des aperçus cartographiques statiques via l'API Google Maps.
enum StaticMapURL {
    static func url(
        latitude:  Double,
        longitude: Double,
        width:     Int = 600,
        height:    Int = 300,
        key:       String? = AppSecrets.googleMapsAPIKey  // ← clé injectable pour les tests
    ) -> URL? {
        //Vérifie la présence et la validité de la clé API dans les secrets de l'application
        guard let key = key, !key.isEmpty else { return nil }

        let coord = "\(latitude), \(longitude)"

        var comps = URLComponents(string: "https://maps.googleapis.com/maps/api/staticmap")

        comps?.queryItems = [
            .init(name: "center",   value: coord),
            .init(name: "zoom",     value: "15"),
            .init(name: "size",     value: "\(width)x\(height)"),
            .init(name: "scale",    value: "2"),
            .init(name: "markers",  value: "color:red|\(coord)"),
            .init(name: "key",      value: key)
        ]
        return comps?.url
    }
}
