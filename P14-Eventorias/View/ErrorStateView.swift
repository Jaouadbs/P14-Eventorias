//
//  ErrorStateView.swift
//  P14-Eventorias
//
//  Created by Jaouad on 05/06/2026.
//  maquette "Error" + retry

import SwiftUI

// Vue d'état  pour afficher les erreurs de l'application
struct ErrorStateView: View {
    // MARK: - Propriétés
    var title: String = "Error"
    var message: String = "An error has occured,\nplease try again later"
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Icône d'alerte
            Image(systemName: "exclamationmark")
                .font(.title.bold())
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Color.appCard, in: Circle())
                .accessibilityHidden(true)
            
            //Groupe Titre + message d'erreur
            VStack(spacing: 16) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                
            }
            .accessibilityElement(children: .combine)
            
            //Zone button réessayer
            Button(action: retryAction) {
                Text("Try again")
                    .frame(width: 159, height: 40)
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.top, 8)
            .accessibilityLabel("Réessayer")
            .accessibilityHint("Relance la tentative de chargement des données")
            .accessibilityAddTraits(.isButton)
            
            .fixedSize(horizontal: true, vertical: false)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ErrorStateView(retryAction: {})
        .background(Color.appBackground)
}
