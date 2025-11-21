//
//  OnboardingView.swift
//  Doctors
//
//  Created by Ahmed Abo Al-Regal on 2023-10-27.
//

import SwiftUI

struct OnboardingView: View {
    // MARK: - PROPERTYS
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    
    private var data = OnbordingModel.onboardingData
    
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80
    @State private var buttonOffset: CGFloat = 0
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    @State private var currentStep: Int = 0
    @State private var isAnimating: Bool = false
    
    @State private  var isLoading = false
    
    
    
    
    // MARK: - VIEW
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                tabView()
                currentPage()
                footer()
                    .padding(.horizontal, 32)
            }
            .padding(.top, 64)
            .padding(.bottom, 32)
        }
    }
    
    // MARK: - TABVIEW
    private func tabView() -> some View {
        TabView(selection: $currentStep) {
            ForEach(data) { tab in
                VStack(spacing: 32) {
                    tab.image
                        .resizable()
                        .scaledToFit()
                    
                    VStack(spacing: 16) {
                        Text(tab.title)
                            .font(.custom(GFFonts.SeguiSemiBold, size: 24))
                            .foregroundColor(Color.black)
                        
                        Text(tab.descrption)
                            .font(.custom(GFFonts.Segui, size: 16))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray.opacity(0.7))
                            .padding(.horizontal)
                    }
                }
                .tag(tab.id)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(Animation.easeInOut(duration: 1.0), value: isAnimating)
        .onChange(of: isAnimating, perform: { _ in
            isAnimating = false
        })
    }
    
    // MARK: - CURRENT PAGE
    
    private func currentPage() -> some View {
        HStack {
            ForEach(data.indices, id: \.self) { index in
                if index == currentStep {
                    Rectangle()
                        .fill(Colors.main)
                        .frame(width: 20, height: 8)
                        .cornerRadius(10)
                } else {
                    Rectangle()
                        .frame(width: 8, height: 8)
                        .cornerRadius(10)
                        .foregroundColor(.gray.opacity(0.7))
                }
            }
        }
        .padding(.bottom)
    }
    
    // MARK: - FOOTER
    private func footer() -> some View {
        VStack (spacing:16){
            if currentStep < data.count  {
                GFButton(isLoading: $isLoading, text: "Next", backgroundColor: Colors.main, foregroundColot: Color.white) {
                    if currentStep < data.count - 1 {
                        isAnimating = true
                        currentStep += 1
                    } else {
                        isOnboardingViewActive = false
                    }
                }
            }
            
            Button {
                isOnboardingViewActive = false
            } label: {
                Text("Skip")
                    .font(.custom(GFFonts.popinsBold, size: 16))
                    .foregroundColor(Color.gray)
            }
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
