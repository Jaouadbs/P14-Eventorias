//
//  MockEventRepository.swift
//  P14-Eventorias
//
//  Created by Jaouad on 08/06/2026.
//

import Foundation

/// Mock d'événements pour les tests unitaires et les Previews
@MainActor
final class MockEventRepository: EventRepositoryProtocol {
    
    // MARK: - Propriétés Privées
    private let  events : [Event]
    private let shouldFail: Bool
    
    /// Déclencheur factice pour simuler un échec  lors de la création d'un événement.
    var shouldFailCreate = false
    
    /// Historique d'événements soumis à la méthode "createEvent".
    private(set) var createDrafts: [EventDraft] = []
    
    init(events: [Event] = MockEventRepository.sample, shouldFail: Bool = false) {
        self.events = events
        self.shouldFail = shouldFail
    }
    
    // MARK: - Méthodes de Protocole
    /// Récupère, filtre et trie les événements locaux pour simuler le comportement de Firestore.
    func fetchEvents(searchText: String, sort:EventSort) async throws -> [Event] {
        try await Task.sleep(for: .milliseconds(500))   // simule la latence
        
        if shouldFail {
            throw URLError(.notConnectedToInternet)
        }
        
        let filtered = searchText.isEmpty
        ? events
        : events.filter { $0.title.localizedCaseInsensitiveContains(searchText)}
        
        return filtered.sorted {
            sort == .dateAscending ? $0.date < $1.date : $0.date > $1.date
        }
    }
    
    /// Simule l'envoi et l'enregistrement d'un nouvel événement.
    func createEvent(_ draft: EventDraft, imageData: Data?) async throws {
        try await Task.sleep(for: .milliseconds(300))

        if shouldFailCreate {
            throw URLError(.cannotConnectToHost)
        }
        createDrafts.append(draft)
    }
    
    // MARK: - Données Factices de Test (Sample)
    
    /// Jeu de données d'événements pré-configurés pour remplir l'interface utilisateur.
    static let sample: [Event] = {
        func date (_ y: Int, _ m: Int, _ d: Int) -> Date {
            DateComponents(calendar: .current, year: y, month: m, day: d, hour: 10).date ?? .now
        }
        return [
            Event(id: "1", title: "Music festival" , description: "", date: date(2026,6,15), address: "", organizerName: "Marie Dupont"),
            Event(id: "2", title: "Art exhibition" , description: "", date: date(2026,6,20), address: "", organizerName: "Emily Johnson"),
            Event(id: "3", title: "Tech conference" , description: "", date: date(2026,8,5), address: "", organizerName: "Jean Dubois"),
            Event(id: "4", title: "Food fair" , description: "", date: date(2026,9,12), address: "", organizerName: "Michel Martin")
        ]
    }()
}
