//
//  MainView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 27/10/2023.
//

import SwiftUI


struct MenuView: View {
    
    let nameUser = "ALA"
    let profilePerson = "man"
    
    @State var menuOpened = false
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                //MARK: - deklaracja dolnego panelu nawigacyjnego - menu
                TabView {
                    MainView()
                        .tabItem {
                            VStack {
                                Image(systemName: "house")
                                    .foregroundColor(.white) // Ustawianie koloru dla pierwszego symbolu
                                Text("Ekran główny")
                                    .foregroundColor(.white) // Ustawianie koloru dla tekstu
                            }
                        }
                    ListOfDrugsView()
                        .tabItem {
                            VStack {
                                Image(systemName: "pills")
                                    .foregroundColor(.white) // Ustawianie koloru dla drugiego symbolu
                                Text("Leki")
                                    .foregroundColor(.white) // Ustawianie koloru dla tekstu
                            }
                        }
                }
                .accentColor(K.BrandColors.darkPink2) // Ustawianie koloru akcentu dla całej TabView

                
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [K.BrandColors.lightPink1, K.BrandColors.lightPink2]), startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea()
            .toolbar {
                
                //MARK: - panel nawigacyjny górny
                //deklaracja miniaturki
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        // Tutaj umieść akcję do wykonania po kliknięciu
                    }) {
                        HStack{
                            MiniProfileView(nameUser: nameUser, profilePictureType: profilePerson)
                        }
                        .padding(.top)
                    }
                    
                }
                
                //deklaracja przycisku ustawien
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button {
                        
                        
                        
                    } label: {
                        HStack {
                            
                            Image(systemName: "gearshape")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(K.BrandColors.darkerPink)
                                .frame(width: 40, height: 40)
                            
                            
                            
                        }
                    }
                }
            }
            
            
            
            
            
            
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
    
}

struct Tab1View: View {
    var body: some View {
        Text("Pierwsza zakładka")
    }
}
//MARK: - Subview do wyswietlenie miniaturki profilu

struct MiniProfileView: View {
    
    var nameUser : String
    var profilePictureType : String
    
    var body: some View {
        
        HStack{
            Image(profilePictureType)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
                .shadow(radius: 7)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.gray, lineWidth: 2)
                )
            
            Text(nameUser)
                .font(.system(size: 27))
                .bold()
                .foregroundColor(K.BrandColors.darkPink1)
            
            Image(systemName: "chevron.down")
            
            
            
        }
        
    }
    
    
}

#Preview {
    MenuView()
}
