//
//  StaticMapURLTests.swift
//  P14-EventoriasTests
//
//  Created by Jaouad on 17/06/2026.
//

import XCTest
@testable import P14_Eventorias

final class StaticMapURLTests: XCTestCase {

    func test_url_withKey_containsExpectedParameters() throws {
        // GIVEN — coordonnées + fausse clé
        let url = try XCTUnwrap(
            StaticMapURL.url(latitude: 48.8566, longitude: 2.3522, key: "FAKE_KEY")
        )
        // THEN — l'URL contient les bons paramètres
        let s = url.absoluteString
        XCTAssertTrue(s.contains("staticmap"))
        XCTAssertTrue(s.contains("48.8566"))
        XCTAssertTrue(s.contains("2.3522"))
        XCTAssertTrue(s.contains("zoom=15"))
        XCTAssertTrue(s.contains("key=FAKE_KEY"))
    }

    func test_url_withoutKey_returnsNil() {
        // GIVEN — aucune clé
        // THEN — pas d'URL
        XCTAssertNil(StaticMapURL.url(latitude: 0, longitude: 0, key: nil))
    }
}
