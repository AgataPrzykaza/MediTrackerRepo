//
//  ProfileManager.swift
//  MediTracker
//
//  Created by Agata Przykaza on 27/11/2023.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class ProfileManager{
    
    //var profile: Profile?
    let db = Firestore.firestore()
    
    func loadProfile(){
        
    }
    
    func updateProfile(profile: Profile, completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.async {
            let profileRef = self.db.collection("profiles").document(profile.uid)
            
            // Nowe dane profilu, które chcesz zaktualizować
            let updatedData: [String: Any] = [
                "name": profile.name,
                "surname": profile.surname,
                "pictureType": profile.pictureType
                // Dodaj inne pola profilu, które chcesz zaktualizować
            ]
            
            // Aktualizacja danych profilu
            profileRef.setData(updatedData, merge: true) { error in
                if let error = error {
                    print("Błąd aktualizacji danych profilu: \(error.localizedDescription)")
                    completion(error)
                } else {
                    print("Dane profilu zaktualizowane pomyślnie!")
                    completion(nil)
                }
            }
        }
    }

//    func fetchProfile(user: User, completion: @escaping (Profile?) -> Void) {
//        db.collection("profiles").document(user.uid).getDocument { (document, error) in
//            guard let document = document, document.exists, error == nil else {
//                print("Błąd podczas odczytu profilu: \(error?.localizedDescription ?? "Nieznany błąd")")
//                completion(nil)
//                return
//            }
//
//            let data = document.data()
//            var profile = Profile(uid: "", name: "", surname: "", pictureType: "")
//            if let data = data {
//                profile.name = data["name"] as? String ?? ""
//                profile.surname = data["surname"] as? String ?? ""
//                profile.pictureType = data["pictureType"] as? String ?? ""
//                profile.uid = data["uid"] as? String ?? ""
//            }
//
//            completion(profile)
//        }
//    }

    func fetchProfiles(profileRefs: [DocumentReference], completion: @escaping ([Profile]) -> Void) {
        var profiles: [Profile] = []
        let dispatchGroup = DispatchGroup()

        for profileRef in profileRefs {
            dispatchGroup.enter()
            profileRef.getDocument { (document, error) in
                defer { dispatchGroup.leave() }

                if let document = document, document.exists {
                    let data = document.data()
                    var profile = Profile(uid: "", name: "", surname: "", pictureType: "")
                    if let data = data {
                        profile.name = data["name"] as? String ?? ""
                        profile.surname = data["surname"] as? String ?? ""
                        profile.pictureType = data["pictureType"] as? String ?? ""
                        profile.uid = data["uid"] as? String ?? document.documentID // Użyj documentID, jeśli uid nie jest zapisany
                    }
                    profiles.append(profile)
                } else {
                    print("Błąd podczas odczytu profilu: \(error?.localizedDescription ?? "Nieznany błąd")")
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(profiles)
        }
    }

    
    func createProfile(name: String, surname: String, pictureType: String, completion: @escaping (Profile?, Error?) -> Void) {
        var ref: DocumentReference? = nil
        ref = db.collection("profiles").addDocument(data: [
            "name": name,
            "surname": surname,
            "pictureType": pictureType
        ]) { error in
            if let error = error {
                print("Błąd podczas tworzenia profilu: \(error.localizedDescription)")
                completion(nil, error)
            } else {
                print("Profil został utworzony pomyślnie w Firestore.")
                // Utworzenie nowego profilu z wygenerowanym ID
                let newProfile = Profile(uid: ref!.documentID, name: name, surname: surname, pictureType: pictureType)
                completion(newProfile, nil)
            }
        }
    }


//    func saveProfile(profile: Profile) {
//        
//        db.collection("profiles").document(profile.uid).setData([
//            "uid": profile.uid,
//            "name": profile.name,
//            "surname": profile.surname,
//            "pictureType": profile.pictureType,
//            
//        ]) { error in
//            if let error = error {
//                print("Błąd zapisu profilu: \(error.localizedDescription)")
//            } else {
//                print("Profil został zapisany pomyślnie w Firestore.")
//            }
//        }
//    }
    
    func deleteProfile(){
        
    }
    func updateProfile(){
        
    }
    
}
