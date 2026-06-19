//
//  EventCreationViewModel.swift
//  P14-Eventorias
//
//  Created by Jaouad on 10/06/2026.
//

import Foundation
import Observation

/// ViewModel gérant la logique  du formulaire de création d'un événement

@MainActor
@Observable
final class EventCreationViewModel {
    // MARK: - Propriétés observables
    var title = ""
    var description = ""
    var eventDate: Date?
    var eventTime: Date?
    var address = ""
    var imageData: Data?

    // MARK: - États de l'interface utilisateur
    var isSaving = false
    var errorMessage: String?

    // MARK: - Dépendances
    private let repository: EventRepositoryProtocol
    private let onCreated: () -> Void

    // MARK: - Initialiseur
        /// - Parameters:
        ///   - repository: L'implémentation du stockage/réseau conforme à `EventRepositoryProtocol`.
        ///   - onCreated: Callback exécuté en cas de succès pour notifier la vue parente et fermer l'écran.
    init(repository: EventRepositoryProtocol, onCreated: @escaping() -> Void) {
        self.repository = repository
        self.onCreated = onCreated
    }

    /// Règle de validation pour activer ou désactiver le bouton de soumission dans l'UI.
    var canSubmit: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !address.trimmingCharacters(in: .whitespaces).isEmpty &&
        eventDate != nil && eventTime != nil
    }

    // MARK: - Logique Métier / Actions
        /// Valide les données saisies, fusionne les dates et lance la création asynchrone de l'événement.
    func create() async {
        guard
            !title.trimmingCharacters(in: .whitespaces).isEmpty,
            !address.trimmingCharacters(in: .whitespaces).isEmpty,
            let day = eventDate, let time = eventTime
        else {
            errorMessage = "Le titre et l'adresse sont obligatoires."
            return
        }
        isSaving = true
        errorMessage = nil
        defer { isSaving = false }
        
        do{
            let draft = EventDraft(
                title: title,
                description: description,
                date: Self.combine(day: day, time: time),
                address: address
            )
            try await repository.createEvent(draft, imageData: imageData)
            onCreated()
        } catch {
            print(" Création échouée :", error)
            errorMessage = "La création a échoué. Vérifier l'adresse et réessayez."
        }
    }
    // MARK: - Outils Privés
        /// Combine les composants de jour d'une date et les composants d'heure d'une autre date.
        /// Fusionne le jour (eventDate) et l'heure (eventTime) en une seule Date.
    private static func combine(day: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let d = calendar.dateComponents([.year, .month, .day], from: day)
        let t = calendar.dateComponents([.hour, .minute], from: time)
        var c = DateComponents()
        c.year = d.year; c.month = d.month; c.day = d.day
        c.hour = t.hour; c.minute = t.minute
        return calendar.date(from: c) ?? day
    }
}
