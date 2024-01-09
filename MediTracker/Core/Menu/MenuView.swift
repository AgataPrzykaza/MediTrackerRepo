//
//  MainView.swift
//  MediTracker
//
//  Created by Agata Przykaza on 27/10/2023.
//
//  Główny widok aplikacji zawierający zakładki harmonogramu, wszystkich leków oraz ustwień. Zawiera także odnośnik do bocznego menu aplikacji.
//

import SwiftUI


struct MenuView: View {
    
    @ObservedObject var manager: UserManager
    
    
    @State var sideMenuOpened = false
    
    
    
    var body: some View {
        
        NavigationView{
            
            ZStack{
                
                //MARK: - deklaracja dolnego panelu nawigacyjnego - menu
                TabView {
                    MainView(manager: manager)
                        .frame(height: 620)
                        .tabItem {
                            VStack {
                                Image(systemName: "house")
                                    .foregroundColor(.white)
                                Text("Ekran główny")
                                    .foregroundColor(.white)
                            }
                        }
                    ActiveMeds(manager: manager)
                        .frame(height: 620)
                        .tabItem {
                            VStack {
                                Image(systemName: "pills")
                                    .foregroundColor(.white) 
                                Text("Leki")
                                    .foregroundColor(.white)
                            }
                        }
                    SettingsView(manager: manager)
                        .frame(height: 620)
                        .tabItem {
                            VStack {
                                Image(systemName: "gearshape")
                                    .foregroundColor(.white)
                                Text("Ustawienia")
                                    .foregroundColor(.white)
                            }
                        }
                }
                .accentColor(K.BrandColors.darkPink2) 
                .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
                
                
                SideMenu(userAuth: manager,width: UIScreen.main.bounds.width/1.5, menuOpened: sideMenuOpened, toggleMenu: toggleMenu)
                
                
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
                            
                            MiniProfileView(nameUser: manager.currentProfileSelected?.name ?? "brak", profilePictureType: manager.currentProfileSelected?.pictureType ?? "Inne")
                               
                            Image(systemName: "chevron.down")
                                .foregroundColor(K.BrandColors.darkPink1)
                                
                        }
                        
                        
                        
                    }
                    
                }
                

            }
    
            .navigationBarHidden(self.sideMenuOpened)
            .overlay(
                SideMenu(userAuth: manager,width: 300, menuOpened: sideMenuOpened) {
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
    MenuView(manager: UserManager())
}
