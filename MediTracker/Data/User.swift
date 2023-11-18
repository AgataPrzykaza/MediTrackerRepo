//
//  User.swift
//  MediTracker
//
//  Created by Agata Przykaza on 11/11/2023.
//

import Foundation

class User: Codable{
    
    let uid: String
    let name: String
    let surname: String
    let email: String
    let password: String
    // inne właściwości użytkownika
    
    init(uid: String, username: String, email: String,password: String,surname: String) {
        self.uid = uid
        self.name = username
        self.email = email
        self.password = password
        self.surname = surname
        
    }
    
}

