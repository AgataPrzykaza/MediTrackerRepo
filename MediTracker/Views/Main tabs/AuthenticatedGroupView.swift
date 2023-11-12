//
//  AuthenticatedGroupView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 11/11/2023.
//

import SwiftUI

struct AuthenticatedGroupView: View {
    @State private var isUserAuthenticated = false

       var body: some View {
           Group {
               if isUserAuthenticated {
                   MenuView()
               } else {
                   WelcomeView()
               }
           }
           .onAppear {
               // Sprawdź, czy użytkownik jest zalogowany
               // Jeśli tak, ustaw `isUserAuthenticated` na true
           }
       }
}

#Preview {
    AuthenticatedGroupView()
}
