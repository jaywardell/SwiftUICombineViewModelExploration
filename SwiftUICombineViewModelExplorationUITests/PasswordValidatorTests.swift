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
    
    func test_validate_emptyPasswordIsInvalid() {
        let sut = PasswordValidator()
        let emptyPasswordCredentials = MockCredentials(username: "George", password: "", passwordAgain: "")

        expect(.emptyPassword, from: sut, for: emptyPasswordCredentials)
    }

    func test_validate_emptyNonMatchingPasswordfsAreInvalid() {
        let sut = PasswordValidator()
        let nonmatchingPasswords = MockCredentials(username: "George", password: "hi", passwordAgain: "bye")

        expect(.passwordsDoNotMatch, from: sut, for: nonmatchingPasswords)
    }

    // Mark:- Helpers
    
    func expect<C: Credentials>(_ expected: PasswordValidator.Validation, from sut: PasswordValidator, for input: C, file: StaticString = #filePath, line: UInt = #line) {
        let validation: PasswordValidator.Validation = sut.validate(input)

        XCTAssertEqual(validation, expected, "\nexpected: \(expected)\ngot: \(validation)", file: file, line: line)
    }
}
