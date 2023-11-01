//
//  SideMenu.swift
//  MediTracker
//
//  Created by Agata Przykaza on 01/11/2023.
//

import SwiftUI


struct MenuContent: View{
    
 
   
    var body: some View {
        ZStack{
            Color(.blue)
            
            VStack(alignment: .leading,spacing: 0){
                
                Text("halo side menu")
                
            }
            .padding(.top,50)
        }
    }
}



struct SideMenu: View {
    
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
                MenuContent()
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


