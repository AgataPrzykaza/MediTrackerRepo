//
//  SideMenu.swift
//  MediTracker
//
//  Created by Agata Przykaza on 01/11/2023.
//

import SwiftUI


struct SideMenu: View {
    
    @ObservedObject var userAuth: UserAuthManager
    
    let width: CGFloat
    let menuOpened: Bool
    let toggleMenu: () -> Void
    
    
    
    var body: some View {
        
        ZStack{
            
            //Dimmed backgroud view
            GeometryReader{ _ in
                EmptyView()
                
            }
            .background(Color.gray.opacity(0.25))
            .opacity(self.menuOpened ? 1 : 0)
            .onTapGesture {
                withAnimation(Animation.easeIn.delay(0.25)) {
                    self.toggleMenu()
                }
            }
            
            //Menu Content
            HStack{
                MenuContent(userAuth: userAuth,nameUser: "Ala", profilePerson: "woman")
                    .frame(width: width)
                    .offset(x: menuOpened ? 0 : -width)
                    .onTapGesture {
                            withAnimation {
                                self.toggleMenu()
                            }
                        }
                
                Spacer()
            }
           
        }
        .edgesIgnoringSafeArea(.all)
        
        
    }
}


