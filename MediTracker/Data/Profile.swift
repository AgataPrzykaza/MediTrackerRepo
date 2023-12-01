//
//  Profile.swift
//  MediTracker
//
//  Created by Agata Przykaza on 05/11/2023.
//

import Foundation

class Profile: Identifiable, Codable{
   
    
     var uid: String
     var name: String
     var surname: String?
     var pictureType: String
    
    init(uid: String, name: String,surname: String,pictureType: String) {
        self.uid = uid
        self.name = name
        self.surname = surname
        self.pictureType = pictureType
    }
    
    func updateName(_ newName: String) {
        name = newName
    }
    
    func updateSurname(_ newSurname: String)
    {
        surname = newSurname
    }
   
    func updatepictureType(_ newType: String)
    {
        pictureType = newType
    }
    
}



