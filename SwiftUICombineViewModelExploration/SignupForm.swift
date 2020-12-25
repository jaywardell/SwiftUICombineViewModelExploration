//
//  LoginForm.swift
//  SwiftUICombineViewModelExploration
//
//  Created by Joseph Wardell on 12/24/20.
//


import SwiftUI

struct SignupForm {
        
    struct ViewModel: Equatable, Credentials {
        var username: String
        var password: String
        var passwordAgain: String

        var isEmpty: Bool {
            username.isEmpty && password.isEmpty && passwordAgain.isEmpty
        }
        
        static var empty: Self { .init(username: "", password: "", passwordAgain: "") }
        
        func withClearedPassword() -> ViewModel {
            ViewModel(username: username, password: "", passwordAgain: "")
        }
    }
    @State var credentials: ViewModel = .empty

    @State var validationError: Error?
    
    let validator: CredentialsValidator
  
    fileprivate struct AlwaysValid: CredentialsValidator {
        func validate<C: Credentials>(_ credentials: C, completion: @escaping (Error?)->()) {
            print(credentials)
            completion(nil)
        }
    }
    
    fileprivate struct NeverValid: CredentialsValidator {
        struct AlwaysError: Error, LocalizedError {
            var errorDescription: String? { "always an error" }
        }
        func validate<C: Credentials>(_ credentials: C, completion: @escaping (Error?)->()) {
            completion(AlwaysError())
        }
    }

    let submit: (Credentials)->()
    
    fileprivate static let emptySubmission: (Credentials)->() = { _ in }

    static let printSubmission: (Credentials)->() = {
        print(#function, $0)
    }
    
    private func usernameEditingStateChanged(editingBegan: Bool) {
        if editingBegan {
            userBeganEditingUsername()
        }
    }
    
    // if the user tries to change the username,
    // then she's trying to start the process over.
    // We should go back to a blank password unless she's entered a valid password
    private func userBeganEditingUsername() {
        if nil != validationError {
            credentials = credentials.withClearedPassword()
        }
    }
    
}

// MARK:- LoginForm: View
extension SignupForm: View {
    
    private var usernameHeader: some View {
        Text("Username".uppercased())
    }
    
    private var passwordHeader: some View {
        Text("Password".uppercased())
    }
    
    private var passwordFooter: some View {
        Text(validationError?.localizedDescription ?? "")
            .foregroundColor(.red)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(header: usernameHeader) {
                        TextField("Username", text: $credentials.username, onEditingChanged: usernameEditingStateChanged(editingBegan:))
                            .autocapitalization(.none)
                    }
                    
                    Section(header: passwordHeader,
                            footer: passwordFooter) {
                        SecureField("Password", text: $credentials.password, onCommit: {  print("commmited")})
                        SecureField("Password Again", text: $credentials.passwordAgain)
                    }
                }
                
                if nil == validationError && !credentials.isEmpty {
                    VStack {
                        Spacer()
                        Button(action: {
                            submit(credentials)
                        }, label: {
                            Text("Sign Up")
                        })
                        .padding()
                    }
                    .ignoresSafeArea(.keyboard)

                }
            }
            .navigationTitle("Sign up")
        }
        .onChange(of: credentials, perform: { value in
            validator.validate(credentials) {
                self.validationError = $0
            }
        })
    }
}


// MARK:- LoginForm_Previews
struct LoginForm_Previews: PreviewProvider {
    
    private struct NamedError: Error, LocalizedError {
        let explanation: String
        init(_ explanation: String) {
            self.explanation = explanation
        }
        
        public var errorDescription: String? {
            explanation
        }
    }

    static var previews: some View {
        Group {
            SignupForm(credentials: .empty,
                       validationError: nil,
                      validator: SignupForm.NeverValid(),
                      submit: SignupForm.emptySubmission)
                .previewDisplayName("First Visible")
            
            SignupForm(credentials: .init(username: "Sam", password: "ccc", passwordAgain: "ccc"),
                       validationError: NamedError("Invalid Entry: password is too short"),
                      validator: SignupForm.NeverValid(),
                      submit: SignupForm.emptySubmission)
                .previewDisplayName("password is too short")

            SignupForm(credentials: .init(username: "George", password: "a valid password", passwordAgain: "a valid password"),
                       validationError: nil,
                      validator: SignupForm.AlwaysValid(),
                      submit: SignupForm.emptySubmission)
                .previewDisplayName("Valid Entry")
        }
    }
}
