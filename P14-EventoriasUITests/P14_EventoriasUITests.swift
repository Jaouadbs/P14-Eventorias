//
//  P14_EventoriasUITests.swift
//  P14-EventoriasUITests
//
//  Created by Jaouad on 04/06/2026.
//

import XCTest

final class P14_EventoriasUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITest"]   // force le mode mocké (déconnecté, hors-ligne)
        app.launch()
    }

    func test_launch_showsSignInScreen() {
        // GIVEN / WHEN — l'app démarre en mode test (donc déconnectée)
        let signInButton = app.buttons["signInWithEmailButton"]
        // THEN — le bouton de connexion par e-mail est visible
        XCTAssertTrue(signInButton.waitForExistence(timeout: 5))
    }

    func test_tapSignIn_presentsEmailForm() {
        // GIVEN — écran d'accueil
        let signInButton = app.buttons["signInWithEmailButton"]
        XCTAssertTrue(signInButton.waitForExistence(timeout: 5))

        // WHEN — on ouvre le formulaire e-mail
        signInButton.tap()

        // THEN — le formulaire de connexion s'affiche
        XCTAssertTrue(app.staticTexts["Connexion"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.textFields["Adresse e-mail"].waitForExistence(timeout: 3))
    }
}
