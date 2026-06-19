//
//  LoadingView.swift
//  P14-Eventorias
//
//  Created by Jaouad on 05/06/2026.
//  maquette "Loading"

import SwiftUI

/// Vue  d'attente affichant un indicateur de chargement.
struct LoadingView: View {
    var body: some View {
        ProgressView()
            .controlSize(.large)
            .tint(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .accessibilityLabel("Chargement en cours")
        
    }
}

#Preview {
    LoadingView().background(Color.appBackground)
}
