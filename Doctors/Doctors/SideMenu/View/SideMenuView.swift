//
//  SideMenuView.swift
//  Doctors
//
//  Created by Ahmed Abo Al-Regal on 23/03/2024.
//

import SwiftUI

struct SideMenuView: View {
    // MARK: - PROPERTYS
    @State  var selectedTab = "Home"
    @State var showMenu = false
    @Namespace var animation
        
    // MARK: - Body
    var body: some View {
        ZStack{
            Colors.MenuBar
                .ignoresSafeArea()
            //menuside
            MenuSide(selectedTab: $selectedTab, animation: animation, showMenue: $showMenu)
            
            ZStack {
                //two bkg cards
                Color.white
                    .opacity(0.5)
                    .cornerRadius(showMenu ? 15 : 0)
                //shadow
                    .shadow(color: .black.opacity(0.07), radius: 5)
                    .offset(x: showMenu ? -25 : 0)
                    .padding(.vertical,30)
            
                Color.white
                    .opacity(0.5)
                    .cornerRadius(showMenu ? 15 : 0)
                //shadow
                    .shadow(color: .black.opacity(0.07), radius: 5)
                    .offset(x: showMenu ? -50 : 0)
                    .padding(.vertical,60)
                

                Home(selectedTab: $selectedTab, buttonAction: {
                    showMenu.toggle()                    
                })
                    .cornerRadius(showMenu ? 15 : 0)
            }
            //scalling and moving
            .scaleEffect(showMenu ?  0.84 : 1 )
            .offset(x: showMenu ? UIScreen.main.bounds.width - 120 : 0)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    SideMenuView()
}
