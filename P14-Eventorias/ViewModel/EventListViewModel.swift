//
//  EventListViewModel.swift
//  P14-Eventorias
//
//  Created by Jaouad on 08/06/2026.
//
// MARK: - ViewModel de la Liste d'Événements
// Prépare l'état de la vue (ViewState) en orchestrant la récupération, le filtrage et le tri des événements via le répertoire de données.

import Foundation
import Observation

@MainActor
@Observable
final class EventListViewModel {
    /// Etats gérés  explicitement (exigence du cahier de charge : Chargement + erreur)
    enum ViewState: Equatable {
        case loading
        case loaded([Event])
        case empty
        case error
    }

    // MARK: - Propriétés Observables
    var searchText = ""
    var sort: EventSort = .dateAscending
    private(set) var state: ViewState = .loading
    
    private let repository: EventRepositoryProtocol
    
    init(repository: EventRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Logique Métier / Chargement
    /// Déclenche la récupération asynchrone des événements auprès du Repository.
    func load() async {
        state = .loading
        do {
            let events = try await repository.fetchEvents(searchText: searchText, sort: sort)
            state = events.isEmpty ? .empty : .loaded(events)
        } catch {
            state = .error
        }
    }
}
