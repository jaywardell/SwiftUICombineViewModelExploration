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

//struct MockValidation: CredentialsValidation {
//    let passwordFeedback: String
//    let isValid: Bool
//}

class PasswordValidatorTests: XCTestCase {

    func test_validate_emptyIsInvalid() {
       
        expect(.emptyUsername, for: MockCredentials(username: "", password: "", passwordAgain: ""))
    }
    
    func test_validate_shortUsernameIsInvalid() {

        expect(.usernameIsTooShort, for: makeCredentials(username: "G"))
        expect(.usernameIsTooShort, for: makeCredentials(username: "Ga"))
    }

    func test_validate_3CharacterUsernameIsVald() {

        expect(.valid, for: makeCredentials(username: "Gil"))
    }

    func test_validate_4CharacterUsernameIsVald() {

        expect(.valid, for: makeCredentials(username: "Gary"))
    }

    func test_validate_emptyPasswordIsInvalid() {

        let emptyPasswordCredentials = makeCredentials(matchingPassword: "")

        expect(.emptyPassword, for: emptyPasswordCredentials)
    }

    func test_validate_emptyPasswordVerificationIsInvalid() {

        let emptyPasswordVerification = MockCredentials(username: PasswordValidatorTests.knownAcceptableUsername, password: PasswordValidatorTests.knownAcceptablePassword, passwordAgain: "")

        expect(.emptyPasswordVerification, for: emptyPasswordVerification)
    }

    
    func test_validate_nonMatchingPasswordsAreInvalid() {

        let nonmatchingPasswords = MockCredentials(username: PasswordValidatorTests.knownAcceptableUsername, password: PasswordValidatorTests.knownAcceptablePassword, passwordAgain: "A2B3c1")

        expect(.passwordsDoNotMatch, for: nonmatchingPasswords)
    }

    func test_validate_shortPasswordsAreInvalid() {

        expect(.passwordsIsTooShort, for: makeCredentials(matchingPassword: "1Aa"))
        expect(.passwordsIsTooShort, for: makeCredentials(matchingPassword: "1Aa2"))
    }
    
    func test_validate_5CharacterPasswordsAreValid() {

        expect(.valid, for: makeCredentials(matchingPassword: "1Aa2E"))
    }

    func test_validate_6CharacterPasswordsAreValid() {

        expect(.valid, for: makeCredentials(matchingPassword: "1Aa2E3"))
    }

    func test_validate_passwordMustHaveAtLeastOneNumber() {
        let tooShortPassword = makeCredentials(matchingPassword: "aaaaaBBaaa")

        expect(.passwordNeedsANumber, for: tooShortPassword)
    }
    
    func test_validate_passwordMustHaveAtLeastOneLowercaseLetter() {
        let tooShortPassword = makeCredentials(matchingPassword: "123456789H")

        expect(.passwordNeedsALowercaseLetter, for: tooShortPassword)
    }

    func test_validate_passwordMustHaveAtLeastOneUppercaseLetter() {
        let tooShortPassword = makeCredentials(matchingPassword: "1a1a2f")

        expect(.passwordNeedsAnUppercaseLetter, for: tooShortPassword)
    }

    func test_validate_validPasswordsPass() {

        expect(.valid, for: makeCredentials(matchingPassword: "1a1a2F"))
        expect(.valid, for: makeCredentials(matchingPassword: "a1a2F"))
        expect(.valid, for: makeCredentials(matchingPassword: "E1a1a2"))
        expect(.valid, for: makeCredentials(matchingPassword: "99rTTe"))
    }

    // Mark:- Helpers
    
    func makeCredentials(username: String = knownAcceptableUsername, matchingPassword: String = PasswordValidatorTests.knownAcceptablePassword) -> MockCredentials {
        MockCredentials(username: username, password: matchingPassword, passwordAgain: matchingPassword)
    }
    
    static let knownAcceptablePassword = "1A2B3c"
    static let knownAcceptableUsername = "Jeanette"

    func expect<C: Credentials>(_ expected: PasswordValidator.Validation, for input: C, file: StaticString = #filePath, line: UInt = #line) {
        let sut = PasswordValidator()
        let validation: PasswordValidator.Validation = sut.validate(input)

        XCTAssertEqual(validation, expected, "\nexpected: \(expected)\ngot: \(validation)", file: file, line: line)
    }
}
