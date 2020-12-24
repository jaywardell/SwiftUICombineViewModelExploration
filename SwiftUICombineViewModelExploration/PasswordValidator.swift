//
//  PasswordValidator.swift
//  SwiftUICombineViewModelExploration
//
//  Created by Joseph Wardell on 12/24/20.
//

import Foundation

public struct PasswordValidator: CredentialsValidator {
    
    public init() {}
    
    public func validate<C, V>(_ credentials: C) -> V where C : Credentials, V : CredentialsValidation {
        .init(passwordFeedback: "", isValid: false)
    }
}
