//
//  LoaderView.swift
//  Doctors
//
//  Created by Ahmed Abo Al-Regal on 2023-10-13.
//

import SwiftUI

struct LoaderView: View {
    @State private var showSpinner:Bool = false
    @State private var degree:Int = 270
        
    var body: some View {
        Circle()
            .fill(Colors.main)
            .overlay {
                Circle()
                    .trim(from: 0.0, to: 0.6)
                    .stroke(
                        style:
                            StrokeStyle(
                                lineWidth: 2,
                                lineCap: .round,
                                lineJoin: .round
                            )
                    )
                    .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: showSpinner)
                    .rotationEffect(Angle(degrees: Double(degree)))
                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: showSpinner)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
                    .onAppear {
                        showSpinner = true
                        degree = 270 + 360
                    }
            }
            .frame(width: 48)
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
