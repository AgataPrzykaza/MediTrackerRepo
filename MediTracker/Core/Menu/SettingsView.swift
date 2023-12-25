//
//  SettingsView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 24/12/2023.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var manager: UserManager
    
    @State private var showAlert = false
    @State private var alertText = ""
    
    var body: some View {
        VStack(alignment: .leading,spacing: 35) {
            
            VStack(alignment: .leading){
                Text("Dane użytkownika")
                    .bold()
                    .foregroundColor(K.BrandColors.intensePink2)
                    .font(.system(size: 28))
                    .padding(.bottom)
                Group {
                    Text("Imię: \(manager.currentUser?.name ?? "brak danych")")
                    Text("Nazwisko: \(manager.currentUser?.surname ?? "brak danych")")
                    Text("E-mail: \(manager.currentUser?.email ?? "brak danych")")
                    Text("Płeć: \(manager.currentUser?.gender ?? "brak danych")")
                }
                .font(.system(size: 24))
                .foregroundColor(K.BrandColors.darkPink1)
            }
            .padding(.bottom, 30)
            Button(action: {
                
                removeProfile()
                
            }) {
                Text("Usuń bieżący profil leków")
                    .font(.system(size: 25, weight: .bold))
                    .frame(minWidth: 0, maxWidth: 350,minHeight: 60)
                    .background(K.BrandColors.darkPink2)
                    .foregroundStyle(.white)
                    .cornerRadius(24)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Alert"), message: Text(alertText), dismissButton: .default(Text("OK")))
            }
            
            NavigationLink("Edytuj dane logowania", destination: EditLoginData( manager: manager))
                .font(.system(size: 25, weight: .bold))
                .frame(minWidth: 0, maxWidth: 350,minHeight: 50)
                .background(K.BrandColors.intensePink2)
                .foregroundStyle(.white)
                .cornerRadius(24)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(K.BrandColors.lightPink1)
    }
    
    func removeProfile(){
        
        if checkIfOnlyOneProfile(){
            
            alertText = "Nie można usunąć.Został jeden profil."
            
            
        }
        else{
            manager.deleteProfile(profile: manager.currentProfileSelected!) { error in
                if let error = error {
                    
                    print("Błąd: \(error)")
                    alertText = "Nie udało się usunąć profilu."
                    
                    
                } else {
                    
                    alertText = "Profil usunięty."
                    
                }
            }
        }
        
        showAlert = true
        return
        
    }
    
    
    func checkIfOnlyOneProfile() -> Bool{
        if manager.listOfProfiles.count <= 1{
            return true
        }
        return false
        
    }
}

#Preview {
    SettingsView(manager: UserManager())
}
