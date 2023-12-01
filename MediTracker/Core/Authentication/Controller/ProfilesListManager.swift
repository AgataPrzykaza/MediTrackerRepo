//
//  ProfileManager.swift
//  MediTracker
//
//  Created by Agata Przykaza on 27/11/2023.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class ProfilesListManager{
    
    
    
    func loadProfiles(){
        
    }
    
    func createProfile(profiles: [Profile]){
        
        
        
    }
    
    func fetchAllRestaurants() {
            let db = Firestore.firestore()

            db.collection("profiles").getDocuments() { (querySnapshot, error) in
            if let error = error {
                        print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID): \(document.data())")
                }
            }
            }
    }
    func deleteProfile(){
        
    }
    func updateProfile(){
        
    }
    
}
