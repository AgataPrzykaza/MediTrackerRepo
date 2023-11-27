//
//  MainView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 27/10/2023.
//

import SwiftUI


struct MenuView: View {
    
    @ObservedObject var userAuth: UserManager
    
    
    @State var sideMenuOpened = false
    
    
    
    var body: some View {
        
        NavigationView{
            
            ZStack{
                
                //MARK: - deklaracja dolnego panelu nawigacyjnego - menu
                TabView {
                    MainView()
                        .frame(height: 620)
                        .tabItem {
                            VStack {
                                Image(systemName: "house")
                                    .foregroundColor(.white) // Ustawianie koloru dla pierwszego symbolu
                                Text("Ekran główny")
                                    .foregroundColor(.white) // Ustawianie koloru dla tekstu
                            }
                        }
                    ListOfDrugsView()
                        .frame(height: 620)
                        .tabItem {
                            VStack {
                                Image(systemName: "pills")
                                    .foregroundColor(.white) 
                                Text("Leki")
                                    .foregroundColor(.white)
                            }
                        }
                }
                .accentColor(K.BrandColors.darkPink2) // Ustawianie koloru akcentu dla całej TabView
                .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
                
                
                SideMenu(userAuth: userAuth,width: UIScreen.main.bounds.width/1.5, menuOpened: sideMenuOpened, toggleMenu: toggleMenu)
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [K.BrandColors.lightPink1, K.BrandColors.lightPink2]), startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea()
            .toolbar {
                
                //MARK: - panel nawigacyjny górny
                //deklaracja miniaturki
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        
                        // uruchomienie menu pobocznego
                        self.sideMenuOpened.toggle()
                        
                    }) {
                        HStack{
                            
                            MiniProfileView(nameUser: userAuth.currentUser?.name ?? "brak", profilePictureType: userAuth.currentUser?.gender ?? "Inne")
                               
                            Image(systemName: "chevron.down")
                                .foregroundColor(K.BrandColors.darkPink1)
                        }
                        .padding(.top)
                    }
                    
                }
                
                //deklaracja przycisku ustawien
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button {
                        
                        
                        
                    } label: {
                        HStack {
                            
                            Image(systemName: "gearshape")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(K.BrandColors.darkerPink)
                                .frame(width: 40, height: 40)
                            
                            
                            
                        }
                    }
                }
            }
            .navigationBarHidden(self.sideMenuOpened) // Ukryj pasek nawigacji, gdy menu jest otwarte
            .overlay(
                SideMenu(userAuth: userAuth,width: 300, menuOpened: sideMenuOpened) {
                    withAnimation {
                        self.sideMenuOpened.toggle()
                    }
                }
            )
            
            
            
            
            
            
        }
        .navigationBarBackButtonHidden(true)
        
        
        
        
    }
    //zmiana zmiennej na odwrotna - czy menu poboczne otwarte
    func toggleMenu(){
        sideMenuOpened.toggle()
    }
    
    
}






//#Preview {
//    MenuView()
//}
