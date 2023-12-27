//
//  EditProfileView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 09/11/2023.
//

import SwiftUI

struct EditProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var manager: UserManager
    
    
    var rodzajProfilu = "Profil"
    
    @State var name = ""
    @State var surname = ""
    
    @State private var selectedType: String = "Mężczyzna"
    let types = ["Mężczyzna", "Kobieta", "Inne","Zwierze"]
    
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
                    
                    
                    updateCurrentProfile()
                    
                    manager.profilemanager.updateProfile(profile: manager.currentProfileSelected!) { error in
                        if let error = error {
                            print("Błąd aktualizacji danych profilu: \(error.localizedDescription)")
                        } else {
                            print("Dane profilu zaktualizowane pomyślnie!")
                            
                        }
                    }

                    dismiss()
                    
                  }
                    
                  
                ) {
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
                TextField("Imie", text: $name)
                    .frame(width: 300,height: 40)
                    .font(.system(size: 23))
                    .autocorrectionDisabled()
                    .onSubmit {
                        
                    }
                
                Text("Nazwisko")
                    .frame(width: 300,alignment: .leading)
                    .foregroundColor(K.BrandColors.intensePink2)
                    .font(.system(size: 23))
                TextField("Nazwisko", text: $surname)
                    .frame(width: 300,height: 40)
                    .font(.system(size: 23))
                    .autocorrectionDisabled()
                    .onSubmit {
                        
                    }
                
                
                
                Text("Osoba lub zwierze")
                    .frame(width: 300,alignment: .leading)
                    .foregroundColor(K.BrandColors.intensePink2)
                    .font(.system(size: 23))
                
                Picker("Płeć", selection: $selectedType) {
                    ForEach(types, id: \.self) { gender in
                        Text(gender).tag(gender)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width:300)
               
                
                
                
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onAppear(){
            var userData = loadData(manager: manager)
            name = userData.0
            surname = userData.1
            selectedType = userData.2
        }
    }

   
    
    func updateCurrentProfile(){
        manager.currentProfileSelected?.updateName(name)
        manager.currentProfileSelected?.updateSurname(surname)
        manager.currentProfileSelected?.updatepictureType(selectedType)
        
        manager.fetchUserData()
        
    }
}

func loadData(manager: UserManager) -> (String,String,String){
    
    var name = manager.currentProfileSelected?.name ?? "Brak"
    var surname = manager.currentProfileSelected?.surname ?? "Brak"
    var gender = manager.currentProfileSelected?.pictureType ?? "Brak"
    
    return (name,surname,gender)
}


#Preview {
    EditProfileView(manager: UserManager())
}
