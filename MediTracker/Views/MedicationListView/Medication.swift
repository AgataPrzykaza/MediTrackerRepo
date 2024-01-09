//
//  Medication.swift
//  MediTracker
//
//  Created by Agata Przykaza on 05/11/2023.
//
// Mini widok reprezentujacy pojedynczy lek w harmonogramie

import SwiftUI

struct Medication: View {
    
    var medication: Medicine
 

    var body: some View {
        
      
            VStack{
              
                //nazwa leku
                
                Text(medication.name)
                    .bold()
                    .font(.system(size: 25))
                    .foregroundColor(K.BrandColors.intensePink1)
                    .frame(width: 300,alignment: .leading)
                   
                
                //ilosc do przyjęcia
                
                Text("\(checkNumber(medication.dosage)) \(medication.unit) \(medication.type)")
                    .frame(width: 300,alignment: .leading)
                
                
                
            }
           
            
        
       
      
    }
}

func checkNumber(_ liczba: Double) -> String {
    if liczba.truncatingRemainder(dividingBy: 1) != 0 {
        return String(format: "%.2f", liczba) // Z dwoma miejscami po przecinku
    } else {
        return String(Int(liczba)) // Bez przecinka
    }
}


//#Preview {
//    Medication(medication: Medicine(name: "Omega", time: "12.00", quantity: 1.5, type: "tabletka"))
//}
