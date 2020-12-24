//
//  PasswordValidatorTests.swift
//  SwiftUICombineViewModelExplorationUITests
//
//  Created by Joseph Wardell on 12/24/20.
//

import XCTest

import SwiftUICombineViewModelExploration

struct MockCredentials: Credentials {
    let username: String
    let password: String
    let passwordAgain: String
}

struct MockValidation: CredentialsValidation {
    let passwordFeedback: String
    let isValid: Bool
}

class PasswordValidatorTests: XCTestCase {

    func test_validate_emptyIsInvalid() {
        let sut = PasswordValidator()
        let emptyCredentials = MockCredentials(username: "", password: "", passwordAgain: "")
       
        expect(.emptyUsername, from: sut, for: emptyCredentials)
    }
    
    func test_validate_shortUsernameIsInvalid() {
        let sut = PasswordValidator()

        expect(.usernameIsTooShort, from: sut, for: makeCredentials(username: "G"))
        expect(.usernameIsTooShort, from: sut, for: makeCredentials(username: "Ga"))
    }

    func test_validate_3CharacterUsernameIsVald() {
        let sut = PasswordValidator()
        expect(.valid, from: sut, for: makeCredentials(username: "Gil"))
    }

    func test_validate_4CharacterUsernameIsVald() {
        let sut = PasswordValidator()
        expect(.valid, from: sut, for: makeCredentials(username: "Gary"))
    }

    func test_validate_emptyPasswordIsInvalid() {
        let sut = PasswordValidator()
        let emptyPasswordCredentials = makeCredentials(matchingPassword: "")

        expect(.emptyPassword, from: sut, for: emptyPasswordCredentials)
    }

    func test_validate_emptyPasswordVerificationIsInvalid() {
        let sut = PasswordValidator()
        let nonmatchingPasswords = MockCredentials(username: PasswordValidatorTests.knownAcceptableUsername, password: PasswordValidatorTests.knownAcceptablePassword, passwordAgain: "")

        expect(.emptyPasswordVerification, from: sut, for: nonmatchingPasswords)
    }

    
    func test_validate_nonMatchingPasswordsAreInvalid() {
        let sut = PasswordValidator()
        let nonmatchingPasswords = MockCredentials(username: PasswordValidatorTests.knownAcceptableUsername, password: PasswordValidatorTests.knownAcceptablePassword, passwordAgain: "A2B3c1")

        expect(.passwordsDoNotMatch, from: sut, for: nonmatchingPasswords)
    }

    func test_validate_shortPasswordsAreInvalid() {
        let sut = PasswordValidator()

        expect(.passwordsIsTooShort, from: sut, for: makeCredentials(matchingPassword: "1Aa"))
        expect(.passwordsIsTooShort, from: sut, for: makeCredentials(matchingPassword: "1Aa2"))
    }
    
    func test_validate_passwordMustHaveAtLeastOneNumber() {
        let sut = PasswordValidator()
        let tooShortPassword = makeCredentials(matchingPassword: "aaaaaBBaaa")

        expect(.passwordNeedsANumber, from: sut, for: tooShortPassword)
    }
    
    func test_validate_passwordMustHaveAtLeastOneLowercaseLetter() {
        let sut = PasswordValidator()
        let tooShortPassword = makeCredentials(matchingPassword: "123456789H")

        expect(.passwordNeedsALowercaseLetter, from: sut, for: tooShortPassword)
    }

    func test_validate_passwordMustHaveAtLeastOneUppercaseLetter() {
        let sut = PasswordValidator()
        let tooShortPassword = makeCredentials(matchingPassword: "1a1a2f")

        expect(.passwordNeedsAnUppercaseLetter, from: sut, for: tooShortPassword)
    }

    func test_validate_validPasswordsPass() {
        let sut = PasswordValidator()

        expect(.valid, from: sut, for: makeCredentials(matchingPassword: "1a1a2F"))
        expect(.valid, from: sut, for: makeCredentials(matchingPassword: "a1a2F"))
        expect(.valid, from: sut, for: makeCredentials(matchingPassword: "E1a1a2"))
        expect(.valid, from: sut, for: makeCredentials(matchingPassword: "99rTTe"))
    }

    // Mark:- Helpers
    
    func makeCredentials(username: String = knownAcceptableUsername, matchingPassword: String = PasswordValidatorTests.knownAcceptablePassword) -> MockCredentials {
        MockCredentials(username: username, password: matchingPassword, passwordAgain: matchingPassword)
    }
    
    static let knownAcceptablePassword = "1A2B3c"
    static let knownAcceptableUsername = "Jeanette"

    func expect<C: Credentials>(_ expected: PasswordValidator.Validation, from sut: PasswordValidator, for input: C, file: StaticString = #filePath, line: UInt = #line) {
        let validation: PasswordValidator.Validation = sut.validate(input)

        XCTAssertEqual(validation, expected, "\nexpected: \(expected)\ngot: \(validation)", file: file, line: line)
    }
}
