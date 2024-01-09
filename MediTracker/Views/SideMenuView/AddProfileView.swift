//
//  AddProfile.swift
//  MediTracker
//
//  Created by Agata Przykaza on 27/11/2023.
//
//  Widok dodania nowego profilu

import SwiftUI

struct AddProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var manager: UserManager
    
    var profileManager = ProfileManager()
    
    @State var showAlert = false
    @State var alertText = ""
    
    @State var name = ""
    @State var surname = ""
    
    @State private var selectedPicType: String = ""
    let types = ["Mężczyzna", "Kobieta", "Inne","Zwierze"]
    
    
    
    var body: some View {
        VStack{
            
            HStack(alignment: .top,spacing: 200){
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .font(.system(size: 30))
                        .frame(alignment: .top)
                }
                .padding()
                
                
                
                Button(action: {
                    
                    if(!name.isEmpty && !surname.isEmpty && !selectedPicType.isEmpty){
                        addProfile()
                        dismiss()
                    }else{
                        showAlert = true
                        alertText = "Źle uzupełnione pola"
                    }
                    
                    
                    
                }
                       
                       
                ) {
                    Text("GOTOWE")
                        .font(.system(size: 20))
                        .foregroundStyle(K.BrandColors.darkPink1)
                }
                .padding()
                
            }
            .padding(.top)
            
            Text("Dodaj podopiecznego")
                .font(.system(size: 25))
                .padding(.bottom)
            
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
                
                Picker("Płeć", selection: $selectedPicType) {
                    ForEach(types, id: \.self) { gender in
                        Text(gender).tag(gender)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width:350)
                
                
                
                
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        .background(K.BrandColors.lightPink1)
        .navigationBarBackButtonHidden()
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onAppear(){
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"), message: Text(alertText), dismissButton: .default(Text("OK")))
        }
    }
    
    func addProfile(){
        
        profileManager.createProfile(name: name, surname: surname, pictureType: selectedPicType) { profile, error in
            if let profile = profile {
                
                manager.listOfProfiles.append(profile)
                manager.currentProfileSelected = profile
                
                let profileRef = manager.db.collection("profiles").document(profile.uid )
                
                
                
                manager.currentUser?.addProfileReference(profile: profileRef)
                
                // Zapisanie użytkownika do bazy danych
                manager.updateUser(user: manager.currentUser!) { error in
                    if let error = error {
                        print("Błąd podczas aktualizacji użytkownika: \(error.localizedDescription)")
                    } else {
                        print("Użytkownik zaktualizowany pomyślnie w Firestore.")
                    }
                }
                
            } else if let error = error {
                // Obsługa błędu
                print("Błąd przy tworzeniu profilu w Firestore")
            }
        }
    }
}


#Preview {
    AddProfileView (manager: UserManager())
}
