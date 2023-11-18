//
//  UserAuthMenager.swift
//  MediTracker
//
//  Created by Agata Przykaza on 18/11/2023.
//

import Firebase
import Combine
import FirebaseAuth

class UserAuthManager: ObservableObject {
    @Published var isUserLoggedIn: Bool = false
    
    init() {
        isUserLoggedIn = Auth.auth().currentUser != nil
    }
    
    func login(email:String, password: String, completion: @escaping (Bool, Error?) -> Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, error)
            } else {
                print("success")
                self.isUserLoggedIn = true
                completion(true, nil)
            }
        }
    }
    
    func createUser(email: String, password: String) {
        
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            guard let user = authResult?.user else {
                // Obsługa błędu, jeśli użytkownik nie został utworzony poprawnie
                return
            }
            self.isUserLoggedIn = true
        }
        
        
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isUserLoggedIn = false
        } catch let signOutError {
            print("Błąd wylogowania: \(signOutError.localizedDescription)")
        }
    }
}
