//
//  Medicine.swift
//  MediTracker
//
//  Created by Agata Przykaza on 05/11/2023.
//

import Foundation

class Medicine: Codable {
    
    var uid = UUID()
    var name: String
    var dosage: Double
    var unit: String
    var type: String
    var hourPeriod: Int
    var frequency: Int
    var startHour: Date
    var onEmptyStomach: Bool
    var delayMeds: Int
    var instructions: String
    var interactions: [String]
    var reminder: Bool
    var isAntibiotic: Bool
  
    init( name: String, dosage: Double, unit: String, type: String, hourPeriod: Int,frequency:Int, startHour: Date, onEmptyStomach: Bool, delayMeds: Int, instructions: String, interactions: [String], reminder: Bool,isAntibiotic: Bool) {
        
        self.name = name
        self.dosage = dosage
        self.unit = unit
        self.type = type
        self.hourPeriod = hourPeriod
        self.frequency = frequency
        self.startHour = startHour
        self.onEmptyStomach = onEmptyStomach
        self.delayMeds = delayMeds
        self.instructions = instructions
        self.interactions = interactions
        self.reminder = reminder
        self.isAntibiotic = isAntibiotic
    }
    
    func setUid(id: UUID){
        uid = id
    }
    func calculateNextDoses() -> [Date] {
            var doses = [Date]()
            var nextDose = startHour

            for _ in 1...frequency {
                doses.append(nextDose)
                nextDose = Calendar.current.date(byAdding: .hour, value: hourPeriod, to: nextDose)!
            }

            return doses
        }
}


struct MedicationEntry: Codable {
    var medicine: Medicine
    var times: [Date] // Czasy zażycia leku
}
