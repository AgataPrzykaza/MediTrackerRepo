//
//  MedicationList.swift
//  MediTracker
//
//  Created by Agata Przykaza on 05/11/2023.
//

import SwiftUI

struct MedicationListView: View {
    @ObservedObject var manager: UserManager
    
    var medications: [Medicine]
    var time: String
    @State private var medicationTakenStates: [String: Bool] = [:]
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        
        HStack {
            Text("\(time)")
                .frame(width: 100,alignment: .leading)
                .bold()
                .font(.system(size: 30))
                .padding(.horizontal,50)
            
            //przycisk do odznaczenie wszystkich tabeltek na danej godzinie
            Button(action: {
                markAllMedicationsAsTaken()
            }){
                
                Text("Oznacz wszystkie")
                    .frame(width: 200)
                    .foregroundColor(K.BrandColors.intensePink1)
            }
        }
        
        ForEach(medications, id: \.uid) { medication in
            Button(action: {
                let scheduledTime = createDateWithTodayDateAndTimeString(timeString: time)!
                let key = "\(medication.uid)-\(scheduledTime)"
                
                if !(self.medicationTakenStates[key] ?? false) {
                    manager.profilemanager.medHistoryManager.addMedicationHistoryEntry(
                        profileId: manager.currentProfileSelected?.uid ?? "",
                        medicationId: medication.uid,
                        scheduledTime: scheduledTime,
                        actualTimeTaken: Date()) { error in
                            if error != nil {
                                alertMessage = "Wystąpił problem przy zapisie przyjęcia leku."
                            } else {
                                self.medicationTakenStates[key] = true
                                alertMessage = "Lek \(medication.name) został zażyty."
                                manager.currentProfileSelected?.removeNotification(forMedicineName: medication.name,
                                                                                   onDayOfWeek: Calendar.current.component(.weekday, from: createDateWithTodayDateAndTimeString(timeString: time)!),
                                                                                   atHour: Calendar.current.component(.hour, from: createDateWithTodayDateAndTimeString(timeString: time)!))
                            }
                            showAlert = true
                        }
                } else {
                    alertMessage = "Lek \(medication.name) został już zażyty."
                    showAlert = true
                }
            }) {
                Medication(medication: medication)
                    .opacity(self.medicationTakenStates["\(medication.uid)-\(createDateWithTodayDateAndTimeString(timeString: time)!)"] ?? false ? 0.25 : 1.0)
            }
        }
        .onAppear {
            
            for medication in medications {
                    let scheduledTime = createDateWithTodayDateAndTimeString(timeString: time)!
                    let key = "\(medication.uid)-\(scheduledTime)"

                    manager.profilemanager.medHistoryManager.isMedicationTaken(
                        profileId: manager.currentProfileSelected?.uid ?? "",
                        medicationId: medication.uid,
                        at: scheduledTime) { isTaken in
                            self.medicationTakenStates[key] = isTaken
                        }
                }
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Informacja"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    
    func markAllMedicationsAsTaken() {
        let scheduledTime = createDateWithTodayDateAndTimeString(timeString: time)!

        for medication in medications {
            let key = "\(medication.uid)-\(scheduledTime)"
            // Sprawdzenie, czy lek nie został już oznaczony jako zażyty
            if !(self.medicationTakenStates[key] ?? false) {
                manager.profilemanager.medHistoryManager.addMedicationHistoryEntry(
                    profileId: manager.currentProfileSelected?.uid ?? "",
                    medicationId: medication.uid,
                    scheduledTime: scheduledTime,
                    actualTimeTaken: Date()) { error in
                        if error == nil {
                            self.medicationTakenStates[key] = true
                        }
                    }
            }
        }
    }
}






func createDateWithTodayDateAndTimeString(timeString: String) -> Date? {
    // Ustawienie formatu daty
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    // Pobranie dzisiejszej daty jako String
    let todayDateString = dateFormatter.string(from: Date())
    
    // Połączenie dzisiejszej daty z podanym czasem
    let dateTimeString = "\(todayDateString) \(timeString)"
    
    // Ustawienie odpowiedniego formatu dla DateFormatter
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    
    // Konwersja stringa na Date
    return dateFormatter.date(from: dateTimeString)
}
