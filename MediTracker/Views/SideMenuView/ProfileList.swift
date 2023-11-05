//
//  ProfileList.swift
//  MediTracker
//
//  Created by Agata Przykaza on 05/11/2023.
//

import SwiftUI

struct ProfileList: View {
    var profiles: [Profile]
    var addProfileAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("TWOJE PROFILE")
                .bold()
                .foregroundColor(.white)
                .padding(.bottom,20)
            
            
            ForEach(profiles, id: \.id) { profile in
                Button(action: {
                    // Tutaj dodaj akcję dla przycisku
                }, label: {
                    MiniProfileView(nameUser: profile.name, profilePictureType: profile.pictureType)
                        
                })
            }
            Button(action: addProfileAction, label: {
                Spacer()
                Image(systemName: "plus")
                    .tint(.white)
                
                Text("Dodaj profil")
                    .foregroundColor(.white)
            })
            .padding(.leading, 70)
        }
        .padding(.horizontal, 20)
    }
}


#Preview {
    ProfileList(profiles: [
        Profile(name: "John Doe", pictureType: "man"),
        Profile(name: "Jane Smith", pictureType: "woman"),
        // ... Dodaj więcej profili
    ], addProfileAction: {})
}
