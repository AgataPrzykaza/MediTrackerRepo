//
//  RegisterView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 24/10/2023.
//

import SwiftUI

struct RegisterView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
                    
                    TextField("Pseudonim", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 22))
                        .frame(width: 275, height: 44)
                        .background(.white)
                        .cornerRadius(12)
                    
                    Spacer()
                        .frame(height:23)
                    
                    TextField("Email", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 22))
                        .frame(width: 275, height: 44)
                        .background(.white)
                        .cornerRadius(12)
                    Spacer()
                        .frame(height:23)
                    
                    TextField("Hasło", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 22))
                        .frame(width: 275, height: 44)
                        .background(.white)
                        .cornerRadius(12)
                    
                    Spacer()
                        .frame(height:23)
                    
                    TextField("Potwierdzenie hasła", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 22))
                        .frame(width: 275, height: 44)
                        .background(.white)
                        .cornerRadius(12)
                    
                    
                }
                
                //MARK: - Przycisk kontynuujący
                HStack {
                    Spacer()
                        .frame(width: 230)
                    NavigationLink(destination: MenuView()) {
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

                    
                    
                }
                .offset(y:80)
                
                
                
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


#Preview {
    RegisterView()
}
