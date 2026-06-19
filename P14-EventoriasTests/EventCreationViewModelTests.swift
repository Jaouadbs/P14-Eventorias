//
//  EventCreationViewModelTests.swift
//  P14-EventoriasTests
//
//  Created by Jaouad on 17/06/2026.
//

import XCTest
@testable import P14_Eventorias

// NOTE: On ajoute `async` même pour les tests synchrones pour forcer le thread
    // à se synchroniser correctement et éviter le crash de double libération (Bug Intel/MainActor).
@MainActor
final class EventCreationViewModelTests: XCTestCase {

    func test_canSubmit_requiresTitleAddressDateAndTime() async {
        // GIVEN
        let sut = EventCreationViewModel(repository: MockEventRepository()) {}
        XCTAssertFalse(sut.canSubmit)

        // WHEN / THEN — titre + adresse ne suffisent pas
        sut.title = "Concert"
        sut.address = "1 rue de la Paix"
        XCTAssertFalse(sut.canSubmit)

        // WHEN / THEN — date + heure complètent la validation
        sut.eventDate = Date()
        sut.eventTime = Date()
        XCTAssertTrue(sut.canSubmit)
    }

    func test_create_withValidData_forwardsDraftAndCallsOnCreated() async {
        // GIVEN — formulaire complet
        let repository = MockEventRepository()
        var didCreate = false
        let sut = EventCreationViewModel(repository: repository) { didCreate = true }
        sut.title = "Concert"
        sut.address = "1 rue de la Paix"
        sut.eventDate = Date()
        sut.eventTime = Date()

        // WHEN
        await sut.create()

        // THEN
        XCTAssertTrue(didCreate)
        XCTAssertEqual(repository.createDrafts.count, 1)
        XCTAssertEqual(repository.createDrafts.first?.title, "Concert")
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isSaving)
    }

    func test_create_withMissingFields_setsErrorAndSkipsRepository() async {
        // GIVEN — adresse, date et heure manquantes
        let repository = MockEventRepository()
        let sut = EventCreationViewModel(repository: repository) {}
        sut.title = "Concert"

        // WHEN
        await sut.create()

        // THEN — aucune écriture, message d'erreur
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(repository.createDrafts.isEmpty)
    }

    func test_create_whenRepositoryFails_setsErrorMessage() async {
        // GIVEN — repository qui échoue à la création
        let repository = MockEventRepository()
        repository.shouldFailCreate = true
        let sut = EventCreationViewModel(repository: repository) {}
        sut.title = "Concert"
        sut.address = "1 rue de la Paix"
        sut.eventDate = Date()
        sut.eventTime = Date()

        // WHEN
        await sut.create()

        // THEN
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isSaving)
    }
}
