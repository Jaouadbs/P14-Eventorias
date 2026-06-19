//
//  PrimaryButtonStyle.swift
//  P14-Eventorias
//
//  Created by Jaouad on 05/06/2026.
//

import Foundation
import SwiftUI

///Bouton rouge pleine largeur de la maquette (Sign In, Validate, Try again).
struct PrimaryButtonStyle: ButtonStyle {
    var isLoading: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .opacity(isLoading ? 0 : 1)
            .frame(maxWidth: 358, minHeight: 52)
            .background(Color.appPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .opacity(configuration.isPressed ? 0.85 : 1)
            .overlay {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                        .controlSize(.regular)
                }
            }
        // Bloque les interactions utilisateur superflues si le traitement est en cours
            .allowsHitTesting(!isLoading)
    }
}
// MARK: - Previews
#Preview("Nominal") {
    Button("Sign In") {}
        .buttonStyle(PrimaryButtonStyle())
        .padding()
        .background(Color.appBackground)
}

#Preview("Chargement") {
    Button("Sign In") {}
        .buttonStyle(PrimaryButtonStyle(isLoading: true))
        .padding()
        .background(Color.appBackground)
}
