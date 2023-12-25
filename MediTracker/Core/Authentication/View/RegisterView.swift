//
//  RegisterView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 24/10/2023.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

struct RegisterView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var userAuth: UserManager
    
    
    @State private var isNextViewActive = false
    @State private var showAlert = false
    @State var alertText: String = ""
    
    @State var name: String = ""
    @State var email: String = ""
    @State var surname: String = ""
    @State var password: String = ""
    @State var passwordAgain: String = ""
    
    @State private var selectedGender: String = "Mężczyzna"
    let genders = ["Mężczyzna", "Kobieta", "Inne"]
    
    var body: some View {
        
        NavigationView{
            VStack {
                
                Text("Podaj swoje dane")
                    .bold()
                    .foregroundColor(.white)
                    .font(.system(size: 35))
                
                Spacer()
                    .frame(height:40)
                //MARK: - Pola do rejestracji
                VStack {
                    //Imie textfield ---------------------------------------
                    TextField("Imie", text: $name)
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                        .frame(width: 275, height: 44)
                        .background(.white)
                        .cornerRadius(12)
                        .autocorrectionDisabled()
                    
                    
                    Spacer()
                        .frame(height:23)
                    //nazwisko textfield -------------------------------
                    TextField("Nazwisko", text: $surname)
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                        .frame(width: 275, height: 44)
                        .background(.white)
                        .cornerRadius(12)
                        .autocorrectionDisabled()
                    
                    
                    Spacer()
                        .frame(height:23)
                    
                    //Plec wybrana
                    Text("Wybierz płeć")
                        .font(.system(size: 22))
                        .foregroundColor(K.BrandColors.darkPink2)
                    
                    Picker("Płeć", selection: $selectedGender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender).tag(gender)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width:300)
                    
                    Spacer()
                        .frame(height:23)
                    //Email textfield ----------------------------------------------
                    TextField("Email", text: $email)
                        .font(.system(size: 22))
                        .frame(width: 275, height: 44)
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                        .autocorrectionDisabled()
                    
                    Spacer()
                        .frame(height:23)
                    
                    //hasło textfield ----------------------------------------------------------
                    SecureField("Hasło", text: $password)
                        .font(.system(size: 22))
                        .frame(width: 275, height: 44)
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                        .autocorrectionDisabled()
                    
                    
                    Spacer()
                        .frame(height:23)
                    //Potwierdzenie hasła -----------------------------------------------------------
                    SecureField("Potwierdzenie hasła", text: $passwordAgain)
                        .font(.system(size: 22))
                        .frame(width: 275, height: 44)
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                        .autocorrectionDisabled()
                    
                    
                }
                HStack {
                    
                    Spacer()
                        .frame(width: 230)
                    
                    Button(action: {
                        
                        let validation = checkedAllFields(name: name, surname:surname, email: email, password: password, passwordAgain: passwordAgain)
                        
                        if validation.1{
                            //wszystkie pola sa uzupelnione
                            
                            userAuth.createUser(email: email, password: password, name: name, surname: surname, gender: selectedGender) { success, errorMessage in
                                if success {
                                   
                                    isNextViewActive = true
                                } else {
                                    // Wystąpił błąd, wyświetl errorMessage
                                    print("Błąd w tworzeniu \(errorMessage ?? "")")
                                    alertText = "Taki mail już istnieje"
                                    showAlert = true
                                    
                                }
                            }

                        
                           
                        }
                        else{
                            alertText = validation.0
                            showAlert = true
                        }
                        
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
                    .navigationDestination(isPresented: $isNextViewActive){
                        MenuView(manager:userAuth)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Uwaga"), message: Text(alertText))
                    }
                    
                    
                }
                .offset(y: 80)
                
                
            }
            .navigationBarBackButtonHidden(true)
            
            .padding(.bottom,100)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [K.BrandColors.lightPink1, K.BrandColors.pink1]), startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea()
            
            .navigationTitle("Rejestracja")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(.blue)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            
            //MARK: - Implementacja przycisku cofnij
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
}


//Sprawdzenie wszystkich pól
func checkedAllFields(name:String, surname:String,email:String,password:String,passwordAgain:String) -> (String,Bool) {
    
    if name.isEmpty || surname.isEmpty || email.isEmpty || password.isEmpty || passwordAgain.isEmpty{
        
        return ("Zostały nie uzupełnione pola!",false)
    }
    else{
        if checkLengthOfName(name: name) && checkLengthOfName(name: surname){
            
            if isValidEmail(email){
                
                if checkLengthOfPassword(password: password) && samePassword(password: password, passwordAgain: passwordAgain){
                    return ("",true)
                }
                else{
                    return ("Niepoprawne hasła", false)
                }
                
            }
            else
            {
                return ("Nieporawny email",false)
            }
            
        }
        else{
            return ("Nieporawne imie badź nazwisko",false)
        }
        
        
    }
}

func checkLengthOfName(name:String) -> Bool{
    if name.count>1{
        return true
    }
    else
    {
        return false
    }
}
//Walidacja emaila
func isValidEmail(_ email: String) -> Bool {
    // Wyrażenie regularne do sprawdzania poprawności adresu e-mail
    let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}

//Sprawdzenie czy dwa hasła są takie same
func samePassword(password: String, passwordAgain: String) -> Bool{
    if password == passwordAgain{
        return true
    }
    else{
        return false
    }
}
//Sprawdzenie długości hasła
func checkLengthOfPassword(password: String) -> Bool{
    if password.count > 6{
        return true
    }
    else{
        return false
    }
}



#Preview {
    RegisterView( userAuth: UserManager())
}
