//
//  PasswordValidator.swift
//  SwiftUICombineViewModelExploration
//
//  Created by Joseph Wardell on 12/24/20.
//

import Foundation

public struct PasswordValidator {
    
    public static let MinUsernameLength: Int = 3
    public static let MinPasswordLength: Int = 5

    public static let EmptyUsername = "Username cannot be empty"
    public static func MinLengthUserName(ofLength length: Int) -> String { "Username must be at least \(length) characters long" }
    public static let UserNameTooShort = MinLengthUserName(ofLength: MinUsernameLength)
    
    // if the user hasn't yet typed the password or password verification, nothing should be reported in the UI
    public static let EmptyPassword = ""
    public static let EmptyPasswordVerification = ""
        
    public static func MinLengthPassword(ofLength length: Int) -> String { "Passwords must be at least \(length) characters long" }
    public static let PasswordTooShort = MinLengthPassword(ofLength: MinPasswordLength)

    public static let PasswordsDoNotMatch = "Passwords do not match"

    private(set) var passwordRequirements = [PasswordRequirement]()
    public init(_ passwordRequirements: [PasswordRequirement] = []) {
        self.passwordRequirements = passwordRequirements
    }
    
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
        
    private func findPasswordRequirementError<C : Credentials>(for credentials: C) -> Swift.Error? {
        var error: Swift.Error?
        for requirement in passwordRequirements {
            requirement.validate(credentials) {
                error = $0
            }
            if nil != error { return error }
        }
        return nil
    }
    
    private func findError<C : Credentials>(with credentials: C) -> Swift.Error? {
        
        guard !credentials.username.isEmpty else { return Error(Self.EmptyUsername) }
        guard credentials.username.count >= Self.MinUsernameLength else { return Error(Self.UserNameTooShort) }
        guard !credentials.password.isEmpty else { return Error(Self.EmptyPassword) }
  
        if let businessLogicError = findPasswordRequirementError(for: credentials) {
            return businessLogicError
        }
        
        guard credentials.password.count >= Self.MinPasswordLength else { return Error(Self.PasswordTooShort) }
        guard !credentials.passwordAgain.isEmpty else { return Error(Self.EmptyPassword) }
        guard credentials.password == credentials.passwordAgain else { return Error(Self.PasswordsDoNotMatch) }
        
        return nil
    }
    
    public static let WithSomeRequirements: PasswordValidator =
        PasswordValidator([
            PasswordRequirement.PasswordHasANumber,
            PasswordRequirement.PasswordHasALowercaseLetter,
            PasswordRequirement.PasswordHasAnUppercaseLetter
        ])
}


// MARK:- PasswordValidator: CredentialsValidator
extension PasswordValidator: CredentialsValidator {
            
    public func validate<C: Credentials>(_ credentials: C, completion: @escaping (Swift.Error?)->()) {
        let error = findError(with: credentials)
        completion(error)
    }
}
