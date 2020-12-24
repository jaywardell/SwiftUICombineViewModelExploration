//
//  ContentView.swift
//  SwiftUICombineViewModelExploration
//
//  Created by Joseph Wardell on 12/24/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SignupForm(credentials: .empty, validation: .empty, validator: PasswordValidator(), submit: SignupForm.printSubmission)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
