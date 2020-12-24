//
//  Credentials.swift
//  SwiftUICombineViewModelExploration
//
//  Created by Joseph Wardell on 12/24/20.
//

import Foundation

protocol Credentials {
    var username: String { get }
    var password: String { get }
    var passwordAgain: String { get }
}

protocol CredentialsValidation {
    var passwordFeedback: String { get }
    var isValid: Bool { get }
}
