//
//  ScannerView.swift
//  Doctors
//
//  Created by Ahmed Abo Al-Regal on 05/05/2024.
//

import SwiftUI

struct ScannerView: View {
    var body: some View {
        VStack{
            Spacer()
            Text("Upload Your X-ray")
                .font(.custom(GFFonts.SeguiBold, size: 24))
                .foregroundColor(Colors.main)
            //rayScannerView(image: "center", buttonAction: {})
            Spacer()

        }
    }
}

#Preview {
    ScannerView()
}
