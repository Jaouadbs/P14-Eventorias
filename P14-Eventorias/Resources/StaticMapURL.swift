//
//  StaticMapUR.swift
//  P14-Eventorias
//
//  Created by Jaouad on 09/06/2026.
//

import Foundation

// Construction d'URL d'une carte statique Google maps
enum StaticMapUR {
    static func url(latitude: Double, longitude: Double,
                    width: Int = 600, height: Int = 300) -> URL? {
        guard let key = AppSecrets.googleMapsAPIKey, !key.isEmpty else { return nil }
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
