//
//  ContentView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 23/10/2023.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        
        VStack {
            
            //Logo aplikcji
            Image("meditrackerLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .shadow(radius: 7)
                .clipShape(Circle())
                .offset(y:-140)
            //Nazwa aplikacji
            Text("MediTracker")
                .font(.largeTitle)
                .foregroundColor(Color.pink)
                .offset(y:-120)
                .bold()
                
            //grupa przyciskow
            VStack(spacing:20) {
                //Przycisk logowania
                Button("Zaloguj się") {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }
                .padding()
                .frame(minWidth: 0, maxWidth: 200)
                .background(Color.pink)
                .foregroundStyle(.white)
                .cornerRadius(24)
                
                //Przycisk rejestracji
                Button("Zarejestruj się") {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }
                .padding()
                .frame(minWidth: 0, maxWidth: 200)
                .background(Color.purple)
                .foregroundStyle(.white)
                .cornerRadius(24)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("mycolor"))
        .ignoresSafeArea()
        
        
    }
        
}

#Preview {
    WelcomeView()
}
