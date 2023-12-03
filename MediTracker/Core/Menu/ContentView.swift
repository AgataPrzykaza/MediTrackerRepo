//
//  MenuMain.swift
//  MediTracker
//
//  Created by Agata Przykaza on 11/11/2023.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject var userAuth = UserManager()
    
    
    var body: some View {
        Group {
            if userAuth.isUserLoggedIn {
                
                MenuView(manager: userAuth)
                    .onAppear {
                            userAuth.fetchUserData()
                           
                        }
            } else {
                WelcomeView(userAuth: userAuth)
            }
        }
        .onAppear(){
            if userAuth.isUserLoggedIn{
                userAuth.fetchUserData()
            }
        }
        
    }
}

#Preview {
    ContentView()
}
