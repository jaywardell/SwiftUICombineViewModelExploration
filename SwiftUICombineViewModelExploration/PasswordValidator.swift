//
//  PasswordValidator.swift
//  SwiftUICombineViewModelExploration
//
//  Created by Joseph Wardell on 12/24/20.
//

import Foundation

public struct PasswordValidator {
    
    static let NonEmptyPassword = "Username cannot be empty"
    static func MinLengthUserName(ofLength length: Int) -> String { "Username must be at least \(length) characters long" }
        
    // if the user hasn't yet typed the password or password verification, don't report anything in the UI
    static let EmptyPassword = ""
    static let EmptyPasswordVerififcation = ""
        
    static func MinLengthPassword(ofLength length: Int) -> String { "Passwords must be at least \(length) characters long" }
    static let PasswordsDontMatch = "Passwords do not match"
    static let PasswordsLackANumber = "Passwords need at least one number"
    static let PasswordsLackALowercaseLetter = "Passwords need at least one lowercase letter"
    static let PasswordsLackAnUppercaseLetter = "Passwords need at least one uppercase letter"

    public init() {}
    
    struct ValidationError: Swift.Error, LocalizedError {
        let explanation: String
        init(_ explanation: String) {
            self.explanation = explanation
        }
        
        var localizedDescription: String {
            explanation
        }

        public var errorDescription: String? {
            explanation
        }
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

        public static let MinUsernameLength: Int = 3
        public static let MinPasswordLength: Int = 5

        var explanantion: String {
            switch self {
            case .valid: return ""
            case .emptyUsername: return "Username cannot be empty"
            case .usernameIsTooShort: return "Username must be at least \(Self.MinUsernameLength) characters long"
                
            // if the user hasn't yet typed the password or password verification, don't report anything in the UI
            case .emptyPassword: return ""
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
        guard !credentials.username.isEmpty else { return .emptyUsername }
        guard credentials.username.count >= Validation.MinUsernameLength else { return .usernameIsTooShort }
        guard !credentials.password.isEmpty else { return .emptyPassword }
        guard Self.HasNumberPredicate.evaluate(with: credentials.password) else { return .passwordNeedsANumber }
        guard Self.HasLowercaseLetterPredicate.evaluate(with: credentials.password) else { return .passwordNeedsALowercaseLetter }
        guard Self.HasUppercaseLetterPredicate.evaluate(with: credentials.password) else { return .passwordNeedsAnUppercaseLetter }
        guard credentials.password.count >= Validation.MinPasswordLength else { return .passwordsIsTooShort }
        guard !credentials.passwordAgain.isEmpty else { return .emptyPasswordVerification }
        guard credentials.password == credentials.passwordAgain else { return .passwordsDoNotMatch }
        
        return .valid
    }
}

struct PasswordRequirements: CredentialsValidator {
    
    func validate<C: Credentials>(_ credentials: C, completion: @escaping (Error?)->()) {
        completion(nil)
    }
}

// MARK:- PasswordValidator: CredentialsValidator
extension PasswordValidator: CredentialsValidator {
            
    func validate<C: Credentials>(_ credentials: C, completion: @escaping (Error?)->()) {
        let validation: Validation = validate(credentials)
        switch validation {
        case .valid:
            completion(nil)
        default:
            completion(ValidationError(validation.explanantion))
        }
    }
}
