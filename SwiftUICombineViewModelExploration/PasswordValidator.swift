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

        let validation: Validation = validate(credentials)
        return .init(passwordFeedback: validation.reason, isValid: validation == .valid)
    }
    
    public enum Validation: Equatable {
        case valid
        case emptyUsername
        case emptyPassword
        case passwordsDoNotMatch
        
        var reason: String {
            switch self {
            case .valid: return ""
            case .emptyUsername: return "Username cannot be empty"
            case .emptyPassword: return "Password cannot be emoty"
            case .passwordsDoNotMatch: return "Passwords do not match"
            }
        }
    }
    
    public func validate<C>(_ credentials: C) -> Validation where C : Credentials {
        if credentials.username.isEmpty {
            return .emptyUsername
        }
        else if credentials.password.isEmpty {
            return .emptyPassword
        }
        else {
            return .passwordsDoNotMatch
        }
//        return .emptyUsername
    }
}
