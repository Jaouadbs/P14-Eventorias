//
//  SignInViewModelTests.swift
//  P14-EventoriasTests
//
//  Created by Jaouad on 17/06/2026.
//

import XCTest
@testable import P14_Eventorias

@MainActor
final class SignInViewModelTests: XCTestCase {

    func test_signIn_withEmptyFields_setsErrorAndDoesNotAuthenticate() async {
        // GIVEN — un ViewModel sans email ni mot de passe
        var authenticatedUser: AppUser?
        let sut = SignInViewModel(repository: MockAuthRepository()) { authenticatedUser = $0 }

        // WHEN — on tente de se connecter
        await sut.signIn()

        // THEN — message d'erreur affiché, callback non déclenché
        XCTAssertEqual(sut.errorMessage, AuthError.emptyFields.localizedDescription)
        XCTAssertNil(authenticatedUser)
        XCTAssertFalse(sut.isLoading)
    }

    func test_signIn_withValidCredentials_callsOnAuthenticated() async {
        // GIVEN — identifiants saisis et repository qui réussit
        var authenticatedUser: AppUser?
        let sut = SignInViewModel(
            repository: MockAuthRepository(result: .success(.preview))
        ) { authenticatedUser = $0 }
        sut.email = "test@mail.com"
        sut.password = "123456"

        // WHEN
        await sut.signIn()

        // THEN — utilisateur transmis, aucune erreur, chargement terminé
        XCTAssertEqual(authenticatedUser, .preview)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func test_signIn_whenRepositoryFails_setsErrorMessage() async {
        // GIVEN — repository qui échoue
        let sut = SignInViewModel(
            repository: MockAuthRepository(result: .failure(AuthError.invalidCredentials))
        ) { _ in }
        sut.email = "test@mail.com"
        sut.password = "wrong"

        // WHEN
        await sut.signIn()

        // THEN
        XCTAssertEqual(sut.errorMessage, AuthError.invalidCredentials.localizedDescription)
    }

    func test_canSubmit_reflectsFieldState() async {
        // GIVEN
        let sut = SignInViewModel(repository: MockAuthRepository()) { _ in }
        // THEN — vide au départ
        XCTAssertFalse(sut.canSubmit)
        // WHEN / THEN — email seul ne suffit pas
        sut.email = "a@b.com"
        XCTAssertFalse(sut.canSubmit)
        // WHEN / THEN — email + mot de passe
        sut.password = "secret"
        XCTAssertTrue(sut.canSubmit)
    }
}
