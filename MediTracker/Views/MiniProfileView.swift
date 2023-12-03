//
//  MiniProfileView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 01/11/2023.
//

import SwiftUI

//MARK: - Subview do wyswietlenie miniaturki profilu
struct MiniProfileView: View {
    var nameUser : String
    var profilePictureType : String
    
    var body: some View {
        
        HStack{
            Image(profilePictureType)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 43)
                .shadow(radius: 7)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.gray, lineWidth: 2)
                )
            
            Text(nameUser)
                .font(.system(size: 21))
                .bold()
                .foregroundColor(K.BrandColors.darkPink2)
            
            
            
            
            
        }
        
    }
}

