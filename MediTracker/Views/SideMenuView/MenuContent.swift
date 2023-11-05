//
//  MenuContet.swift
//  MediTracker
//
//  Created by Agata Przykaza on 01/11/2023.
//

import SwiftUI

struct MenuContent: View{
    
    var nameUser:String
    var profilePerson: String
    
    
    var body: some View {
        ZStack(alignment: .top){
            Color(K.BrandColors.intensePink1)
                .cornerRadius(30)
            
            ScrollView{
                
                VStack(alignment: .leading,spacing: 0){
                    
                    //MARK: - Profil główny oraz mozliwosc edycji
                    HStack(){
                        MiniProfileView(nameUser: nameUser, profilePictureType: profilePerson )
                        Spacer()
                    }
                    .padding(.horizontal,20)
                    
                    HStack{
                        
                        Spacer()
                        Button(action: {
                            // Tutaj dodaj akcję dla przycisku
                        }, label: {
                            Text("Edytuj profil")
                                .foregroundColor(.white)
                        })
                        .padding(.trailing,50)
                    }
                    .padding(.bottom,30)
                    
                    Divider()
                        .background(Color.white)
                        .padding(.bottom, 15)
                    
                    
                    //MARK: - Profile pozostale
                    
                    
                    ProfileList(profiles: [
                        Profile(name: "John Doe", pictureType: "man"),
                        Profile(name: "Jane Smith", pictureType: "woman"),
                        Profile(name: "Jane Kate", pictureType: "woman"),
                        // ... Dodaj więcej profili
                    ], addProfileAction: {
                        // Akcja do dodawania nowego profilu
                    })
                    .padding(.bottom, 100)
                    
                    
                    
                    
                    
                    
                    //MARK: - Mozliwosc wylogowania
                    Spacer()
                    HStack{
                        
                        Button(action: {
                            // Tutaj dodaj akcję dla przycisku wylogowania
                        }, label: {
                            HStack{
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                                    .padding(.trailing,10)
                                
                                
                                Text("Wyloguj się")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                            }
                            .padding(.leading,30)
                        })
                        
                    }
                    
                    
                }
                .padding(.top,60)
            }
            
        }
        
        
        
    }
}


