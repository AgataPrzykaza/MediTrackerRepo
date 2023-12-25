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
    
    
    @Published var db = Firestore.firestore()
    @Published var profilemanager = ProfileManager()
    
    @Published var isUserLoggedIn: Bool = false
    @Published var currentUser: User?
    @Published var currentProfileSelected: Profile?
    
    @Published var listOfProfiles:[Profile]  = []
    
    
    //    var profileListManager =  ProfilesListManager (profiles: [])
    
    init() {
        isUserLoggedIn = Auth.auth().currentUser != nil
        
    }
    
    
    //MARK: - Zmiana wybranego profilu
    func selectProfile(newProfile: Profile){
        self.objectWillChange.send()
        currentProfileSelected = newProfile
    }
    //MARK: - Aktualizacja Profilu
    func updateProfile(){
        self.objectWillChange.send()
        profilemanager.updateProfile(profile: currentProfileSelected!) { error in
            
        }
    }
    
    
    //Zapisanie Usera
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
    
    //Pobranie danych usera
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
                        
                        // Teraz używasz fetchProfiles zamiast fetchProfile
                        if let profileRefs = self.currentUser?.profiles{
                            self.profilemanager.fetchProfiles(profileRefs: profileRefs) { profiles in
                                DispatchQueue.main.async {
                                    // Zakładając, że interesuje Cię tylko pierwszy profil lub sposób ich obsługi
                                    self.currentProfileSelected = profiles.first
                                    self.listOfProfiles = profiles
                                    
                                }
                            }
                        }
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
    
    //Aktualizowanie danych usera
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
    
    
    
    
    
    
    
}

//Operacje na profilach
extension UserManager{
    
    func removeMedicine(medicineUID: String, completion: @escaping (Error?) -> Void){
        self.objectWillChange.send()
        self.profilemanager.removeMedicationEntry(from: self.currentProfileSelected!, withMedicineUID: medicineUID, completion: completion)
    }
    
    
    func deleteProfile(profile: Profile, completion: @escaping (Error?) -> Void) {
        self.objectWillChange.send()
        // Usunięcie profilu z Firestore
        db.collection("profiles").document(profile.uid).delete { error in
            if let error = error {
                completion(error)
                return
            }
            
            // Aktualizacja obiektu User
            if let index = self.currentUser?.profiles.firstIndex(where: { $0.documentID == profile.uid }) {
                self.currentUser?.profiles.remove(at: index)
                self.updateUser(user: self.currentUser!) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    // Aktualizacja currentProfileSelected i listOfProfiles
                    DispatchQueue.main.async {
                        
                        self.listOfProfiles.removeAll { $0.uid == profile.uid }
                        self.currentProfileSelected = self.listOfProfiles.first
                        
                        
                        completion(nil)
                    }
                }
            } else {
                // Profil nie znaleziony w obiekcie User
                completion(nil)
            }
        }
    }
    
}


extension UserManager {
    
    func updateEmailAndPassword(newEmail: String, newPassword: String, completion: @escaping (Bool, String?) -> Void) {
        
        self.objectWillChange.send()
        
        guard let currentUser = Auth.auth().currentUser else {
            completion(false, "Brak zalogowanego użytkownika.")
            return
        }
        
        // Aktualizacja adresu e-mail
        currentUser.updateEmail(to: newEmail) { emailError in
            if let emailError = emailError {
                completion(false, "Błąd aktualizacji e-maila: \(emailError.localizedDescription)")
                return
            }
            
            currentUser.updatePassword(to: newPassword) { passwordError in
                if let passwordError = passwordError {
                    completion(false, "Błąd aktualizacji hasła: \(passwordError.localizedDescription)")
                    return
                }
                
                currentUser.updateEmail(to: newEmail)
                
               
                self.updateEmailInFirestore(userUid: currentUser.uid, newEmail: newEmail) { firestoreError in
                    if let firestoreError = firestoreError {
                        completion(false, "Błąd aktualizacji e-maila w Firestore: \(firestoreError.localizedDescription)")
                    } else {
                        completion(true, nil) // Sukces
                    }
                }}
        }
    }
    
    func updateEmailInFirestore(userUid: String, newEmail: String, completion: @escaping (Error?) -> Void) {
        let userRef = db.collection("users").document(userUid)
        userRef.updateData(["email": newEmail]) { error in
            completion(error)
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            
            self.objectWillChange.send()
            currentUser = nil
            currentProfileSelected = nil
            
            listOfProfiles = []
            isUserLoggedIn = false
            
        } catch let signOutError {
            print("Błąd wylogowania: \(signOutError.localizedDescription)")
        }
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
    
    func createUser(email: String, password: String, name: String, surname: String, gender: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email.lowercased(), password: password) { authResult, error in
            if let error = error as NSError? {
                // Sprawdzenie, czy email jest już używany
                if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    completion(false, "Ten email jest już używany.")
                } else {
                    // Obsługa innych błędów
                    completion(false, "Błąd przy tworzeniu użytkownika: \(error.localizedDescription)")
                }
                return
            }
            
            guard let user = authResult?.user else {
                completion(false, "Nie udało się utworzyć użytkownika.")
                return
            }
            self.isUserLoggedIn = true
            
            self.profilemanager.createProfile(name: name, surname: surname, pictureType: gender) { profile, error in
                if let profile = profile {
                    self.currentProfileSelected = profile
                    let profileRef = self.db.collection("profiles").document(profile.uid)
                    self.listOfProfiles.append(profile)
                    let newUser = User(uid: user.uid, username: name, email: email, surname: surname, gender: gender)
                    newUser.addProfileReference(profile: profileRef)
                    self.currentUser = newUser
                    self.saveUser(user: newUser)
                    
                    completion(true, nil)
                } else {
                    completion(false, "Błąd przy tworzeniu profilu w Firestore: \(error?.localizedDescription ?? "Nieznany błąd")")
                }
            }
        }
    }
    
    //    func createUser(email: String, password: String,name: String, surname: String,gender: String) {
    //
    //
    //        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
    //
    //            guard let user = authResult?.user else {
    //                // Obsługa błędu, jeśli użytkownik nie został utworzony poprawnie
    //                return
    //            }
    //            self.isUserLoggedIn = true
    //
    //
    //            self.profilemanager.createProfile(name: name, surname: surname, pictureType: gender) { profile, error in
    //                if let profile = profile {
    //                    // Zapisz lub zaktualizuj profil w aplikacji
    //                    self.currentProfileSelected = profile
    //
    //                    let profileRef = self.db.collection("profiles").document(self.currentProfileSelected?.uid ?? "")
    //
    //                    // Uaktualnienie obiektu User z dodatkowymi danymi
    //                    let newUser = User(uid: user.uid, username: name, email: email, surname: surname,gender:gender)
    //                    newUser.addProfileReference(profile: profileRef)
    //
    //                    self.currentUser = newUser
    //
    //
    //                    // Zapisanie użytkownika do bazy danych
    //                    self.saveUser(user: newUser)
    //
    //                } else if let error = error {
    //                    // Obsługa błędu
    //                    print("Błąd przy tworzeniu profilu w Firestore")
    //                }
    //            }
    //
    //
    //
    //        }
    //
    //
    //    }
}
