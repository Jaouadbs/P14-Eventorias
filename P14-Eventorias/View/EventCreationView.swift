//
//  EventCreationView.swift
//  P14-Eventorias
//
//  Created by Jaouad on 10/06/2026.
//

import SwiftUI
import PhotosUI

/// Vue principale gérant le formulaire de saisie, l'import de médias et la validation finale pour la création d'un nouvel événement.

struct EventCreationView: View {
    // MARK: - Propriétés
    @State private var viewModel: EventCreationViewModel
    @State private var photoItem: PhotosPickerItem?
    @State private var showCamera = false
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Injection de dépendances
    init(repository: EventRepositoryProtocol, onCreated: @escaping () -> Void) {
        _viewModel = State(initialValue: EventCreationViewModel(repository: repository, onCreated: onCreated))
    }
    
    // MARK: - Body Principal
    var body: some View {
        @Bindable var viewModel = viewModel
        
        // Utilisation de sous-composants pour alléger la charge du compilateur
        formScrollView
            .background(Color.appBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar { navigationToolbar }
        
            .safeAreaInset(edge: .bottom) {
                validationButtonSection
            }
            .onChange(of: photoItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        viewModel.imageData = data
                    }
                }
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraPicker { image in
                    viewModel.imageData = image.jpegData(compressionQuality: 0.8)
                }
                .ignoresSafeArea()
            }
    }
    
    // MARK: - Sous-Vues Privées (Allègement du Compilateur)
    
    /// Gère la zone de défilement contenant les champs d'information et les médias
    private var formScrollView: some View {
        ScrollView {
            VStack(spacing: 16) {
                field("Title") {
                    TextField("New event", text: $viewModel.title)
                        .foregroundStyle(Color.appRowText)
                }
                
                field("Description") {
                    TextField("Tap here to enter your description",
                              text: $viewModel.description, axis: .vertical)
                    .foregroundStyle(Color.appRowText)
                }
                
                // Date + Time combinés
                HStack(spacing: 12) {
                    DateTimePickerField(label: "Date", placeholder: "MM/DD/YYYY",
                                        date: $viewModel.eventDate, mode: .date)
                    DateTimePickerField(label: "Time", placeholder: "HH : MM",
                                        date: $viewModel.eventTime, mode: .time)
                }
                
                field("Address") {
                    TextField("Enter full address", text: $viewModel.address)
                        .foregroundStyle(Color.appRowText)
                }
                
                // Aperçu visuel du média
                if let data = viewModel.imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage).resizable().scaledToFill()
                        .frame(height: 160).frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .accessibilityLabel("Photo sélectionnée pour l'événement")
                }
                
                mediaButtonsSection
                
                errorSection
            }
            .padding()
        }
    }
    
    /// Groupe les boutons d'import photo et galerie
    private var mediaButtonsSection: some View {
        HStack(spacing: 16) {
            Button { showCamera = true } label: {
                Image(systemName: "camera.fill")
                    .font(.title2).foregroundStyle(.black)
                    .frame(width: 52, height: 52)
                    .background(.white, in: RoundedRectangle(cornerRadius: 16))
            }
            .accessibilityLabel("Prendre une photo")
            .accessibilityHint("Ouvre l'appareil photo pour illustrer votre événement")
            
            let primary = Color.appPrimary
            PhotosPicker(selection: $photoItem, matching: .images) {
                Image(systemName: "paperclip")
                    .font(.title2).foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .accessibilityLabel("Choisir une photo depuis la galerie")
            .accessibilityHint("Parcourt la bibliothèque multimédia de votre appareil")
        }
    }
    
    /// Zone d'affichage des messages d'erreur de validation
    @ViewBuilder
    private var errorSection: some View {
        if let error = viewModel.errorMessage {
            Text(error)
                .font(.footnote)
                .foregroundStyle(Color.appPrimary)
                .accessibilityLabel("Erreur : \(error)")
        }
    }
    
    /// Section fixée en bas pour la validation du formulaire
    private var validationButtonSection: some View {
        Button {
            Task { await viewModel.create() }
        } label: {
            Text("Validate")
                .frame(maxWidth: .infinity) // Prend toute la largeur disponible
        }
        .buttonStyle(PrimaryButtonStyle(isLoading: viewModel.isSaving))
        .disabled(viewModel.isSaving)
        .padding()
        // Un léger fond dégradé ou flouté optionnel pour masquer le contenu si tu le souhaites
        .background(Color.appBackground)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Enregistre le formulaire et publie l'événement")
    }
    
    /// Composants de la barre de navigation supérieure
    @ToolbarContentBuilder
    private var navigationToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left").fontWeight(.semibold)
            }
            .accessibilityLabel("Retour")
        }
        
        ToolbarItem(placement: .principal) {
            HStack {
                Text("Creation of an event")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .accessibilityAddTraits(.isHeader)
                    .lineLimit(1)
                Spacer()
            }
            .padding(.leading, -80)
        }
    }
    
    // MARK: - Générateur de conteneurs standardisés
    @ViewBuilder
    private func field<Content: View>(_ label: String,
                                      @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.caption).foregroundStyle(Color.appFieldLabel)
            content()
        }
        .padding()
        .background(Color.appCard, in: RoundedRectangle(cornerRadius: 8))
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        EventCreationView(
            repository: MockEventRepository(),
            onCreated: {
                print("L'événement a été créé avec succès !")
            }
        )
    }
}

