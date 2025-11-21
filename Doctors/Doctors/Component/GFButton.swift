//
//  GFButton.swift
//  Doctors
//
//  Created by Ahmed Abo Al-Regal on 2023-10-10.
//

import SwiftUI

struct GFButton: View {
    @Binding var isLoading: Bool
    @State private var isAnimating: Bool = false
    @State private var startLoader: Bool = false
    
    var text: String
    var backgroundColor: Color
    var foregroundColot: Color
    var clouser: () -> Void
    
    var body: some View {
        Button {
            clouser()
        } label: {
            if startLoader {
                LoaderView()
            } else {
                Text(text)
                    .font(.system(size: 16, weight: .bold))
                    .padding(.horizontal, 32)
                    .lineLimit(0)
                    .minimumScaleFactor(0.7)
                    .foregroundColor(foregroundColot)
                    .frame(
                        maxWidth: isAnimating ? 48 : .infinity,
                           minHeight: 48,
                        maxHeight: 48)
                    .background {
                        backgroundColor
                    }
                    .cornerRadius(isAnimating ? 24 : 8)
            }
        }
        .onChange(of: isLoading, perform: { value in
            configure_onChange(value: value)
        })
    }
    
    private func configure_onChange(value: Bool) {
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            isAnimating = true
        }
        if value == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                startLoader = true
            }
        } else {
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                startLoader = false
                isAnimating = false
            }
        }
    }
}

struct GFButton_Previews: PreviewProvider {
    @State private static var isLoading = false

    static var previews: some View {
        GFButton(isLoading: $isLoading, text: "Test", backgroundColor: .gray, foregroundColot:.white) {
            print("Test")
        }
    }
}
