//
//  MenuContet.swift
//  MediTracker
//
//  Created by Agata Przykaza on 01/11/2023.
//

import SwiftUI
import FirebaseAuth

struct MenuContent: View{
    
    
    @ObservedObject var manager: UserManager
    
    
    
    @State var nameUser:String = ""
    @State var profilePerson: String = ""
    @State private var isShowingEditProfile = false
    
    
    var body: some View {
        ZStack(alignment: .top){
            Color(K.BrandColors.pink1)
                .cornerRadius(30)
            
            
            
            
            
            
            ScrollView{
                
                VStack(alignment: .leading,spacing: 0){
                    
                    //MARK: - Profil główny oraz mozliwosc edycji
                    HStack(){
                        
                        
                        MiniProfileView(nameUser: manager.currentProfileSelected?.name ?? "brak", profilePictureType: manager.currentProfileSelected?.pictureType ?? "Inne" )
                        Spacer()
                    }
                    .padding(.horizontal,20)
                    
                    
                    
                    NavigationLink(destination: EditProfileView(manager: manager)) {
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
                    
                 
                    ProfileList(manager: manager, profiles: manager.listOfProfiles)
                    .padding(.bottom, 100)
                    
                    
                    
                    
                    
                    
                    //MARK: - Mozliwosc wylogowania
                    Spacer()

                    Button(action: {
                        manager.logout()
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


