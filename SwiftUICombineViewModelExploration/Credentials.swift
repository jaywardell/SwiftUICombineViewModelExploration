//
//  Credentials.swift
//  SwiftUICombineViewModelExploration
//
//  Created by Joseph Wardell on 12/24/20.
//

import Foundation

public protocol Credentials {
    var username: String { get }
    var password: String { get }
    var passwordAgain: String { get }
    
    init(username: String, password: String, passwordAgain: String)
}

public protocol CredentialsValidator {
    func validate<C: Credentials>(_ credentials: C, completion: @escaping (Error?)->())
}
