//
//  MenuContet.swift
//  MediTracker
//
//  Created by Agata Przykaza on 01/11/2023.
//

import SwiftUI
import FirebaseAuth

struct MenuContent: View{
    
    
    @ObservedObject var userAuth: UserAuthManager
    
    var nameUser:String
    var profilePerson: String
    @State private var isShowingEditProfile = false
  
    
    var body: some View {
        ZStack(alignment: .top){
            Color(K.BrandColors.pink1)
                .cornerRadius(30)
            
            
            
            
            
            
            ScrollView{
                
                VStack(alignment: .leading,spacing: 0){
                    
                    //MARK: - Profil główny oraz mozliwosc edycji
                    HStack(){
                        MiniProfileView(nameUser: nameUser, profilePictureType: profilePerson )
                        Spacer()
                    }
                    .padding(.horizontal,20)
                    
                    
                    
                    NavigationLink(destination: EditProfileView()) {
                        HStack {
                            Spacer()
                            Text("Edytuj profil")
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 50)
                    }
                    .padding(.bottom, 30)
                    .navigationBarBackButtonHidden()
                    
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

                    Button(action: {
                        userAuth.logout()
                                }) {
                                    HStack {
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                            .foregroundColor(.white)
                                            .font(.system(size: 24))
                                            .padding(.trailing, 10)
                                        
                                        Text("Wyloguj się")
                                            .foregroundColor(.white)
                                            .font(.system(size: 24))
                                    }
                                    .padding(.leading, 30)
                                }
                    
                    
                }
                
                
                .padding(.top,60)
            }
            
        }
        
        
        
    }
    
 
}


