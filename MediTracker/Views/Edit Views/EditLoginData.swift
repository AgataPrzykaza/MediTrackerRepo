//
//  EditLoginData.swift
//  MediTracker
//
//  Created by Agata Przykaza on 09/11/2023.
//

import SwiftUI

struct EditLoginData: View {
    
    @Environment(\.dismiss) var dismiss
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
                    
                }) {
                    Text("Zapisz")
                        .font(.system(size: 20))
                        .foregroundStyle(K.BrandColors.darkPink1)
                }
                .padding()
                
                
            }
            
            
            Text("Zarządzaj kontem")
                .frame(width: 400,height: 45,alignment: .center)
                .font(.system(size: 25))
                .padding(.bottom, 50)
                .bold()
            
            //mail
            HStack{
                Image(systemName: "envelope")
                    .font(.system(size: 30))
                TextField("mail", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .frame(width: 300,height: 40)
                    .autocorrectionDisabled()
                    .onSubmit {
                        
                    }
            }
            .padding(.bottom,30)
            
            //nowe haslo
            Text("Nowe hasło")
                .font(.system(size: 23))
            HStack{
                
                Image(systemName: "lock.square.fill")
                    .font(.system(size: 35))
                
                SecureField(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Label@*/"Password"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("Apple")/*@END_MENU_TOKEN@*/)
                    .frame(width: 300,height: 40)
            
            }
            .padding(.bottom,30)
            
            //potwierdzenie hasla
            Text("Potwierdź hasło")
                .font(.system(size: 23))
            HStack{
                
                Image(systemName: "lock.square.fill")
                    .font(.system(size: 35))
                
                SecureField(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Label@*/"Password"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("Apple")/*@END_MENU_TOKEN@*/)
                    .frame(width: 300,height: 40)
            
            }
             
            
            
               
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        .navigationBarBackButtonHidden()
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    EditLoginData()
}
