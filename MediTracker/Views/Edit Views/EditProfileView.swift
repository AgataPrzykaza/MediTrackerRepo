//
//  EditProfileView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 09/11/2023.
//

import SwiftUI

struct EditProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var userAuth: UserManager
    
    
    var rodzajProfilu = "Profil"
    
    @State var name = "Ola"
    @State var surname = ""
    
    @State private var selectedGender: String = "Mężczyzna"
    let genders = ["Mężczyzna", "Kobieta", "Inne"]
    
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
                    
                    updateUserData()
                    userAuth.updateUser(user: userAuth.currentUser!) { error in
                            if let error = error {
                                print("Błąd aktualizacji danych użytkownika: \(error.localizedDescription)")
                            } else {
                                print("Dane użytkownika zaktualizowane pomyślnie!")
                                
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
                
                
                
                Text("Płeć")
                    .frame(width: 300,alignment: .leading)
                    .foregroundColor(K.BrandColors.intensePink2)
                    .font(.system(size: 23))
                
                Picker("Płeć", selection: $selectedGender) {
                    ForEach(genders, id: \.self) { gender in
                        Text(gender).tag(gender)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width:300)
               
                
                
                
            }
            Spacer()
        }
        .frame(width: 500,height: 800,alignment: .top)
        .navigationBarBackButtonHidden()
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onAppear(){
            var userData = loadData(userAuth: userAuth)
            name = userData.0
            surname = userData.1
            selectedGender = userData.2
        }
    }

    func updateUserData(){
        userAuth.currentUser?.updateName(name)
        userAuth.currentUser?.updateSurname(surname)
        userAuth.currentUser?.updateGender(selectedGender)
    }
    
}

func loadData(userAuth: UserManager) -> (String,String,String){
    
    var name = userAuth.currentUser?.name ?? "Brak"
    var surname = userAuth.currentUser?.surname ?? "Brak"
    var gender = userAuth.currentUser?.gender ?? "Brak"
    
    return (name,surname,gender)
}


#Preview {
    EditProfileView(userAuth: UserManager())
}
