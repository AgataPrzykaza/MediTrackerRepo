//
//  MainView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 30/10/2023.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var manager: UserManager
   


    private var groupedMedications: [String: [Medicine]] {
          groupMedicationsByTime(manager: manager)
      }
    var time = "12.00"
    
    var body: some View {
        
        ScrollView{
        
            
            VStack{
                Text(getCurrentDateInWords())
                    .font(.system(size: 30))
                    .foregroundColor(K.BrandColors.darkPink2)
                    .padding()
                
//                ForEach(manager.currentProfileSelected?.medicationSchedule.indices ?? 0..<0, id: \.self) { index in
//                    let entry = manager.currentProfileSelected?.medicationSchedule[index]
//                    if let times = entry?.times, !times.isEmpty {
//                        HeadingView(time: calculateHour(time: times[0]), medicine: [entry?.medicine].compactMap { $0 })
//                    }
             ForEach(groupedMedications.keys.sorted(), id: \.self) { time in
                let medicines = groupedMedications[time] ?? []
                 HeadingView(manager: manager, scheduledTime: time, medicine: medicines)
            }


              
                
                
            }
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.bottom)
            .background(K.BrandColors.lightPink1)
        
    }
    
    
    
}


func calculateHour(time: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: time)
}


//Funkcja do dzisiejszej daty
func getCurrentDateInWords() -> String {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "pl_PL") // Ustawienie lokalizacji na język polski
    dateFormatter.dateFormat = "d MMMM" // Format daty bez roku
    return dateFormatter.string(from: currentDate)
}

#Preview {
    MainView(manager: UserManager())
}

func groupMedicationsByTime(manager: UserManager) -> [String: [Medicine]] {
    var groupedMedications: [String: [Medicine]] = [:]
    let today = Date() // Bieżąca data

    for entry in manager.currentProfileSelected?.medicationSchedule ?? [] {
        for time in entry.times {
            // Sprawdź, czy dana data przypada na bieżący dzień tygodnia
            if isSameDayOfWeek(time, as: today) {
                let timeString = calculateHour(time: time)
                if groupedMedications[timeString] == nil {
                    groupedMedications[timeString] = []
                }
                groupedMedications[timeString]?.append(entry.medicine)
            }
        }
    }
    
    return groupedMedications
}


func isSameDayOfWeek(_ date: Date, as referenceDate: Date) -> Bool {
    let calendar = Calendar.current
    let dayOfWeek = calendar.component(.weekday, from: date)
    let referenceDayOfWeek = calendar.component(.weekday, from: referenceDate)
    return dayOfWeek == referenceDayOfWeek
}


//MARK: - Lista leków na dany dzień
//Nagłówek do grupy leków
struct HeadingView: View {
    @ObservedObject var manager: UserManager
    var scheduledTime : String
    var medicine: [Medicine]
    
    
    var body: some View {
        
        MedicationListView(manager: manager, medications: medicine, time:scheduledTime)
       
        
        
    }
}

