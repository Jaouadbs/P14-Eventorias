//
//  AppColor.swift
//  P14-Eventorias
//
//  Created by Jaouad on 05/06/2026.
//

import Foundation
import SwiftUI

@MainActor
extension Color {
    /// Design tokens issus de Figma
    static let appBackground        = Color(hex: 0x1D1B20)
    static let appPrimary           = Color(hex: 0xD0021B) // Rouge - actions
    static let appCard              = Color(hex: 0x49454F) // Gris foncé — cellules/champs
    static let appTextSecondary     = Color(hex: 0x9892A0) // Gris clair — textes secondaires
    static let appRowText           = Color(hex: 0xE6E0E9) // Texte des lignes d'événement
    static let appFieldLabel        = Color(hex: 0xCAC4D0) // Noms des champs (Title, Date…)
    static let appWhite             = Color(hex: 0xFFFFFF)
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red:    Double((hex >> 16) & 0xFF) / 255,
            green:  Double((hex >> 8)  & 0xFF) / 255,
            blue:   Double(hex         & 0xFF) / 255,
            opacity: alpha
        )
    }
}
