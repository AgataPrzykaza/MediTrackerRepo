//
//  MenuMain.swift
//  MediTracker
//
//  Created by Agata Przykaza on 11/11/2023.
//

import SwiftUI
import FirebaseAuth
import Network

struct ContentView: View {
    @StateObject var userAuth = UserManager()
    @State private var isConnectedToInternet = true
    
    private let monitor = NWPathMonitor()
    
    var body: some View {
        Group {
            if userAuth.isUserLoggedIn {
                
                if NetworkManager.shared.isConnectedToInternet() {
                                    MenuView(manager: userAuth)
                                        .onAppear {
                                            userAuth.fetchUserData()
                                            
                                        }
                                } else {
                                    // Wyświetl komunikat o braku połączenia internetowego
                                    Text("Brak połączenia z Internetem")
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

class NetworkManager {
    static let shared = NetworkManager()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    init() {
        monitor.start(queue: queue)
    }

    func isConnectedToInternet() -> Bool {
        return monitor.currentPath.status == .satisfied
    }
}

#Preview {
    ContentView()
}
