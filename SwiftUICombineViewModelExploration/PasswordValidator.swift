//
//  PasswordValidator.swift
//  SwiftUICombineViewModelExploration
//
//  Created by Joseph Wardell on 12/24/20.
//

import Foundation

public struct PasswordValidator {
    
    public static let EmptyUsername = "Username cannot be empty"
    public static func MinLengthUserName(ofLength length: Int) -> String { "Username must be at least \(length) characters long" }
    public static let UserNameTooShort = MinLengthUserName(ofLength: Validation.MinUsernameLength)
    
    // if the user hasn't yet typed the password or password verification, don't report anything in the UI
    public static let EmptyPassword = ""
    public static let EmptyPasswordVerification = ""
        
    public static func MinLengthPassword(ofLength length: Int) -> String { "Passwords must be at least \(length) characters long" }
    public static let PasswordTooShort = MinLengthPassword(ofLength: Validation.MinPasswordLength)

    public static let PasswordsDoNotMatch = "Passwords do not match"
    public static let PasswordsLackANumber = "Passwords need at least one number"
    public static let PasswordsLackALowercaseLetter = "Passwords need at least one lowercase letter"
    public static let PasswordsLackAnUppercaseLetter = "Passwords need at least one uppercase letter"

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

//    public enum Validation: Equatable {
//        case valid
//        case emptyUsername
//        case usernameIsTooShort
//        case emptyPassword
//        case passwordsIsTooShort
//        case emptyPasswordVerification
//        case passwordsDoNotMatch
//        case passwordNeedsANumber
//        case passwordNeedsALowercaseLetter
//        case passwordNeedsAnUppercaseLetter
//
//        public static let MinUsernameLength: Int = 3
//        public static let MinPasswordLength: Int = 5
//
//        var explanantion: String {
//            switch self {
//            case .valid: return ""
//            case .emptyUsername: return "Username cannot be empty"
//            case .usernameIsTooShort: return "Username must be at least \(Self.MinUsernameLength) characters long"
//                
//            // if the user hasn't yet typed the password or password verification, don't report anything in the UI
//            case .emptyPassword: return ""
//            case .emptyPasswordVerification: return ""
//                
//            case .passwordsIsTooShort: return "Passwords must be at least \(Self.MinPasswordLength) characters long"
//            case .passwordsDoNotMatch: return "Passwords do not match"
//            case .passwordNeedsANumber: return "Passwords need at least one number"
//            case .passwordNeedsALowercaseLetter: return "Passwords need at least one lowercase letter"
//            case .passwordNeedsAnUppercaseLetter: return "Passwords need at least one uppercase letter"
//            }
//        }
//    }
    
    static let HasNumberPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[0-9].*")
    static let HasLowercaseLetterPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[a-z].*")
    static let HasUppercaseLetterPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z].*")

    private func val<C>(_ credentials: C) -> Error? where C : Credentials {
        guard !credentials.username.isEmpty else { return ValidationError(Self.EmptyUsername) }
        guard credentials.username.count >= Validation.MinUsernameLength else { return ValidationError(Self.UserNameTooShort) }
        guard !credentials.password.isEmpty else { return ValidationError(Self.EmptyPassword) }
        guard Self.HasNumberPredicate.evaluate(with: credentials.password) else { return ValidationError(Self.PasswordsLackANumber) }
        guard Self.HasLowercaseLetterPredicate.evaluate(with: credentials.password) else { return ValidationError(Self.PasswordsLackALowercaseLetter) }
        guard Self.HasUppercaseLetterPredicate.evaluate(with: credentials.password) else { return ValidationError(Self.PasswordsLackAnUppercaseLetter) }
        guard credentials.password.count >= Validation.MinPasswordLength else { return ValidationError(Self.PasswordTooShort) }
        guard !credentials.passwordAgain.isEmpty else { return ValidationError(Self.EmptyPassword) }
        guard credentials.password == credentials.passwordAgain else { return ValidationError(Self.PasswordsDoNotMatch) }
        
        return nil
    }
}

struct PasswordRequirements: CredentialsValidator {
    
    func validate<C: Credentials>(_ credentials: C, completion: @escaping (Error?)->()) {
        completion(nil)
    }
}

// MARK:- PasswordValidator: CredentialsValidator
extension PasswordValidator: CredentialsValidator {
            
    public func validate<C: Credentials>(_ credentials: C, completion: @escaping (Error?)->()) {
        let error = val(credentials)
        completion(error)
//        switch validation {
//        case .valid:
//            completion(nil)
//        default:
//            completion(ValidationError(validation.explanantion))
//        }
    }
}
