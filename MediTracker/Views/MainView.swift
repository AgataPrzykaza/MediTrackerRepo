//
//  MainView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 30/10/2023.
//

import SwiftUI

struct MainView: View {
    
    
    
    var body: some View {
        VStack{
            Text(getCurrentDateInWords())
            HeadingView()
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(K.BrandColors.lightPink1)
        
        
    }
    
    //Funkcja do dzisiejszej daty
    func getCurrentDateInWords() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pl_PL") // Ustawienie lokalizacji na język polski
        dateFormatter.dateFormat = "d MMMM" // Format daty bez roku
        return dateFormatter.string(from: currentDate)
    }
}

#Preview {
    MainView()
}

//Nagłówek do grupy leków
struct HeadingView: View {
    var time = "10.00"
    var shouldShowButton = true

    var body: some View {
        HStack {
            Spacer()
            Text(time)
            Spacer()
            if shouldShowButton {
                Button("Oznacz wszystkie") {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }
                .padding()
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
            }
        }
    }
}

