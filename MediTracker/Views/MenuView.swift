//
//  MainView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 27/10/2023.
//

import SwiftUI


struct MenuView: View {
    
    
    
    @State var nameUser: String = "ALA"
    @State var profilePerson = "man"
    
    @State var sideMenuOpened = false
    
    var body: some View {
        
        NavigationView{
            
            ZStack{
                
                //MARK: - deklaracja dolnego panelu nawigacyjnego - menu
                TabView {
                    MainView()
                        .tabItem {
                            VStack {
                                Image(systemName: "house")
                                    .foregroundColor(.white) // Ustawianie koloru dla pierwszego symbolu
                                Text("Ekran główny")
                                    .foregroundColor(.white) // Ustawianie koloru dla tekstu
                            }
                        }
                    ListOfDrugsView()
                        .tabItem {
                            VStack {
                                Image(systemName: "pills")
                                    .foregroundColor(.white) // Ustawianie koloru dla drugiego symbolu
                                Text("Leki")
                                    .foregroundColor(.white) // Ustawianie koloru dla tekstu
                            }
                        }
                }
                .accentColor(K.BrandColors.darkPink2) // Ustawianie koloru akcentu dla całej TabView
                
                
                 SideMenu(width: UIScreen.main.bounds.width/1.5, menuOpened: sideMenuOpened, toggleMenu: toggleMenu)
                
                
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
                            MiniProfileView(nameUser: nameUser, profilePictureType: profilePerson)
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
                SideMenu(width: 300, menuOpened: sideMenuOpened) {
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






#Preview {
    MenuView()
}
