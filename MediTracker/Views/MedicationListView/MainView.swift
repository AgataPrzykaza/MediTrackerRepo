//
//  MainView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 30/10/2023.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var manager: UserManager
   
   
    
    var time = "12.00"
    
    var body: some View {
        
        ScrollView{
        
            
            VStack{
                Text(getCurrentDateInWords())
                    .font(.system(size: 30))
                    .foregroundColor(K.BrandColors.darkPink2)
                    .padding()
                
                ForEach(manager.currentProfileSelected?.medicationSchedule.indices ?? 0..<0, id: \.self) { index in
                    let entry = manager.currentProfileSelected?.medicationSchedule[index]
                    if let times = entry?.times, !times.isEmpty {
                        HeadingView(time: calculateHour(time: times[0]), medicine: [entry?.medicine].compactMap { $0 })
                    }
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

//MARK: - Lista leków na dany dzień
//Nagłówek do grupy leków
struct HeadingView: View {
    var time : String
    var medicine: [Medicine]
    
    
    var body: some View {
        
        MedicationListView(medications: medicine, time: time)
       
        
        
    }
}

