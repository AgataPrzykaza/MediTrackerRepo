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
     var medicationSchedule: [MedicationEntry] = []
    
    init(uid: String, name: String,surname: String,pictureType: String) {
        self.uid = uid
        self.name = name
        self.surname = surname
        self.pictureType = pictureType
    }
    
    func addMedication (_ med: Medicine){
        
        var entry = MedicationEntry(medicine: med, times: med.calculateNextDoses())
        medicationSchedule.append(entry)
       
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
    
    func getMedsList() -> [Medicine]{
        var leki: [Medicine] = []

        for entry in medicationSchedule {
            leki.append(entry.medicine)
        }
        return leki
    }
}



