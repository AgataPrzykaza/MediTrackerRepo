//
//  User.swift
//  MediTracker
//
//  Created by Agata Przykaza on 11/11/2023.
//

import Foundation

class User: Codable{
    
    let uid: String
    var name: String
    var surname: String
    var email: String
    var gender: String
    
    var profiles: [Profile] = []
    
    // inne właściwości użytkownika
    
    init(uid: String, username: String, email: String,surname: String,gender: String) {
        self.uid = uid
        self.name = username
        self.email = email
        self.surname = surname
        self.gender = gender
        
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

