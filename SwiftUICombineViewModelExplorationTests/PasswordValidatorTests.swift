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

class PasswordValidatorTests: XCTestCase {

    func test_validate_emptyIsInvalid() {
       
        expect(PasswordValidator.EmptyUsername, for: MockCredentials(username: "", password: "", passwordAgain: ""))
    }
    
    func test_validate_shortUsernameIsInvalid() {

        expect(PasswordValidator.UserNameTooShort, for: makeCredentials(username: "G"))
        expect(PasswordValidator.UserNameTooShort, for: makeCredentials(username: "Ga"))
    }

    func test_validate_3CharacterUsernameIsVald() {

        expect(nil, for: makeCredentials(username: "Gil"))
    }

    func test_validate_4CharacterUsernameIsVald() {

        expect(nil, for: makeCredentials(username: "Gary"))
    }

    func test_validate_emptyPasswordIsInvalid() {

        let emptyPasswordCredentials = makeCredentials(matchingPassword: "")

        expect(PasswordValidator.EmptyPassword, for: emptyPasswordCredentials)
    }

    func test_validate_emptyPasswordVerificationIsInvalid() {

        let emptyPasswordVerification = MockCredentials(username: PasswordValidatorTests.knownAcceptableUsername, password: PasswordValidatorTests.knownAcceptablePassword, passwordAgain: "")

        expect(PasswordValidator.EmptyPasswordVerification, for: emptyPasswordVerification)
    }

    func test_validate_nonMatchingPasswordsAreInvalid() {

        let nonmatchingPasswords = MockCredentials(username: PasswordValidatorTests.knownAcceptableUsername, password: PasswordValidatorTests.knownAcceptablePassword, passwordAgain: "A2B3c1")

        expect(PasswordValidator.PasswordsDoNotMatch, for: nonmatchingPasswords)
    }

    func test_validate_shortPasswordsAreInvalid() {

        expect(PasswordValidator.PasswordTooShort, for: makeCredentials(matchingPassword: "1Aa"))
        expect(PasswordValidator.PasswordTooShort, for: makeCredentials(matchingPassword: "1Aa2"))
    }

    func test_validate_5CharacterPasswordsAreValid() {

        expect(nil, for: makeCredentials(matchingPassword: "1Aa2E"))
    }

    func test_validate_6CharacterPasswordsAreValid() {

        expect(nil, for: makeCredentials(matchingPassword: "1Aa2E3"))
    }

    func test_validate_passwordMustHaveAtLeastOneNumber() {
        let tooShortPassword = makeCredentials(matchingPassword: "aaaaaBBaaa")

        expect(PasswordRequirement.PasswordsLackANumber, for: tooShortPassword)
    }

    func test_validate_passwordMustHaveAtLeastOneLowercaseLetter() {
        let tooShortPassword = makeCredentials(matchingPassword: "123456789H")

        expect(PasswordRequirement.PasswordsLackALowercaseLetter, for: tooShortPassword)
    }

    func test_validate_passwordMustHaveAtLeastOneUppercaseLetter() {
        let tooShortPassword = makeCredentials(matchingPassword: "1a1a2f")

        expect(PasswordRequirement.PasswordsLackAnUppercaseLetter, for: tooShortPassword)
    }

    func test_validate_validPasswordsPass() {

        expect(nil, for: makeCredentials(matchingPassword: "1a1a2F"))
        expect(nil, for: makeCredentials(matchingPassword: "a1a2F"))
        expect(nil, for: makeCredentials(matchingPassword: "E1a1a2"))
        expect(nil, for: makeCredentials(matchingPassword: "99rTTe"))
    }

    // Mark:- Helpers
    
    func makeCredentials(username: String = knownAcceptableUsername, matchingPassword: String = PasswordValidatorTests.knownAcceptablePassword) -> MockCredentials {
        MockCredentials(username: username, password: matchingPassword, passwordAgain: matchingPassword)
    }
    
    static let knownAcceptablePassword = "1A2B3c"
    static let knownAcceptableUsername = "Jeanette"
    
    func makeSUT() -> PasswordValidator {
        return PasswordValidator.WithSomeRequirements
//        ([
//            PasswordRequirement.PasswordHasANumber,
//            PasswordRequirement.PasswordHasALowercaseLetter,
//            PasswordRequirement.PasswordHasAnUppercaseLetter
//        ])
    }
    
    func expect<C: Credentials>(_ expected: String?, for input: C, file: StaticString = #filePath, line: UInt = #line) {
        let sut = makeSUT()

        sut.validate(input) { error in
            XCTAssertEqual(error?.localizedDescription, expected, "\nexpected: \(String(describing: expected))\ngot: \(String(describing: error))", file: file, line: line)
        }
    }
}
