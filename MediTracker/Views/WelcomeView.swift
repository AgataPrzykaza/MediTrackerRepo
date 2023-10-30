//
//  ContentView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 23/10/2023.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        
        //Widok do uzycia przejscia do kolejnego widoku
        NavigationView {
            VStack {
                //Logo aplikcji
                Image("meditrackerLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .shadow(radius: 7)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(K.BrandColors.intensePink2, lineWidth: 6)
                    )
                    .offset(y: -100)

                //Nazwa aplikacji
                Text("MediTracker")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundColor(K.BrandColors.intensePink2)
                    .offset(y: -80)

                //grupa przyciskow
                VStack(spacing: 20) {
                    //Przycisk logowania
                    Button("Zaloguj się") {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    }
                    .padding()
                    .font(.system(size: 27, weight: .bold))
                    .frame(minWidth: 0, maxWidth: 200)
                    .background(K.BrandColors.pink2)
                    .foregroundStyle(.white)
                    .cornerRadius(24)

                    //Przycisk rejestracji
                    NavigationLink(destination: RegisterView()) {
                        Text("Zarejestruj się")
                            .padding()
                            .font(.system(size: 27, weight: .bold))
                            .frame(minWidth: 0, maxWidth: 250)
                            .background(K.BrandColors.intensePink2)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                    }
                }

            }
            .navigationBarBackButtonHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [K.BrandColors.lightPink2, K.BrandColors.pink2]), startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea()
            
            
        }
     

        
    }
        
}

#Preview {
    WelcomeView()
}
