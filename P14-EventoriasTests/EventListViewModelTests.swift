//
//  EventListViewModelTests.swift
//  P14-EventoriasTests
//
//  Created by Jaouad on 17/06/2026.
//

import XCTest
@testable import P14_Eventorias

@MainActor
final class EventListViewModelTests: XCTestCase {

    func test_load_withEvents_setsStateToLoaded() async {
        // GIVEN — repository avec des événements (sample = 4)
        let sut = EventListViewModel(repository: MockEventRepository())

        // WHEN
        await sut.load()

        // THEN
        guard case .loaded(let events) = sut.state else {
            return XCTFail("État attendu .loaded, obtenu \(sut.state)")
        }
        XCTAssertEqual(events.count, 4)
    }

    func test_load_withEmptyList_setsStateToEmpty() async {
        // GIVEN — repository sans événement
        let sut = EventListViewModel(repository: MockEventRepository(events: []))

        // WHEN
        await sut.load()

        // THEN
        XCTAssertEqual(sut.state, .empty)
    }

    func test_load_whenRepositoryFails_setsStateToError() async {
        // GIVEN — repository en échec réseau
        let sut = EventListViewModel(repository: MockEventRepository(shouldFail: true))

        // WHEN
        await sut.load()

        // THEN
        XCTAssertEqual(sut.state, .error)
    }

    func test_load_withSearchText_filtersByTitle() async {
        // GIVEN — recherche "Art"
        let sut = EventListViewModel(repository: MockEventRepository())
        sut.searchText = "Art"

        // WHEN
        await sut.load()

        // THEN — tous les résultats contiennent "Art"
        guard case .loaded(let events) = sut.state else {
            return XCTFail("État attendu .loaded")
        }
        XCTAssertTrue(events.allSatisfy { $0.title.localizedCaseInsensitiveContains("Art") })
    }

    func test_load_sortDescending_returnsMostRecentFirst() async {
        // GIVEN — tri décroissant
        let sut = EventListViewModel(repository: MockEventRepository())
        sut.sort = .dateDescending

        // WHEN
        await sut.load()

        // THEN — le premier événement est le plus récent
        guard case .loaded(let events) = sut.state else {
            return XCTFail("État attendu .loaded")
        }
        let dates = events.map(\.date)
        XCTAssertEqual(dates, dates.sorted(by: >))
    }
}
