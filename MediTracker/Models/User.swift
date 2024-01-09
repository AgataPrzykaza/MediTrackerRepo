//
//  User.swift
//  MediTracker
//
//  Created by Agata Przykaza on 11/11/2023.
//
// Model użytkownika

import Foundation
import FirebaseFirestore

class User: Codable{
    
    let uid: String
    var name: String
    var surname: String
    var email: String
    var gender: String
    
    var profiles: [DocumentReference] = []
    
    
    
    init(uid: String, username: String, email: String,surname: String,gender: String) {
        self.uid = uid
        self.name = username
        self.email = email
        self.surname = surname
        self.gender = gender
        
    }
    
    // Dodanie nowego profilu
    func addProfileReference(profile: DocumentReference){
        
        profiles.append(profile)
        
    }
    func updateName(_ newName: String) {
        name = newName
    }
    
    func updateSurname(_ newSurname: String) {
        surname = newSurname
    }
    
    func updateEmail(_ newEmail: String) {
        email = newEmail
    }
    
    func updateGender(_ newGender: String){
        gender = newGender
    }
    
}

