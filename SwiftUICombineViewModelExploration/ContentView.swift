//
//  ContentView.swift
//  SwiftUICombineViewModelExploration
//
//  Created by Joseph Wardell on 12/24/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LoginForm(credentials: .empty, validation: .empty, validator: LoginForm.AlwaysValid(), submit: LoginForm.printSubmission)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
