//
//  Medication.swift
//  MediTracker
//
//  Created by Agata Przykaza on 05/11/2023.
//

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
                
                Text("\(String(format: "%.2f",medication.dosage))\(medication.unit) \(medication.type)")
                    .frame(width: 300,alignment: .leading)
                
                
                
            }
           
            
        
       
      
    }
}

//funkcja ktora daje odpowieni napis w zaleznosci od rodzaju przyjmowanego leku np czy 1, 200mg
func ChangeUnit() -> Void{
    
}

//#Preview {
//    Medication(medication: Medicine(name: "Omega", time: "12.00", quantity: 1.5, type: "tabletka"))
//}
