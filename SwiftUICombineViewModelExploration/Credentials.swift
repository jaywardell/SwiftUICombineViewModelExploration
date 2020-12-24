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
    
    init(passwordFeedback: String, isValid: Bool)
}

protocol CredentialsValidator {
    func validate<C: Credentials, V: CredentialsValidation>(_ credentials: C) -> V
}

fileprivate struct Always: CredentialsValidator {
    func validate<C, V>(_ credentials: C) -> V where C : Credentials, V : CredentialsValidation {
        V(passwordFeedback: "", isValid: true)
    }
}
