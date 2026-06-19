//
//  SignInView.swift
//  P14-Eventorias
//
//  Created by Jaouad on 05/06/2026.
//  maquette "Sign In"

import SwiftUI

/// Écran d'accueil d'authentification (Portail d'entrée de l'application).
struct SignInView: View {
    // MARK: - Dépendances & Actions
    let authRepository: AuthRepositoryProtocol
    let onAuthenticated: (AppUser) -> Void
    
    @State private var showEmailForm = false
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Logo de l'application
                Image("Logo")
                    .font(.system(size: 64))
                    .foregroundStyle(.white)
                    .accessibilityHidden(true)
                
                // Titre principal de la marque
                Text("EVENTORIAS")
                    .font(.system(.largeTitle, design: .serif).weight(.bold))
                    .foregroundStyle(.white)
                    .tracking(2)
                    .accessibilityAddTraits(.isHeader)
                
                // Bouton d'accès à la connexion E-mail
                Button {
                    showEmailForm = true
                } label: {
                    Label("Sign in with email", systemImage: "envelope.fill")
                }
                .buttonStyle(PrimaryButtonStyle())
                .frame(width: 242, height: 52)
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .accessibilityIdentifier("signInWithEmailButton")

                Spacer()
                Spacer()
            }
        }
        // Présentation du formulaire d'authentification e-mail
        .sheet(isPresented: $showEmailForm) {
            EmailAuthView(
                viewModel: SignInViewModel(
                    repository: authRepository,
                    onAuthenticated: onAuthenticated
                )
            )
        }
    }
}

#Preview {
    SignInView(authRepository: MockAuthRepository(), onAuthenticated: { _ in})
}
