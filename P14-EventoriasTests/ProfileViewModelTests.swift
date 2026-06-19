//
//  ProfileViewModelTests.swift
//  P14-EventoriasTests
//
//  Created by Jaouad on 17/06/2026.
//

import XCTest
@testable import P14_Eventorias

@MainActor
final class ProfileViewModelTests: XCTestCase {

    func test_load_succeeds_setsStateToLoadedWithNotifications() async {
        // GIVEN
        let sut = ProfileViewModel(uid: "u1", repository: MockUserRepository())

        // WHEN
        await sut.load()

        // THEN — ViewState non Equatable → pattern matching
        guard case .loaded(let profile) = sut.state else {
            return XCTFail("État attendu .loaded")
        }
        XCTAssertFalse(profile.email.isEmpty)
        XCTAssertTrue(sut.notificationsEnabled)
    }

    func test_load_fails_setsStateToError() async {
        // GIVEN — repository en échec
        let sut = ProfileViewModel(uid: "u1", repository: MockUserRepository(shouldFail: true))

        // WHEN
        await sut.load()

        // THEN
        guard case .error = sut.state else {
            return XCTFail("État attendu .error")
        }
    }

    func test_setNotifications_updatesLocalState() async {
        // GIVEN
        let sut = ProfileViewModel(uid: "u1", repository: MockUserRepository())

        // WHEN
        await sut.setNotifications(false)

        // THEN
        XCTAssertFalse(sut.notificationsEnabled)
    }

    func test_setNotifications_keepsLocalStateEvenIfServerFails() async {
        // GIVEN — la synchro serveur échoue, mais l'UI locale doit rester réactive (try?)
        let sut = ProfileViewModel(uid: "u1", repository: MockUserRepository(shouldFail: true))

        // WHEN
        await sut.setNotifications(true)

        // THEN — l'état local est mis à jour malgré l'échec réseau
        XCTAssertTrue(sut.notificationsEnabled)
    }
}
