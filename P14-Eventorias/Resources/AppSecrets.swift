//
//  AppSecrets.swift
//  P14-Eventorias
//
//  Created by Jaouad on 09/06/2026.
//

import Foundation

enum AppSecrets {

    // conforme au Cahier; le calé ne doit pas etre dans le code
    // Lue depuis info.plist (clé "GoogleMapsAPIKey"), alimentée par Secrets.xcconfig
    static var googleMapsAPIKey: String? {
        Bundle.main.object(forInfoDictionaryKey: "GoogleMapsAPIKey") as? String
    }
}
