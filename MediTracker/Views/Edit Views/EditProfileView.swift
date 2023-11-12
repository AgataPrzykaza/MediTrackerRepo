//
//  EditProfileView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 09/11/2023.
//

import SwiftUI

struct EditProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var rodzajProfilu = "Profil"
    
    @State var imie = "Ola"
    var nazwisko = "ko"
    var plec = "men"
    var haslo = "asa"
    
    var body: some View {
        
        VStack{
            
            HStack(alignment: .top,spacing: 30){
                Button(action: {
                   dismiss()
                }) {
                   Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .font(.system(size: 30))
                        .frame(alignment: .top)
                }
                .padding()
                
                Text("Edytuj \(rodzajProfilu)")
                    .font(.system(size: 25))
                    .padding()
                
                Button(action: {
                   
                }) {
                   Text("Zapisz")
                        .font(.system(size: 20))
                        .foregroundStyle(K.BrandColors.darkPink1)
                }
                .padding()

            }
            .padding()
            
            
//MARK: - Formularz do zmiany danych
            VStack{
                Text("Imie")
                    .frame(width: 300,alignment: .leading)
                    .foregroundColor(K.BrandColors.intensePink2)
                    .font(.system(size: 23))
                TextField(imie, text: $imie)
                    .frame(width: 300,height: 40)
                    .font(.system(size: 23))
                    .autocorrectionDisabled()
                    .onSubmit {
                        
                    }
                
                Text("Nazwisko")
                    .frame(width: 300,alignment: .leading)
                    .foregroundColor(K.BrandColors.intensePink2)
                    .font(.system(size: 23))
                TextField(nazwisko, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .frame(width: 300,height: 40)
                    .font(.system(size: 23))
                    .autocorrectionDisabled()
                    .onSubmit {
                        
                    }
                
                
                
                Text("Płeć")
                    .frame(width: 300,alignment: .leading)
                    .foregroundColor(K.BrandColors.intensePink2)
                    .font(.system(size: 23))
                TextField(plec, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .frame(width: 300,height: 40)
                    .font(.system(size: 23))
                    .autocorrectionDisabled()
                    .onSubmit {
                        
                    }
                
                
                
            }
            Spacer()
        }
        .frame(width: 500,height: .infinity,alignment: .top)
        .navigationBarBackButtonHidden()
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    EditProfileView()
}
