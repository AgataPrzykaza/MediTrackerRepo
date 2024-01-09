//
//  SideMenu.swift
//  MediTracker
//
//  Created by Agata Przykaza on 01/11/2023.
//
// Widok bocznego menu
import SwiftUI


struct SideMenu: View {
    
    @ObservedObject var userAuth: UserManager
    
    
    
    let width: CGFloat
    var menuOpened: Bool
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
                MenuContent(manager: userAuth)
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


