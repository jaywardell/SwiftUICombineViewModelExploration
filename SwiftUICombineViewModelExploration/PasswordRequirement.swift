//
//  PasswordRequirement.swift
//  SwiftUICombineViewModelExploration
//
//  Created by Joseph Wardell on 12/25/20.
//

import Foundation

public struct PasswordRequirement: CredentialsValidator {
    
    public let predicate: NSPredicate
    public let errorString: String
    
    struct Error: Swift.Error, LocalizedError {
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

    func validate<C: Credentials>(_ credentials: C, completion: @escaping (Swift.Error?)->()) {
        if !predicate.evaluate(with: credentials.password) {
            completion(Error(errorString))
        }
        else {
            completion(nil)
        }
    }
    
    static let HasNumberPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[0-9].*")
    static let HasLowercaseLetterPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[a-z].*")
    static let HasUppercaseLetterPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z].*")

    public static let PasswordsLackANumber = "Passwords need at least one number"
    public static let PasswordsLackALowercaseLetter = "Passwords need at least one lowercase letter"
    public static let PasswordsLackAnUppercaseLetter = "Passwords need at least one uppercase letter"

    public static let PasswordHasANumber = PasswordRequirement(predicate: HasNumberPredicate, errorString: PasswordsLackANumber)
    public static let PasswordHasALowercaseLetter = PasswordRequirement(predicate: HasLowercaseLetterPredicate, errorString: PasswordsLackALowercaseLetter)
    public static let PasswordHasAnUppercaseLetter = PasswordRequirement(predicate: HasUppercaseLetterPredicate, errorString: PasswordsLackAnUppercaseLetter)
}
