//
//  EditLoginData.swift
//  MediTracker
//
//  Created by Agata Przykaza on 09/11/2023.
//

import SwiftUI

struct EditLoginData: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var manager: UserManager
    
    @State var email: String = ""
   
    @State var password: String = ""
    @State var oldPassword: String = ""
    @State var passwordAgain: String = ""
    
    @State var showAlert = false
    @State var alertText = ""
    
    init(manager: UserManager) {
            self.manager = manager
            
            _email = State(initialValue: manager.currentUser?.email ?? "")
        }
    var body: some View {
        
        VStack(){
            
            HStack(alignment: .center,spacing: 180){
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
                    
                    updateUserData()
                    
                }) {
                    Text("Zapisz")
                        .font(.system(size: 20))
                        .foregroundStyle(K.BrandColors.darkPink1)
                }
                .padding()
                
                
            }
            
            
            Text("Zmień hasło")
                .frame(width: 400,height: 45,alignment: .center)
                .font(.system(size: 25))
                .padding(.bottom, 30)
                .bold()
            
        
            //stare haslo
            Text("Stare hasło")
                .font(.system(size: 23))
            HStack{
                
                Image(systemName: "lock.square.fill")
                    .font(.system(size: 35))
                
                SecureField("Hasło", text: $oldPassword)
                    .frame(width: 300,height: 40)
            
            }
            .padding(.bottom,30)
            //nowe haslo
            Text("Nowe hasło")
                .font(.system(size: 23))
            HStack{
                
                Image(systemName: "lock.square.fill")
                    .font(.system(size: 35))
                
                SecureField("Hasło", text: $password)
                    .frame(width: 300,height: 40)
            
            }
            .padding(.bottom,30)
            
            //potwierdzenie hasla
            Text("Potwierdź hasło")
                .font(.system(size: 23))
            HStack{
                
                Image(systemName: "lock.square.fill")
                    .font(.system(size: 35))
                
                SecureField("Ponownie hasło", text: $passwordAgain)
                    .frame(width: 300,height: 40)
            
            }
             
            
            
               
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
    
    func updateUserData(){
       
            
            if !password.isEmpty && !passwordAgain.isEmpty && samePassword(password: password, passwordAgain: passwordAgain) && checkLengthOfPassword(password: password) && checkLengthOfPassword(password: passwordAgain){
                
                manager.updatePassword(newPassword: password, currentPassword: oldPassword) { success, error in
                    if success{
                        
                        alertText = "Dane zostały zmienione"
                        showAlert = true
                        
                    }
                    else{
                        alertText = "Nie udało się zmienić danych"
                        showAlert = true
                        print("Błąd: \(error)")
                    }
                }
                
            }
            else
            {
              
                alertText = "Hasła niepoprawne"
                showAlert = true
            }
            
        
        
        
        
    }
}

#Preview {
    EditLoginData(manager: UserManager())
}
