//
//  ProfileList.swift
//  MediTracker
//
//  Created by Agata Przykaza on 05/11/2023.
//
// Widok listy profili użytkownika
import SwiftUI

struct ProfileList: View {
    
    @ObservedObject var manager: UserManager
    var profiles: [Profile]
   
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("TWOJE PROFILE")
                .bold()
                .foregroundColor(.white)
                .padding(.bottom,20)
            
            
            ForEach(profiles, id: \.id) { profile in
                Button(action: {
                   
                    manager.selectProfile(newProfile: profile)
                }, label: {
                    MiniProfileView(nameUser: profile.name, profilePictureType: profile.pictureType)
                    
                })
            }
            
            NavigationLink(destination: AddProfileView( manager: manager )) {
                HStack {
                    Spacer()
                    Image(systemName: "plus")
                        .tint(.white)
                    Text("Dodaj profil")
                        .foregroundColor(.white)
                }
                .padding(.leading, 70)
            }
        }
        .padding(.horizontal, 20)
    }
}


//#Preview {
//    ProfileList(profiles: [
//        //        Profile(name: "John Doe", pictureType: "Kobieta"),
//        //        Profile(name: "Jane Smith", pictureType: "pet"),
//        // ... Dodaj więcej profili
//    ], addProfileAction: {})
//}
