//
//  ProfileView.swift
//  P14-Eventorias
//
//  Created by Jaouad on 10/06/2026.
//

import SwiftUI

/// Écran affichant les données du profil utilisateur connecté et ses préférences de compte.
struct ProfileView: View {
    // MARK: - Propriétés
    @Environment(SessionStore.self) private var session
    @State private var viewModel: ProfileViewModel
    
    // Dynamic Type : Taille adaptative pour la photo de profil
    @ScaledMetric private var avatarSize: CGFloat = 56
    
    // MARK: - Initialiseur
    init(uid: String, userRepository: UserRepositoryProtocol) {
        _viewModel = State(initialValue: ProfileViewModel(uid: uid, repository: userRepository))
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            switch viewModel.state {
            case .loading:
                LoadingView()
            case .error:
                ErrorStateView { Task { await viewModel.load() } }
            case .loaded(let profile):
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // En-tete: Titre + avatar alignés sur la meme ligne
                        HStack (alignment: .center) {
                            Text("User profile")
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                                .accessibilityAddTraits(.isHeader)
                            
                            Spacer()
                            
                            AsyncImage(url: profile.photoURL) { $0.resizable().scaledToFill() }
                            placeholder: { Circle().fill(Color.appCard) }
                                .frame(width: avatarSize, height: avatarSize)
                                .clipShape(Circle())
                        }
                        .padding(.top,8)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Profil utilisateur de \(profile.name)")
                        
                        // Informations utilisateur
                        labeledField("Name", value: profile.name)
                        labeledField("E-mail", value: profile.email)
                        
                        //Section Notifications
                        HStack {
                            Toggle("", isOn: $viewModel.notificationsEnabled)
                                .labelsHidden()
                                .tint(.appPrimary)
                                .onChange(of: viewModel.notificationsEnabled) { _, newValue in
                                    Task { await viewModel.setNotifications(newValue) }
                                }
                            // Le texte
                            Text("Notifications")
                                .foregroundStyle(.white)
                            
                            Spacer() // Repousse le tout vers la gauche
                        }
                        // Regroupe les éléments pour une lecture VoiceOver fluide et propre
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Notifications")
                        
                        Spacer(minLength: 100)
                        
                        // Bouton de déconexion
                        Button("Se déconnecter") {
                            session.signOut()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .frame(width: 159, height: 40)
                        .frame(maxWidth: .infinity)
                        .accessibilityHint("Ferme votre session actuelle et vous redirige vers l'écran de connexion")
                    }
                    .padding()
                }
            }
        }
        // Masquage de la barre de titre
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .task { await viewModel.load() }
    }
    
    // MARK: - Composants
    /// Génère un bloc d'information
    private func labeledField(_ label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.appTextSecondary)
            Text(value)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.appCard, in: RoundedRectangle(cornerRadius: 8))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack {
        ProfileView(uid: "u1", userRepository: MockUserRepository())
            .environment(SessionStore(authRepository: MockAuthRepository(loggedIn: .preview)))
    }
    .preferredColorScheme(.dark)
}
