//
//  UserAuthMenager.swift
//  MediTracker
//
//  Created by Agata Przykaza on 18/11/2023.
//
// Klasa UserManager jest kontrolerem zarządzającym użytkownikiem, zwaiera kluczowe funkcje zarządzające oraz zmienne przechowujące informacje w aplikacji.

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
    
    

    
    init() {
        isUserLoggedIn = Auth.auth().currentUser != nil
        
    }
    
    
    //MARK: - Zmiana wybranego profilu
    func selectProfile(newProfile: Profile){
        self.objectWillChange.send()
        currentProfileSelected = newProfile
    }
    
    // Pobranie profilu z bazy danych
    func fetchProfile()
    { guard let uid = currentProfileSelected?.uid else {
        print("Błąd: UID jest nil")
        return
     }
        
        let profileRef = Firestore.firestore().collection("profiles").document(uid)
        self.profilemanager.fetchProfile(profileRef: profileRef) { profile in
            self.currentProfileSelected = profile
        }
    }
    
    //MARK: - Aktualizacja Profilu
    func updateProfile(){
        
        
        self.objectWillChange.send()
        
        
        self.profilemanager.updateProfile(profile: self.currentProfileSelected!) { error in
            
            if let error = error{
                print("Błąd przy aktializacji profiilu")
            }
            if let index = self.listOfProfiles.firstIndex(where: { $0.uid == self.currentProfileSelected!.uid }) {
                self.listOfProfiles[index] = self.currentProfileSelected!
                print("Profile updated in list successfully")
            } else {
                print("Profile not found in the list")
            }
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    //Zapisanie użytkownika
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
    
    //Pobranie danych użytkownika
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
                        
                        
                        if let profileRefs = self.currentUser?.profiles{
                            self.profilemanager.fetchProfiles(profileRefs: profileRefs) { profiles in
                                DispatchQueue.main.async {
                                    
                                    self.currentProfileSelected = profiles.first
                                    self.listOfProfiles = profiles
                                    self.setupNotificationsOnFirstLogin()
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
    
    //Aktualizowanie danych użytkownika
    func updateUser(user: User, completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.async {
            
            self.objectWillChange.send()
            
            let userRef = self.db.collection("users").document(user.uid)
            
          
            let updatedData: [String: Any] = [
                "name": user.name,
                "surname": user.surname,
                "email": user.email,
                "gender": user.gender,
                "profiles": user.profiles
               
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

//  Rozszerzenie klasy UserManager zajmujące się zarządzaniem profilami
extension UserManager{
    
    // Funkcja ustawiająca powiadomienia po zalogowaniu
    func setupNotificationsOnFirstLogin() {
        let userDefaults = UserDefaults.standard

        // Sprawdzanie, czy powiadomienia zostały już ustawione
        if !userDefaults.bool(forKey: "notificationsSet") {
            // Tworzenie powiadomień
            makeNotifications()

            // Zapisanie flagi, że powiadomienia zostały ustawione
            userDefaults.set(true, forKey: "notificationsSet")
        }
    }
    
    // Funkcja tworząca powiadomienia dla każdego z profili użytkownika
    func makeNotifications()
    {
        for profile in listOfProfiles{
            
            for medEntry in profile.medicationSchedule{
                profile.scheduleWeeklyNotifications(for: medEntry)
            }
              
        }
    }
    
    //  Funkcja usuwająca powiadomienia profili użytkownika
    func deleteNotifications(){
        for profile in self.listOfProfiles {
            deleteAllMedsNotification(profile: profile)
        }
    }
    
    // Usuwanie leku w profilu leków
    func removeMedicine(medicineUID: String, completion: @escaping (Error?) -> Void){
        self.objectWillChange.send()
        self.profilemanager.removeMedicationEntry(from: self.currentProfileSelected!, withMedicineUID: medicineUID, completion: completion)
    }
    
    // Aktualizacja danych leku
    func updateMed(med: MedicationEntry){
        self.objectWillChange.send()
        self.currentProfileSelected?.updateMed(med: med)
    }
    
    // Funkcja usuwająca powiadomienia dla danego profilu
    func deleteAllMedsNotification(profile: Profile){
        
        for med in profile.medicationSchedule{
            
            for time in med.times{
                
               profile.removeNotification(forMedicineName: med.medicine.name,
                                                                   onDayOfWeek: Calendar.current.component(.weekday, from: time),
                                                                   atHour: Calendar.current.component(.hour, from: time))
                
            }
        }
        
        
    }
    
    // Funkcja usuwająca profil leków użytkownika
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
                self.deleteAllMedsNotification(profile: profile)
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
               
                completion(nil)
            }
        }
    }
    
    
    
    
}

//  Rozszerzenie klasy UserManager zarządzające kontem użytkownika
extension UserManager {
    
    // Funkcja aktualizująca hasło
    func updatePassword(newPassword: String,currentPassword: String, completion: @escaping (Bool, String?) -> Void) {
        self.reauthenticateUser(password: currentPassword) { success, reauthError in
            if success {
                Auth.auth().currentUser?.updatePassword(to: newPassword) { passwordError in
                    if let passwordError = passwordError {
                        completion(false, "Błąd aktualizacji hasła: \(passwordError.localizedDescription)")
                    } else {
                        completion(true, nil)
                    }
                }
            } else {
                if let reauthError = reauthError {
                    completion(false, reauthError)
                }
            }
        }
    }
    
    // Ponowna autentykacja użytkownika
    func reauthenticateUser(password: String, completion: @escaping (Bool, String?) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: currentUser!.email, password: password)
        
        Auth.auth().currentUser?.reauthenticate(with: credential) { _, error in
            if let error = error {
                completion(false, "Błąd ponownego uwierzytelnienia: \(error.localizedDescription)")
            } else {
                completion(true, nil)
            }
        }
    }
    
    //Funkcja wylogowująca
    func logout() {
        do {
            try Auth.auth().signOut()
            let userDefaults = UserDefaults.standard
            deleteNotifications()
            userDefaults.set(false, forKey: "notificationsSet")
            self.objectWillChange.send()
            currentUser = nil
            currentProfileSelected = nil
            
            listOfProfiles = []
            isUserLoggedIn = false
            
        } catch let signOutError {
            print("Błąd wylogowania: \(signOutError.localizedDescription)")
        }
    }
    
    // Funkcja logowania
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
    
    // Tworzenie użytkownika w bazie danych
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
    
    
}
