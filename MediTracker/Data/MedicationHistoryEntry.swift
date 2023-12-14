//
//  MedicationHistoryEntry.swift
//  MediTracker
//
//  Created by Agata Przykaza on 13/12/2023.
//

import Foundation


class MedicationHistoryEntry: Codable{
    var id: String
    var profileId: String
    var medicationId: String
    var scheduledTime: Date
    var actualTimeTaken: Date
    
    
    init(id:String ,profileId: String, medicationId: String, scheduledTime: Date, actualTimeTaken: Date) {
        self.profileId = profileId
        self.medicationId = medicationId
        self.scheduledTime = scheduledTime
        self.actualTimeTaken = actualTimeTaken
        self.id = id
    }
    
 
    
}
