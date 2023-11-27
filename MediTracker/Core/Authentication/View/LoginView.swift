//
//  LoginView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 18/11/2023.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var userAuth: UserManager
    
    
    @State private var goToMenuView = false
    @State var email: String = ""
    @State var password: String = ""
    
    @State private var showAlert = false
    @State var alertText: String = ""
    
    var body: some View {
        
        NavigationStack{
            
            VStack{
                
                //Email textfield ----------------------------------------------
                TextField("Email", text: $email)
                    .font(.system(size: 22))
                    .frame(width: 275, height: 44)
                    .background(.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .autocorrectionDisabled()
                
                Spacer()
                    .frame(height:50)
                
                //hasło field ----------------------------------------------------------
                SecureField("Hasło", text: $password)
                    .font(.system(size: 22))
                    .frame(width: 275, height: 44)
                    .background(.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .autocorrectionDisabled()
                    .padding(.bottom,50)
                
                
                Spacer()
                    .frame(height:23)
                
                //Przejście do głównego widoku aplikacji
                Button(action: {
                    
                    validationAndLogin()
                    
                }) {
                    HStack {
                        Text("Dalej")
                            .font(.system(size: 22))
                            .frame(width: 75, height: 25)
                            .bold()
                        Image(systemName: "arrow.right.circle")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(K.BrandColors.intensePink2)
                    .cornerRadius(24)
                }
                .navigationDestination(isPresented: $goToMenuView){
                    MenuView(userAuth: userAuth)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Uwaga"), message: Text(alertText))
                }
                
                
                
                
                
                
                
                
            }
            .navigationBarBackButtonHidden(true)
            
            .padding(.bottom,100)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [K.BrandColors.lightPink1, K.BrandColors.pink1]), startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea()
            
            .navigationTitle("Logowanie")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(.blue)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("Custom Action")
                        // 2
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(K.BrandColors.darkerPink)
                            Text("Cofnij")
                                .foregroundColor(K.BrandColors.darkerPink)
                                .bold()
                        }
                    }
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
    func validationAndLogin(){
        if isValidEmail(email){
            
            if checkLengthOfPassword(password: password){
                
                userAuth.login(email: email, password: password){ success, error in
                    
                    if success {
                        goToMenuView = true
                    } else {
                        if let error = error {
                            print(error)
                        }
                    
                        alertText = "Nieprawidłowe dane do logowania"
                        
                        showAlert = true
                    }
                }
                
            }
            else{
                
                alertText = "Za krótkie hasło"
                showAlert = true
                
            }
            
        }
        else{
            alertText = "Nieporawny email"
            showAlert = true
        }
    }
}



#Preview {
    LoginView(userAuth: UserManager())
}
