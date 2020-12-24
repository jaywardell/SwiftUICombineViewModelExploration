//
//  LoginForm.swift
//  SwiftUICombineViewModelExploration
//
//  Created by Joseph Wardell on 12/24/20.
//


import SwiftUI

struct SignupForm {
        
    struct CredentialsViewModel: Equatable, Credentials {
        var username: String
        var password: String
        var passwordAgain: String

        static var empty: Self { .init(username: "", password: "", passwordAgain: "") }
    }
    @State var credentials: CredentialsViewModel = .empty

    struct ValidationViewModel: CredentialsValidation {
        var passwordFeedback: String
        var isValid: Bool
        
        static var empty: ValidationViewModel { .init(passwordFeedback: "", isValid: false) }

        fileprivate static var valid: ValidationViewModel { .init(passwordFeedback: "", isValid: true) }
    }
    @State var validation: ValidationViewModel = .empty

    let validator: CredentialsValidator
  
    fileprivate struct AlwaysValid: CredentialsValidator {
        func validate<C, V>(_ credentials: C) -> V where C : Credentials, V : CredentialsValidation {
            print(credentials)
            return .init(passwordFeedback: "", isValid: true)
        }
    }
    
    fileprivate struct NeverValid: CredentialsValidator {
        func validate<C, V>(_ credentials: C) -> V where C : Credentials, V : CredentialsValidation {
            .init(passwordFeedback: "", isValid: false)
        }
    }

    let submit: (Credentials)->()
    
    fileprivate static let emptySubmission: (Credentials)->() = { _ in }

    static let printSubmission: (Credentials)->() = {
        print(#function, $0)
    }
    
    // if the user tries to change the username,
    // then she's trying to start the process over.
    // We should go back to a blank password unless she's entered a valid password
    private func userBeganEditingUsername(editingBegan: Bool) {
        guard editingBegan else { return }
        if !validation.isValid {
            credentials = credentials.withClearedPassword()
        }
    }
    
}

extension SignupForm {
    init(_ validator: CredentialsValidator = AlwaysValid(), submit: @escaping (Credentials)->() = SignupForm.emptySubmission) {
        self.validator = validator
        self.submit = submit
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
        Text(validation.passwordFeedback)
            .foregroundColor(.red)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: usernameHeader) {
                        TextField("Username", text: $credentials.username, onEditingChanged: userBeganEditingUsername(editingBegan:))
                            .autocapitalization(.none)
                    }
                    
                    Section(header: passwordHeader,
                            footer: passwordFooter) {
                        SecureField("Password", text: $credentials.password, onCommit: {  print("commmited")})
                        SecureField("Password Again", text: $credentials.passwordAgain)
                    }
                }
                
                Spacer()
                
                if validation.isValid {
                    Button(action: {
                        submit(credentials)
                    }, label: {
                        Text("Sign Up")
                    })
                    .padding()
                }
            }
            .navigationTitle("Sign up")
        }
        .onChange(of: credentials, perform: { value in
            self.validation = validator.validate(credentials)
        })
    }
}

// MARK:- LoginForm_Previews
struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignupForm()
                .previewDisplayName("First Visible")
            
            SignupForm(credentials: .init(username: "Sam", password: "ccc", passwordAgain: "ccc"),
                      validation: .init(passwordFeedback: "password is too short", isValid: false),
                      validator: SignupForm.NeverValid(),
                      submit: SignupForm.emptySubmission)
                .previewDisplayName("Invalid Entry: password is too short")

            SignupForm(credentials: .init(username: "George", password: "a valid password", passwordAgain: "a valid password"),
                      validation: .valid,
                      validator: SignupForm.NeverValid(),
                      submit: SignupForm.emptySubmission)
                .previewDisplayName("Valid Entry")
        }
    }
}
