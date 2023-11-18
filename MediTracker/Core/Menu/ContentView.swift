//
//  MenuMain.swift
//  MediTracker
//
//  Created by Agata Przykaza on 11/11/2023.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject var userAuth = UserAuthManager()
    
    var body: some View {
        Group {
            if userAuth.isUserLoggedIn {
                MenuView(userAuth: userAuth)
            } else {
                WelcomeView(userAuth: userAuth)
            }
        }
        
    }
}

#Preview {
    ContentView()
}
