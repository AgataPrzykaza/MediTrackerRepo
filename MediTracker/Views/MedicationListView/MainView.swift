//
//  MainView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 30/10/2023.
//

import SwiftUI

struct MainView: View {
    
    var tabTMP = [
        Medicine(name: "Omega", time: "12.00", quantity: 1.5, type: "tabletka"),
        Medicine(name: "Vitamin C", time: "8.00", quantity: 1, type: "tabletka"),
        Medicine(name: "Paracetamol", time: "10.00", quantity: 2, type: "tabletka"),
        // Dodaj więcej leków według potrzeb
    ]
    var time = "12.00"
    
    var body: some View {
        
        ScrollView{
        
            
            VStack{
                Text(getCurrentDateInWords())
                    .font(.system(size: 30))
                    .foregroundColor(K.BrandColors.darkPink2)
                    .padding()
                HeadingView(time: time, medicine: tabTMP)
                
                
            }
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.bottom)
            .background(K.BrandColors.lightPink1)
        
    }
    
    
    
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
    MainView()
}

//MARK: - Lista leków na dany dzień
//Nagłówek do grupy leków
struct HeadingView: View {
    var time : String
    var medicine: [Medicine]
    
    
    var body: some View {
        
        MedicationListView(medications: medicine, time: time)
        MedicationListView(medications: medicine, time: "18.00")
        //MedicationListView(medications: medicine, time: time)
       // MedicationListView(medications: medicine, time: time)
        
        
    }
}

