//
//  UserAuthMenager.swift
//  MediTracker
//
//  Created by Agata Przykaza on 18/11/2023.
//

import Firebase
import Combine
import FirebaseAuth
import FirebaseFirestore

class UserManager: ObservableObject {
    
    
    let db = Firestore.firestore()
    
    @Published var isUserLoggedIn: Bool = false
    @Published var currentUser: User?
//    @Published var currentProfileSelected: Profile?
    
//    var profileListManager =  ProfilesListManager (profiles: [])
    
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
                
                
                
                
            }
        }
        
        
    }
    
    func createUser(email: String, password: String,name: String, surname: String,gender: String) {
        
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            guard let user = authResult?.user else {
                // Obsługa błędu, jeśli użytkownik nie został utworzony poprawnie
                return
            }
            self.isUserLoggedIn = true
            // Uaktualnienie obiektu User z dodatkowymi danymi
            let newUser = User(uid: user.uid, username: name, email: email, surname: surname,gender:gender)
            self.currentUser = newUser
            
            
            // Zapisanie użytkownika do bazy danych
            self.saveUser(user: newUser)
        }
        
        
    }
    
    func saveUser(user: User) {
        
        db.collection("users").document(user.uid).setData([
            "uid": user.uid,
            "name": user.name,
            "surname": user.surname,
            "email": user.email,
            "gender": user.gender,
            "profiles": user.profiles
        ]) { error in
            if let error = error {
                print("Błąd zapisu użytkownika: \(error.localizedDescription)")
            } else {
                print("Użytkownik został zapisany pomyślnie w Firestore.")
            }
        }
    }
    
    func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else {
                print("Brak zalogowanego użytkownika")
                return
            }
        
        db.collection("users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    let user = try document.data(as: User.self)
                    DispatchQueue.main.async {
                        self.currentUser = user
                    }
                } catch {
                    print("Błąd podczas deserializacji użytkownika: \(error)")
                    DispatchQueue.main.async {
                        self.currentUser = nil
                    }
                }
            } else if let error = error {
                print("Błąd podczas odczytu danych użytkownika: \(error)")
                DispatchQueue.main.async {
                    self.currentUser = nil
                }
            } else {
                print("Dokument użytkownika nie istnieje")
                DispatchQueue.main.async {
                    self.currentUser = nil
                }
            }
        }
        
    }
    
    func updateUser(user: User, completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.async {
            
            self.objectWillChange.send()
            
            let userRef = self.db.collection("users").document(user.uid)
            
            // Nowe dane użytkownika, które chcesz zaktualizować
            let updatedData: [String: Any] = [
                "name": user.name,
                "surname": user.surname,
                "email": user.email,
                "gender": user.gender,
                "profiles": user.profiles
                // Dodaj inne pola, które chcesz zaktualizować
            ]
            
            // Aktualizacja danych użytkownika
            userRef.setData(updatedData, merge: true) { error in
                if let error = error {
                    print("Błąd aktualizacji danych użytkownika: \(error.localizedDescription)")
                } else {
                    print("Dane użytkownika zaktualizowane pomyślnie!")
                }
                
                completion(error)
            }
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
    
    
    func changePassword(newPassword: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Brak zalogowanego użytkownika"]))
            return
        }
        
        currentUser.updatePassword(to: newPassword) { error in
            if let error = error {
                // Obsługa błędu
                completion(false, error)
            } else {
                // Hasło zostało zmienione
                completion(true, nil)
            }
        }
    }
}
