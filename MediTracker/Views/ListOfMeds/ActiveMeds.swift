//
//  ActiveMeds.swift
//  MediTracker
//
//  Created by Agata Przykaza on 11/11/2023.
//

import SwiftUI

struct ActiveMeds: View {
    
    @ObservedObject var manager: UserManager
    
   
    
    var body: some View {
        
        VStack{
            
            HStack{
                
                Text("Aktywne leki")
                //lista lekow na dan godzine
                    .padding()
                
                NavigationLink(destination: AddMedicineView(manager: manager)) {
                    Text("Dodaj lek")
                        .frame(width: 100, height: 45)
                        .foregroundColor(.white)
                        .background(K.BrandColors.darkPink2)
                        .cornerRadius(15)
                        .navigationBarHidden(true)
                    
                }
                
                
                
                .padding()
            }
            
            
            
            ScrollView{
                
                ForEach(manager.currentProfileSelected?.getMedsList() ?? [],id: \.uid) {  medication in
                    
                    NavigationLink(destination: MedDetailsView( medicationEntry: (manager.currentProfileSelected?.getMedicationEntry(for: medication))!, manager: manager)){
                        
                        Medication(medication: medication)
                            .padding(.bottom,5)
                    }
                    
                    
                    
                }
                
            }
            
            
            
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(K.BrandColors.Beige)
       
        
        
        
        
        
    }
    
    
}

#Preview {
    ActiveMeds(manager: UserManager())
}


