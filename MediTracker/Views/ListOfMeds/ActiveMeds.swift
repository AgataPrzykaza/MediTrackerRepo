//
//  ActiveMeds.swift
//  MediTracker
//
//  Created by Agata Przykaza on 11/11/2023.
//

import SwiftUI

struct ActiveMeds: View {
    
    var list: [Medicine]? = [
        Medicine(name: "Omega", time: "12.00", quantity: 1.5, type: "tabletka"),
        Medicine(name: "Vitamin C", time: "8.00", quantity: 1, type: "tabletka"),
        Medicine(name: "Paracetamol", time: "10.00", quantity: 2, type: "tabletka"),
        // Dodaj więcej leków według potrzeb
    ]
    var body: some View {
        
        VStack{
            
            NavigationView{
            ScrollView{
                Text("Aktywne leki")
                    //lista lekow na dan godzine
                    ForEach(list!,id: \.id) {  medication in
                        
                        NavigationLink(destination: EditMedicine()){
                            
                            Medication(medication: medication)
                                .padding(.bottom,5)
                        }
                        
                        //lek jako przycisk
                        Button(action: {
                            
                            
                            
                            
                        }) {
                            Medication(medication: medication)
                                .padding(.bottom,5)
                        }
                        
                    }
                }
            }
            .navigationBarBackButtonHidden()
            //lek jako przycisk
            Button(action: {
                
                
               
                
            }) {
                Text("Dodaj lek")
                    .frame(width: 200,height: 45)
                    .foregroundColor(.white)
                    .background(K.BrandColors.darkPink2)
                    .cornerRadius(15)
            }
        }
    }
}

#Preview {
    ActiveMeds()
}
