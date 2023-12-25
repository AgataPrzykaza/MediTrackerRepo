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
    var dayPeriod: Int
    var onEmptyStomach: Bool
    var delayMeds: Int
    var instructions: String
    var interactions: [String]
    var reminder: Bool
    var isAntibiotic: Bool
  
    init( name: String, dosage: Double, unit: String, type: String, hourPeriod: Int,frequency:Int, startHour: Date,dayPeriod: Int, onEmptyStomach: Bool, delayMeds: Int, instructions: String, interactions: [String], reminder: Bool,isAntibiotic: Bool) {
        
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
        self.dayPeriod = dayPeriod
    }
    
    func setUid(id: UUID){
        uid = id
    }
    
    
    func calculateNextDoses() -> [Date] {
        var doses = [Date]()
        var nextDose = startHour
        
        if dayPeriod == 0 {
            for _ in 0..<7 {
                if hourPeriod == 0 && frequency == 0 {
                    doses.append(nextDose)
                } else if hourPeriod == 0 {
                    for _ in 0..<frequency {
                        doses.append(nextDose)
                        nextDose = Calendar.current.date(byAdding: .hour, value: 24 / frequency, to: nextDose)!
                    }
                } else {
                    for _ in 0..<(24 / hourPeriod) {
                        doses.append(nextDose)
                        nextDose = Calendar.current.date(byAdding: .hour, value: hourPeriod, to: nextDose)!
                    }
                }
                nextDose = Calendar.current.date(byAdding: .day, value: 1, to: nextDose)!
            }
        } else {
            while !isOneWeekApart(startHour, nextDose) {
                if hourPeriod == 0 && frequency == 0 {
                    doses.append(nextDose)
                } else if hourPeriod == 0 {
                    for _ in 0..<frequency {
                        doses.append(nextDose)
                        nextDose = Calendar.current.date(byAdding: .hour, value: 24 / frequency, to: nextDose)!
                    }
                } else {
                    for _ in 0..<(24 / hourPeriod) {
                        doses.append(nextDose)
                        nextDose = Calendar.current.date(byAdding: .hour, value: hourPeriod, to: nextDose)!
                    }
                }
                nextDose = Calendar.current.date(byAdding: .day, value: dayPeriod, to: nextDose)!
            }
        }

        return doses
    }

    func isOneWeekApart(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current

        // Oblicz różnicę w dniach
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        if let days = components.day {
            // Sprawdź, czy różnica wynosi więcej niż 7 dni
            return abs(days) > 7
        }
        return false
    }


   
    

    

}

func shiftDatesByAWeek(dates: [Date]) -> [Date] {
    return dates.map { $0.addingTimeInterval(604800) } // Dodaje 604800 sekund (czyli tydzień) do każdej daty
}


struct MedicationEntry: Codable {
    var medicine: Medicine
    var times: [Date] // Czasy zażycia leku
}

