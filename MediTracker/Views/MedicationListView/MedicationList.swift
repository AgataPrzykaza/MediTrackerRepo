//
//  MedicationList.swift
//  MediTracker
//
//  Created by Agata Przykaza on 05/11/2023.
//

import SwiftUI

struct MedicationListView: View {
    var medications: [Medicine]
    var time: String
    
    var body: some View {
        
        HStack {
            Text("\(time)")
                .frame(width: 100,alignment: .leading)
                .bold()
                .font(.system(size: 30))
                .padding(.horizontal,50)
            
            //przycisk do odznaczenie wszystkich tabeltek na danej godzinie
            Button(action: {
                
            }){
                
                Text("Oznacz wszystkie")
                    .frame(width: 200)
                    .foregroundColor(K.BrandColors.intensePink1)
            }
        }
        
        //lista lekow na dan godzine
        ForEach(medications,id: \.id) {  medication in
            
            //lek jako przycisk 
            Button(action: {
                
                
               
                
            }) {
                Medication(medication: medication)
                    .padding(.bottom,5)
            }
           
        }
    }
}

#Preview {
    MedicationListView(medications: [
        Medicine(name: "Omega", time: "12.00", quantity: 1.5, type: "tabletka"),
        Medicine(name: "Vitamin C", time: "8.00", quantity: 1, type: "tabletka"),
        Medicine(name: "Paracetamol", time: "10.00", quantity: 2, type: "tabletka"),
        // Dodaj więcej leków według potrzeb
    ],time: "10.00")
}

