//
//  EventListView.swift
//  P14-Eventorias
//
//  Created by Jaouad on 08/06/2026.
//

import SwiftUI

/// Affichela liste des événements avec barres de recherche, filtres et tris.
struct EventListView: View {
    // MARK: - Propriétés d'État
    @State private var viewModel: EventListViewModel
    @State private var showCreate = false
    
    private let repository: EventRepositoryProtocol
    
    // MARK: - Initialiseur
    init(repository: EventRepositoryProtocol) {
        self.repository = repository
        _viewModel = State(initialValue: EventListViewModel(repository: repository))
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 12) {
                //Barre de Recherche
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.appTextSecondary)
                        .accessibilityHidden(true)
                    
                    TextField("Search", text: $viewModel.searchText)
                        .foregroundStyle(.white)
                        .accessibilityLabel("Rechercher un événement")
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.appCard, in: Capsule())
                
                // Menu de Tri
                HStack {
                    Menu {
                        Picker("Trier", selection: $viewModel.sort) {
                            ForEach(EventSort.allCases) { Text($0.label).tag($0) }
                        }
                    } label: {
                        Label("Sorting", systemImage: "arrow.up.arrow.down")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.appCard, in: Capsule())
                    }
                    .accessibilityLabel("Trier les événements")
                    .accessibilityValue("Tri actuel : \(viewModel.sort.label)")
                    
                    Spacer()
                }
                
                content
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        // Debounce Asynchrone
        // Se déclenche à chaque modification du texte de recherche. Annule automatiquement la tâche précédente.
        .task(id: viewModel.searchText) {
            do {
                // Attente de 300ms avant de lancer la requête réseau
                try await Task.sleep(for: .milliseconds(300))
                
                // Si l'utilisateur tape un autre caractère pendant l'attente, la tâche est annulée ici
                guard !Task.isCancelled else { return }
                
                await viewModel.load()
                
                // Générer une notification VoiceOver si la recherche modifie le nombre d'éléments
                if case .loaded(let events) = viewModel.state {
                    AccessibilityNotification.Announcement("\(events.count) événements trouvés").post()
                }
            } catch {
                // Gestion de l'annulation du Task.sleep
            }
        }
        // Déclenchement immédiat du rechargement lors du changement de tri
        .onChange(of: viewModel.sort) {
            Task { await viewModel.load() } }
        
        // Bouton Flottant (Création)
        .overlay(alignment: .bottomTrailing) {
            Button { showCreate = true } label: {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.appPrimary, in: RoundedRectangle(cornerRadius: 16))
            }
            .padding(20)
            .accessibilityLabel("Créer un événement")
            .accessibilityHint("Ouvre le formulaire pour ajouter un nouvel événement")
        }
        // Présentation de l'écran de création via une Sheet
        .sheet(isPresented: $showCreate) {
            NavigationStack {
                EventCreationView(repository: repository) {
                    showCreate = false
                    
                    Task { await viewModel.load() }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    // MARK: - Sous-Vues Aiguillage d'État
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            LoadingView()
                .frame(maxHeight: .infinity)
            
        case .error:
            // Une tentative de reconnexion en cas d'échec réseau
            ErrorStateView { Task { await viewModel.load() } }
            
        case .empty:
            ContentUnavailableView("Aucun événement", systemImage: "calendar")
                .frame(maxHeight: .infinity)
        case .loaded(let events):
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(events) { event in
                        NavigationLink(value: event) {
                            EventRowView(event: event)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 4)
            }
            .scrollIndicators(.hidden)
            .navigationDestination(for: Event.self) { event in
                EventDetailView(event: event)
            }
        }
    }
}

#Preview("Liste") { NavigationStack { EventListView(repository: MockEventRepository()) }.preferredColorScheme(.dark) }
#Preview("Erreur") { NavigationStack { EventListView(repository: MockEventRepository(shouldFail: true)) }.preferredColorScheme(.dark) }
#Preview("Vide")   { NavigationStack { EventListView(repository: MockEventRepository(events: [])) }.preferredColorScheme(.dark) }

