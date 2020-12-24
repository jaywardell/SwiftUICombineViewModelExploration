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
        let validation: MockValidation = sut.validate(emptyCredentials)
        
        XCTAssertEqual(validation.isValid, false)
    }
    
    func test_validate_emptyPasswordIsInvalid() {
        let sut = PasswordValidator()
        let emptyPasswordCredentials = MockCredentials(username: "", password: "", passwordAgain: "")
        let validation: MockValidation = sut.validate(emptyPasswordCredentials)

        XCTAssertEqual(validation.isValid, false)
    }

    func test_validate_emptyNonMatchingPasswordfsAreInvalid() {
        let sut = PasswordValidator()
        let nonmatchingPasswords = MockCredentials(username: "", password: "hi", passwordAgain: "bye")
        let validation: MockValidation = sut.validate(nonmatchingPasswords)

        XCTAssertEqual(validation.isValid, false)
    }

}
