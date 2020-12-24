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
        case emptyPasswordVerification
        case passwordsDoNotMatch
        case passwordNeedsANumber
        case passwordNeedsALowercaseLetter
        case passwordNeedsAnUppercaseLetter

        public static let MinPasswordLength: Int = 5
        public static let MinUsernameLength: Int = 3

        var reason: String {
            switch self {
            case .valid: return ""
            case .emptyUsername: return "Username cannot be empty"
            case .usernameIsTooShort: return "Username must be at least \(Self.MinUsernameLength) characters long"
            case .emptyPassword: return ""
                
            // if the user hasn't yet typed the password verification, don't report anything
            case .emptyPasswordVerification: return ""
                
            case .passwordsIsTooShort: return "Passwords must be at least \(Self.MinPasswordLength) characters long"
            case .passwordsDoNotMatch: return "Passwords do not match"
            case .passwordNeedsANumber: return "Passwords need at least one number"
            case .passwordNeedsALowercaseLetter: return "Passwords need at least one lowercase letter"
            case .passwordNeedsAnUppercaseLetter: return "Passwords need at least one uppercase letter"
            }
        }
    }
    
    static let HasNumberPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[0-9].*")
    static let HasLowercaseLetterPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[a-z].*")
    static let HasUppercaseLetterPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z].*")

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
        else if !Self.HasNumberPredicate.evaluate(with: credentials.password) {
            return .passwordNeedsANumber
        }
        else if !Self.HasLowercaseLetterPredicate.evaluate(with: credentials.password) {
            return .passwordNeedsALowercaseLetter
        }
        else if !Self.HasUppercaseLetterPredicate.evaluate(with: credentials.password) {
            return .passwordNeedsAnUppercaseLetter
        }
        else if credentials.password.count < Validation.MinPasswordLength {
            return .passwordsIsTooShort
        }
        else if credentials.passwordAgain.isEmpty {
            return .emptyPasswordVerification
        }
        else if credentials.password != credentials.passwordAgain {
            return .passwordsDoNotMatch
        }
        else {
            return .valid
        }
    }
}
