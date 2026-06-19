//
//  SessionStoreTests.swift
//  P14-EventoriasTests
//
//  Created by Jaouad on 17/06/2026.
//

import XCTest
@testable import P14_Eventorias

@MainActor
final class SessionStoreTests: XCTestCase {

    func test_init_withLoggedInUser_isAuthenticated() async {
        // GIVEN — un utilisateur déjà connecté au lancement
        let sut = SessionStore(authRepository: MockAuthRepository(loggedIn: .preview))

        // THEN
        XCTAssertTrue(sut.isAuthenticated)
        XCTAssertEqual(sut.currentUser, .preview)
    }

    func test_init_withNoUser_isNotAuthenticated() async {
        // GIVEN — aucune session persistée
        let sut = SessionStore(authRepository: MockAuthRepository())

        // THEN
        XCTAssertFalse(sut.isAuthenticated)
        XCTAssertNil(sut.currentUser)
    }

    func test_setUser_updatesCurrentUser() async {
        // GIVEN — pas de session
        let sut = SessionStore(authRepository: MockAuthRepository())

        // WHEN
        sut.setUser(.preview)

        // THEN
        XCTAssertEqual(sut.currentUser, .preview)
        XCTAssertTrue(sut.isAuthenticated)
    }

    func test_signOut_clearsCurrentUser() async {
        // GIVEN — session active
        let sut = SessionStore(authRepository: MockAuthRepository(loggedIn: .preview))

        // WHEN
        sut.signOut()

        // THEN
        XCTAssertNil(sut.currentUser)
        XCTAssertFalse(sut.isAuthenticated)
    }
}
