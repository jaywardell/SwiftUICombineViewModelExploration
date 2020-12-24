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
        case usernameIsTooShort
        case emptyPassword
        case passwordsIsTooShort
        case passwordsDoNotMatch
        
        public static let MinPasswordLength: Int = 5
        public static let MinUsernameLength: Int = 3

        var reason: String {
            switch self {
            case .valid: return ""
            case .emptyUsername: return "Username cannot be empty"
            case .usernameIsTooShort: return "Username must be at least \(Self.MinUsernameLength) characters long"
            case .emptyPassword: return "Password cannot be emoty"
            case .passwordsIsTooShort: return "Passwords must be at least \(Self.MinPasswordLength) characters long"
            case .passwordsDoNotMatch: return "Passwords do not match"
            }
        }
    }
    
    public func validate<C>(_ credentials: C) -> Validation where C : Credentials {
        if credentials.username.isEmpty {
            return .emptyUsername
        }
        else if credentials.username.count < Validation.MinUsernameLength {
            return .usernameIsTooShort
        }
        else if credentials.password.isEmpty {
            return .emptyPassword
        }
        else if credentials.password.count < Validation.MinPasswordLength {
            return .passwordsIsTooShort
        }
        else {
            return .passwordsDoNotMatch
        }
//        return .emptyUsername
    }
}
