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
        ForEach(medications,id: \.uid) {  medication in
            
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
    MedicationListView(medications:[
        Medicine(
           
            name: "Paracetamol",
            dosage: 500,
            unit: "mg",
            type: "tabletka",
            hourPeriod: 6,
            frequency: 4,
            startHour: Date(),  // Możesz dostosować tę datę
            onEmptyStomach: false,
            delayMeds: 0, // Przykładowa wartość, dostosuj według potrzeb
            instructions: "Take with water",  // Dostosuj według potrzeb
            interactions: ["Ibuprofen"],
            reminder: true,
            isAntibiotic: false
        ),

        // Dodaj więcej leków według potrzeb
        // Na przykład:
        Medicine(
          
            name: "Ibuprofen",
            dosage: 200,
            unit: "mg",
            type: "tabletka",
            hourPeriod: 8,
            
            frequency: 3,
            startHour: Date(),  // Możesz dostosować tę datę
            onEmptyStomach: true,
            delayMeds: 0, // Przykładowa wartość, dostosuj według potrzeb
            instructions: "Take after eating",  // Dostosuj według potrzeb
            interactions: ["Paracetamol"],
            reminder: true,
            isAntibiotic: false
        )

        // Możesz kontynuować dodawanie
],time: "10.00")
}

