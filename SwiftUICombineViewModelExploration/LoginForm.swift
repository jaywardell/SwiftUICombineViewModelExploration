//
//  LoginForm.swift
//  SwiftUICombineViewModelExploration
//
//  Created by Joseph Wardell on 12/24/20.
//

// on 12/24/2020, I watched 2 youtube video that got me thinking about design patterns using SwiftUI and Combine
// https://www.youtube.com/watch?v=YJRApch2cc4&t=435s
// https://www.youtube.com/watch?v=bdqEcpppAMc

import SwiftUI

struct LoginForm {
        
    struct Credentials: Equatable {
        var username: String
        var password: String
        var passwordAgain: String

        static var empty: Self { .init(username: "", password: "", passwordAgain: "") }
    }
     
    struct Validation {
        var passwordFeedback: String
        
        var isValid: Bool
        
        static var empty: Validation { .init(passwordFeedback: "", isValid: false) }

        static var valid: Validation { .init(passwordFeedback: "", isValid: true) }
    }
    
    @State var credentials: Credentials
    @State var validation: Validation

    let validate: (Credentials)->Validation
    
    static let alwaysValid: (Credentials)->Validation = {
        print($0)
        return .init(passwordFeedback: "", isValid: true)
    }

    static let neverValid: (Credentials)->Validation = { _ in
        .init(passwordFeedback: "", isValid: false)
    }

    let submit: (Credentials)->()
    
    static let emptySubmission: (Credentials)->() = { _ in }

    static let printSubmission: (Credentials)->() = {
        print(#function, $0)
    }
}

// MARK:- LoginForm: View
extension LoginForm: View {
    
    private var usernameHeader: some View {
        Text("Username".uppercased())
    }
    
    private var passwordHeader: some View {
        Text("Password".uppercased())
    }
    
    private var passwordFooter: some View {
        Text(validation.passwordFeedback)
            .foregroundColor(.red)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: usernameHeader) {
                        TextField("Username", text: $credentials.username)
                            .autocapitalization(.none)
                    }
                    
                    Section(header: passwordHeader,
                            footer: passwordFooter) {
                        SecureField("Password", text: $credentials.password)
                        SecureField("Password Again", text: $credentials.passwordAgain)
                    }
                }
                
                // NOTE: this is incorrect as it brings the button up with the software keyboard when typing
                Button(action: {
                    submit(credentials)
                }, label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 60)
                        .overlay(
                            Text("Continue")
                                .foregroundColor(.white)
                        )
                })
                .disabled(!validation.isValid)
                .padding()
            }
            .navigationTitle("Sign up")
        }
        .onChange(of: credentials, perform: { value in
            self.validation = validate(credentials)
        })
    }
}

// MARK:-
struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginForm(credentials: .empty,
                      validation: .empty,
                      validate: LoginForm.alwaysValid,
                      submit: LoginForm.emptySubmission)

            LoginForm(credentials: .init(username: "Sam", password: "ccc", passwordAgain: "ccc"),
                      validation: .init(passwordFeedback: "password is too short", isValid: false),
                      validate: LoginForm.neverValid,
                      submit: LoginForm.emptySubmission)

            LoginForm(credentials: .init(username: "George", password: "a valid password", passwordAgain: "a valid password"),
                      validation: .valid,
                      validate: LoginForm.neverValid,
                      submit: LoginForm.emptySubmission)
        }
    }
}
