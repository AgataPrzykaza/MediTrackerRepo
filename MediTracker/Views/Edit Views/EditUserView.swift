//
//  EditUserView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 01/12/2023.
//
// Widok aktualizujący dane użytkownika

import SwiftUI

struct EditUserView: View {
    @ObservedObject var manager: UserManager
    @Environment(\.dismiss) var dismiss
    @State var name = ""
    @State var surname = ""
    
    @State var showAlert = false
    @State var alertText = ""
    
    @State private var selectedType: String = "Mężczyzna"
    let types = ["Mężczyzna", "Kobieta", "Inne"]
    
    init(manager: UserManager) {
            self.manager = manager
            
            _name = State(initialValue: manager.currentUser?.name ?? "")
        _surname = State(initialValue: manager.currentUser?.surname ?? "")
        _selectedType = State(initialValue: manager.currentUser?.gender ?? "")
        
        }
    
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
                
                Text("Edytuj dane")
                    .font(.system(size: 25))
                    .padding()
                
                Button(action: {
                    
                    if !name.isEmpty && !surname.isEmpty && !selectedType.isEmpty{
                        updateCurrentUserData()
                        
                        manager.updateUser(user: manager.currentUser!) { error in
                            if let error = error {
                                print("Błąd aktualizacji danych użytkownika: \(error.localizedDescription)")
                            } else {
                                print("Dane użytkownika zaktualizowane pomyślnie!")
                                
                            }
                        }
                        dismiss()
                        
                    }else{
                        showAlert = true
                        alertText = "Pozostały puste pole!"
                    }
                    
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"), message: Text(alertText), dismissButton: .default(Text("OK")))
        }
    }
    
    func updateCurrentUserData(){
        manager.currentUser?.updateName(name)
        manager.currentUser?.updateSurname(surname)
        manager.currentUser?.updateGender(selectedType)
    }
}

#Preview {
    EditUserView(manager: UserManager())
}
