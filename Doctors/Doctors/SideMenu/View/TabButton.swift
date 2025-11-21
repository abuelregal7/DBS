//
//  TabButton.swift
//  Doctors
//
//  Created by Ahmed Abo Al-Regal on 23/03/2024.
//

import SwiftUI

struct TabButton: View {
    
    // MARK: - PROPERTYS
    var image: String
    var title: String
    @Binding var selectedTab : String
    var animation: Namespace.ID
    // MARK: - Body
    var body: some View {
        Button(action: {
            withAnimation(.spring()){selectedTab = title}
        }, label: {
            HStack(spacing:15){
                Image(systemName: image)
                    .font(.title2)
                    .frame(width: 30)
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.custom(GFFonts.SeguiSemiBold, size: 16))
                    .foregroundColor(.white)
            }
            .foregroundColor(selectedTab == title ? Color("blue"):.white)
            .padding(.vertical,12)
            .padding(.horizontal,20)
            .background(
                Color.black.opacity(0.2)
                    .opacity(selectedTab == title ? 1 : 0)
                    .clipShape(RoundedCorner(radius: 12, corners: [.topRight,.bottomRight]))
            )
        })
    }
}

#Preview {
    SideMenuView()
}
