//
//  Profile.swift
//  MediTracker
//
//  Created by Agata Przykaza on 05/11/2023.
//

import Foundation
import UserNotifications

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
    
    func addMedication (_ med: Medicine,delay: Double){
        
        
        
        var entry = MedicationEntry(medicine: med, times: med.calculateNextDoses())
        if delay != 0{
            
            adjustTimesForMatchingMedicationsAndWeekdays(interactions: entry.medicine.interactions, delay: delay, newMedicationEntry: entry)
        }
        medicationSchedule.append(entry)
        scheduleWeeklyNotifications(for: entry)
        
        
    }
    
    
    func scheduleWeeklyNotifications(for entry: MedicationEntry) {
        let content = UNMutableNotificationContent()
        content.title = "\(name) Czas na lek"
        content.body = "Przypomnienie o wzięciu leku: \(entry.medicine.name)"
        content.sound = UNNotificationSound.default
        
        for time in entry.times {
            
            let triggerDate = Calendar.current.dateComponents([.weekday, .hour, .minute], from: time)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
            
            let dayOfWeek = Calendar.current.component(.weekday, from: time)
            let hour = Calendar.current.component(.hour, from: time)
            let identifier = "\(uid)-\(entry.medicine.name)-\(dayOfWeek)-\(hour)"
            
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    // Obsługa błędów powiadomień
                    print("Błąd przy dodawaniu powiadomienia: \(error)")
                }
            }
        }
    }
    
    func updateNotificationTime(forMedicineName medicineName: String, onDayOfWeek dayOfWeek: Int, currentHour: Int, newHour: Int) {
        let currentIdentifierPattern = "\(uid)-\(medicineName)-\(dayOfWeek)-\(currentHour)"
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let requestsToUpdate = requests.filter { $0.identifier.contains(currentIdentifierPattern) }
            
            for request in requestsToUpdate {
                // Sprawdzenie, czy trigger jest UNCalendarNotificationTrigger
                if let calendarTrigger = request.trigger as? UNCalendarNotificationTrigger {
                    // Tworzenie nowego triggera z aktualizowaną godziną
                    var newTriggerDate = calendarTrigger.dateComponents
                    newTriggerDate.hour = newHour
                    
                    let newTrigger = UNCalendarNotificationTrigger(dateMatching: newTriggerDate, repeats: true)
                    let newIdentifier = "\(self.uid)-\(medicineName)-\(dayOfWeek)-\(newHour)"
                    
                    let newRequest = UNNotificationRequest(identifier: newIdentifier, content: request.content, trigger: newTrigger)
                    
                    // Dodanie nowego powiadomienia i usunięcie starego
                    UNUserNotificationCenter.current().add(newRequest) { error in
                        if let error = error {
                            print("Błąd przy aktualizacji powiadomienia: \(error)")
                        } else {
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                        }
                    }
                }
            }
        }
    }
    
    
    
    func removeNotification(forMedicineName medicineName: String, onDayOfWeek dayOfWeek: Int, atHour hour: Int) {
        let identifierPattern = "\(uid)-\(medicineName)-\(dayOfWeek)-\(hour)"
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let identifiersToRemove = requests
                .filter { $0.identifier.contains(identifierPattern) }
                .map { $0.identifier }
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
            
            
        }
    }
    
    
    
    
    func removeMedicationEntry(medicineUID: String) {
        // Find the index of the medication entry that matches the given medicine UID
        if let index = medicationSchedule.firstIndex(where: { $0.medicine.uid.uuidString == medicineUID }) {
            // Remove the medication entry at the found index
            medicationSchedule.remove(at: index)
        } else {
            // Handle the case where the medication entry is not found
            print("Medication entry not found")
        }
    }
    func adjustTimesForMatchingMedicationsAndWeekdays(interactions: [String], delay: Double, newMedicationEntry: MedicationEntry) {
        
        let newWeekdays = Set(newMedicationEntry.times.map { Calendar.current.component(.weekday, from: $0) })
        
        var newMedicationSchedule = medicationSchedule
        
        for i in 0..<newMedicationSchedule.count {
            
            if interactions.contains(newMedicationSchedule[i].medicine.name){
                
                let weekDays = Set(newMedicationSchedule[i].times.map { Calendar.current.component(.weekday, from: $0) })
                let commonWeekdays = newWeekdays.intersection(weekDays)
                if !commonWeekdays.isEmpty {
                    
                    for k in 0..<newMedicationSchedule[i].times.count{
                        
                        
                        let weekday = Calendar.current.component(.weekday, from: newMedicationSchedule[i].times[k])
                        if commonWeekdays.contains(weekday) {
                            
                            let oldTime = newMedicationSchedule[i].times[k]
                            let oldHour = Calendar.current.component(.hour, from: oldTime)
                            
                            let newHour = Calendar.current.component(.hour, from: newMedicationSchedule[i].times[k])
                            
                            // Aktualizacja powiadomień dla zmienionego czasu
                            updateNotificationTime(forMedicineName: newMedicationSchedule[i].medicine.name, onDayOfWeek: weekday, currentHour: oldHour, newHour: newHour)
                        
                        
                            newMedicationSchedule[i].times[k] = newMedicationSchedule[i].times[k] .addingTimeInterval(delay * 3600)
                        
                    }
                }
                
                
            }
            
            
        }
        
    }
    
    medicationSchedule = newMedicationSchedule
}




func setDelayMedsForMatchingWeekdays(newDelayMeds: Double, newMedicationEntry: MedicationEntry) {
    // Sprawdź dni tygodnia dla nowego leku
    let newWeekdays = Set(newMedicationEntry.times.map { Calendar.current.component(.weekday, from: $0) })
    
    for medicationEntry in medicationSchedule {
        // Sprawdź dni tygodnia dla istniejącego leku
        let weekdays = Set(medicationEntry.times.map { Calendar.current.component(.weekday, from: $0) })
        
        // Jeśli istnieje przynajmniej jeden wspólny dzień tygodnia
        if !newWeekdays.isDisjoint(with: weekdays) {
            medicationEntry.medicine.delayMeds = Int(newDelayMeds)
        }
    }
}



func updateDaleyMeds(delay: Int){
    
    
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

func getMedicationEntry(for medicine: Medicine) -> MedicationEntry? {
    return medicationSchedule.first { $0.medicine.uid == medicine.uid }
}

}



