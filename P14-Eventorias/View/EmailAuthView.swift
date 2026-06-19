//
//  EmailAuthView.swift
//  P14-Eventorias
//
//  Created by Jaouad on 05/06/2026.
//

import SwiftUI

/// Vue gérant le formulaire de saisie des identifiants pour la connexion par e-mail.
struct EmailAuthView: View {
    
    var viewModel: SignInViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        // Rend le ViewModel compatible avec les liaisons bidirectionnelles ($)
        @Bindable var viewModel = viewModel
        
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Titre de l'écran
                Text("Connexion")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .accessibilityAddTraits(.isHeader)
                
                // Champ Saisie Email
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .fieldStyle()
                    .accessibilityLabel("Adresse e-mail")
                
                // Champ Saisie Mot de passe
                SecureField("Mot de passe", text: $viewModel.password)
                    .textContentType(.password)
                    .fieldStyle()
                    .accessibilityLabel("Mot de passe")
                
                // Zone d'affichage des erreurs réseau ou de saisie
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(Color.appPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityLabel("Erreur de connexion : \(error)")
                }
                // Bouton de connexion
                Button("Sign in with email") {
                    Task { await viewModel.signIn()}
                }
                .buttonStyle(PrimaryButtonStyle(isLoading: viewModel.isLoading))
                .disabled(viewModel.isLoading)
                .accessibilityAddTraits(.isButton)
                .accessibilityHint("Validez vos identifiants pour vous connecter à votre compte")
                
                Spacer()
            }
            .padding(24)
        }
    }
}

// MARK: - Extensions de Style Privées (Allègement du Body)
private extension View {
    /// Applique un design standardisé aux champs de saisie du formulaire d'authentification.
    func fieldStyle() -> some View {
        self
            .foregroundStyle(.white)
            .padding()
            .background(Color.appCard, in: RoundedRectangle(cornerRadius: 8))
    }
}

#Preview ("Succès") {
    EmailAuthView(viewModel: .init(repository: MockAuthRepository(), onAuthenticated:{ _ in}))
}

#Preview ("Erreur") {
    EmailAuthView(viewModel: .init(
        repository: MockAuthRepository(result: .failure(AuthError.invalidCredentials)), onAuthenticated:{ _ in}
    ))
}
